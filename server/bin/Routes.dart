import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'Mongo_Conn.dart';
import 'MODELOS/Exercicio.dart';
import 'MODELOS/Usuario.dart';
import 'MODELOS/Treinos.dart';

class Endpoint {
  Handler get handler {
    final rout = Router();

    //   // ACESSANDO ALGUM QUERYPARAM
    //   String? teste = request.url.queryParameters['nome'];

    //   return Response(200, body: "primeira rota : $teste");
    // });

    // Rota para adicinoar DOC no Banco de dados, ATENÇÃO PARA OS CAMPOS (nome, email, senha) todos são string
    rout.post("/user", (Request request) async {
      Db db = await MongoConn.database;
      Map<String, dynamic>? body = await returnjson(request);
      String resposta = "";
      var collection = db.collection('Usuarios');

      String op = request.url.queryParameters['op']!;

      switch (op) {
        case "register":
          Usuario User = Usuario(
            nome: body?['nome'],
            email: body?['email'],
            senha: body?['senha'],
          );

          try {
            await collection.insertOne(User.toJson());

            resposta = "Valor inserido : ${User.nome}";

            return Response(200, body: "SEGUNDA ROTA :  $resposta");
          } on MongoDartError catch (e) {
            print("ERRO : $e");
            resposta = "Deu ruim na inserção";

            return Response.badRequest(body: resposta);
          }

        case "authuser":
          try {
            var auth = await collection.findOne({"email": body?['email']});
            print(auth);

            if (auth?['email'] = body?['email']) {
              return Response.unauthorized("Email incorreto");
            } else if (auth?['senha'] != body?['senha']) {
              return Response.unauthorized("Senha incorreta");
            } else {
              return Response.ok("Acesso Autorizado!");
            }
          } catch (e) {
            print("ERRO: $e");
          }

        default:
      }
    });

    rout.post("/treino", (Request request) async {
      Db db = await MongoConn.database;

      // =======================================================================
      // ETAPA 1: LER E VALIDAR A REQUISIÇÃO
      // =======================================================================
      var body = await returnjson(request);

      // Validação de segurança: Verifique se os campos principais existem.
      if (body == null ||
          body['nome'] == null ||
          body['nomeTreino'] == null ||
          body['exercicios'] == null) {
        return Response.badRequest(
          body:
              'Formato do JSON inválido ou campos obrigatórios faltando (nome, nomeTreino, exercicios).',
        );
      }

      // Busca o usuário pelo nome fornecido no body
      var user = await db.collection("Usuarios").findOne({
        "nome": body['nome'],
      });
      if (user == null) {
        return Response.notFound(
          'Usuário com o nome "${body['nome']}" não foi encontrado.',
        );
      }

      // Agora, lemos a lista de OBJETOS do body. Esta é a mudança principal.
      final exerciciosRequestDoBody = body['exercicios'] as List<dynamic>;

      if (exerciciosRequestDoBody.isEmpty) {
        return Response.badRequest(
          body: "A lista de exercicios não pode ser vazia.",
        );
      }

      // =======================================================================
      // ETAPA 2: VALIDAR SE OS EXERCÍCIOS EXISTEM NO BANCO DE DADOS
      // =======================================================================

      // Extrai apenas os NOMES da lista de objetos para usar na busca com $in
      final nomesDosExercicios = exerciciosRequestDoBody
          .map((ex) => ex['nome'] as String)
          .toList();

      // Busca no DB APENAS os exercícios que o usuário pediu
      var exerciciosDB = await db.collection("Exercicios").find({
        'nome': {'\$in': nomesDosExercicios},
      }).toList();

      // Sua lógica de validação perfeita: se a contagem não bate, algum exercício é inválido
      if (exerciciosDB.length != nomesDosExercicios.length) {
        Set<String> exerciciosEncontrados = exerciciosDB
            .map((doc) => doc['nome'] as String)
            .toSet();

        List<String> nomesInvalidos = nomesDosExercicios
            .where((nome) => !exerciciosEncontrados.contains(nome))
            .toList();

        return Response.badRequest(
          body:
              'Os seguintes exercicios são inválidos ou não existem: ${nomesInvalidos.join(', ')}',
        );
      } else {
        // =======================================================================
        // ETAPA 3: CONSTRUIR OS OBJETOS DART (SE A VALIDAÇÃO PASSOU)
        // =======================================================================

        // Otimização: Crie um mapa para acessar os dados do DB rapidamente pelo nome.
        final mapaDeExerciciosDoDB = {
          for (var doc in exerciciosDB) doc['nome']: doc,
        };

        // Agora, construa a lista de ItemTreino combinando os dados da requisição e do banco
        List<ItemTreino> itensTreino = [];
        for (var exReq in exerciciosRequestDoBody) {
          final nomeExercicio = exReq['nome'] as String;
          final dadosDoExercicioDoDB = mapaDeExerciciosDoDB[nomeExercicio]!;

          // 1. Cria o objeto Exercicio com os dados completos do banco
          final exercicioObj = Exercicio(
            nome: dadosDoExercicioDoDB['nome'],
            musculosAlvo: (dadosDoExercicioDoDB['musculosAlvo'] as List)
                .cast<String>(),
            descricao: dadosDoExercicioDoDB['descricao'],
            execucao: dadosDoExercicioDoDB['execucao'],
            // dicas: dadosDoExercicioDoDB['dicas'],
          );

          // 2. Cria o ItemTreino com o objeto Exercicio e os dados da requisição
          itensTreino.add(
            ItemTreino(
              exercicio: exercicioObj,
              series: exReq['series'] as int,
              repeticoes: exReq['repeticoes'] as int,
            ),
          );
        }

        // 3. Constrói o objeto Treino final
        Treinos treinoParaSalvar = Treinos(
          nome: body['nomeTreino'],
          userId: (user['_id'] as ObjectId)
              // ignore: deprecated_member_use
              .toHexString(), // Converte ObjectId para String para o modelo
          itemTreino: itensTreino,
        );

        // =======================================================================
        // ETAPA 4: PREPARAR E INSERIR NO BANCO DE DADOS
        // =======================================================================

        final documentoParaInserir = treinoParaSalvar.toJson();

        // Importante: O schema espera um ObjectId, então convertemos a string de volta
        documentoParaInserir['userId'] = user['_id'];

        var result = await DbCollection(
          db,
          "Treinos",
        ).insertOne(documentoParaInserir);

        if (result.isSuccess) {
          return Response.ok(
            "Treino '${body['nomeTreino']}' inserido com sucesso!",
          );
        } else {
          print(result.writeError); // Log do erro para depuração
          return Response.internalServerError(
            body: "Ocorreu um erro ao inserir o Treino no banco de dados.",
          );
        }
      }
    });

    rout.put("/user", (Request request) async {
      Db db = await MongoConn.database;
      Usuario user;
      try {
        var jsonBody = await returnjson(request);

        if (jsonBody != null) {
          user = Usuario(
            nome: jsonBody['nome'],
            email: jsonBody['email'],
            senha: jsonBody['senha'],
          );
        } else {
          throw Exception("Body da requisição está nula ");
        }

        DbCollection collection = db.collection('Usuarios');

        var userold = await collection.findOne({"email": user.email});
        if (userold != null) {
          print(user.toJson());
          var result = await collection.updateOne(
            {'_id': userold['_id']},
            {'\$set': user.toJson()},
          );

          if (!result.hasWriteErrors) {
            return Response.ok(
              "Configurações executadas, o nome anterior alterado foi ${userold['nome']}",
            );
          } else {
            print("Esse print fala que deu erro no mongoDart");
          }
        } else {
          throw Exception("Email não encontrado!");
        }
      } on MongoDartError catch (mongoError) {
        print(
          "Erro na inserção do Mongo : ${mongoError.message}, ${mongoError.mongoCode}",
        );

        throw Response(
          502,
          body:
              ("A requisição passou pro BD mas não foi executado a alteração de fato"),
        );
      } catch (e) {
        print("Deu erro geral : $e");
        throw Response(404, body: "Deu erro geral aqui");
      }
    });

    //Endpoint retornando todos os exercicios ou filtrando com base
    rout.get("/getexercicios", (Request request) async {
      Db db = await MongoConn.database;
      DbCollection collection = db.collection("Exercicios");

      try {
        String? search = request.url.queryParameters['q'];
        var exList;

        if (search == null || search.isEmpty) {
          exList = await collection.find().toList();
        } else {
          exList = await collection.find({
            "nome": {"\$regex": search, "\$options": "i"},
          }).toList();
        }

        return Response.ok(
          jsonEncode(exList),
          headers: {'Content-Type': 'application/json'},
        );
      } on MongoDartError catch (e) {
        return Response.badRequest(
          body: "A busca deu errado \n INFO : $e",
          headers: {'Content-Type': 'application/json'},
        );
      }
    });

    return rout;
  }

  // Função para fazer a conversão do body em um dicionario!!
  Future<Map<String, dynamic>?> returnjson(Request request) async {
    //lendo todo o body do JSON em string no momento
    final body = await request.readAsString();
    //Aqui todo a strign jSon é convertida para um Map(String key :  dynamic valor )
    return jsonDecode(body) as Map<String, dynamic>;
  }
}
