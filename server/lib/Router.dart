import 'dart:async';
import 'dart:convert';
import 'package:server/Controllers/UserController.dart';
import 'package:server/Controllers/TreinosController.dart';
import 'package:server/Controllers/ExercicioController.dart';
import 'package:server/data/DAO/ExercicioDAO.dart';
import 'package:server/data/DAO/UserDAO.dart';
import 'package:server/data/DAO/TreinoDAO.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:server/data/Mongo_Conn.dart';
import 'Models/ExercicioModel.dart';
import 'Models/UserModel.dart';
import 'Models/TreinoModel.dart';

class Endpoint {
  final Exerciciocontroller exercicioctrl;
  final UserController userctrl;
  final Treinoscontroller treinoctrl;
  Endpoint({
    required this.exercicioctrl,
    required this.userctrl,
    required this.treinoctrl,
  });

  Handler get handler {
    final rout = Router();
    var resposta;

    rout.post("/user/register", userctrl.Register);
    rout.post("/user/auth", userctrl.Auth);

    rout.post("/treino", treinoctrl.insertTreino);
    

    rout.put("/user", (Request request) async {
      Db db = await MongoConn.database;
      UserModel user;
      try {
        var jsonBody = await returnjson(request);

        if (jsonBody != null) {
          user = UserModel.setting(
            email: jsonBody['email'],
            altura: jsonBody['altura'],
            peso: jsonBody['peso'],
          );
        } else {
          throw Exception("Body da requisição está nula ");
        }

        DbCollection collection = db.collection('Usuarios');

        var userold = await collection.findOne({"email": user.email});
        if (userold != null) {
          print(user.toSetting());
          var result = await collection.updateOne(
            {'_id': userold['_id']},
            {'\$set': user.toSetting()},
          );

          if (!result.hasWriteErrors) {
            return Response.ok("Configurações executadas");
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

    rout.put("/treino", (Request request) async {
      // Variaveis necessarias
      Db db = await MongoConn.database;
      String? query = request.url.queryParameters['TreinoId'];
      var body = await returnjson(request);

      // Validação do corpo e da query
      if (body == null) {
        return Response.badRequest(body: "Corpo vazio/Nulo");
      }
      if (query == null || query.isEmpty) {
        return Response.badRequest(body: "Query vazio/Nulo");
      }

      ObjectId treinoId = ObjectId.fromHexString(query);

      try {
        Map<String, dynamic>? buscaTreino = await db
            .collection('Treinos')
            .findOne({'_id': treinoId});

        if (buscaTreino == null) {
          return Response.badRequest(
            body: 'Treino do usuario não encontrado no BD',
          );
        } else {
          // Extrai a lista de exercícios do corpo da requisição.
          List<dynamic> exercicio = body['exercicios'] as List;

          // Extrai os nomes e já os converte para uma List<String> diretamente.
          final nomeExercicios = exercicio.map((i) => i['nome']).toList();
          List<String> nomeListExercicio = nomeExercicios
              .map((e) => e.toString())
              .toList();

          List<Map<String, dynamic>> resultExercicios = await db
              .collection('Exercicios')
              .find({
                'nome': {'\$in': nomeListExercicio},
              })
              .toList();

          if (resultExercicios.length != nomeListExercicio.length) {
            return Response.badRequest(
              headers: {'Content-type': 'application/json'},
              body: 'Os exercicios não existem no Banco de dados',
            );
          } else {
            final mapaDeExercicios = <String, ExercicioModel>{};
            for (final docExercicio in resultExercicios) {
              final nome = docExercicio['nome'] as String;
              final musculosStringList = List<String>.from(
                docExercicio['musculosAlvo'] as List,
              );

              mapaDeExercicios[nome] = ExercicioModel(
                nome: nome,
                musculosAlvo: musculosStringList,
                descricao: docExercicio['descricao'],
                execucao: docExercicio['execucao'],
              );
            }

            final List<ItemTreino> itensTreino = [];
            // A variável "exercicio" é a List<dynamic> vinda do body.
            for (final itemExercicioRequisicao in exercicio) {
              final nomeExercicio = itemExercicioRequisicao['nome'] as String;

              final exercicioCompleto = mapaDeExercicios[nomeExercicio];

              // Verificação de segurança, embora a validação anterior já deva garantir isso.
              if (exercicioCompleto != null) {
                itensTreino.add(
                  ItemTreino(
                    exercicio: exercicioCompleto, // Objeto correto associado!
                    repeticoes: itemExercicioRequisicao['repeticoes'] as int,
                    intervalo: itemExercicioRequisicao['intervalo'] as int,
                  ),
                );
              }
            }
            TreinoModel treino = new TreinoModel(
              nome: body['nomeTreino'],
              userId: buscaTreino['userId'],
              itemTreino: itensTreino,
            );

            final result = await db
                .collection("Treinos")
                .updateOne({'_id': treinoId}, {'\$set': treino.toJson()});

            if (result.hasWriteErrors) {
              throw Exception("Deu erro na inserção");
            } else {
              return Response.ok(
                "A troca foi bem sucedida : \n TreinoID: $treinoId,\n Nome do Treino : ${treino.nome}",
              );
            }
          }
        }
      } on MongoDartError catch (e, s) {
        print("deu erro no Mongo :  $e \n $s");
      } catch (e, s) {
        print('Deu erro no  PUT  /treino :  $e \n $s');
        return Response.badRequest(body: "$e");
      }
    });
    //Endpoint retornando todos os exercicios ou filtrando com base em um search de pesquisa

    rout.get("/getexercicios", exercicioctrl.listexercicios);


  rout.get('/treino/list', treinoctrl.listTreinos);

    rout.delete("/treino", treinoctrl.deleteTreino);

    return rout;
  }

  // Função para fazer a conversão do body em um dicionario!!
  Future<Map<String, dynamic>?>? returnjson(Request request) async {
    //lendo todo o body do JSON em string no momento
    final body = await request.readAsString();
    //Aqui todo a strign jSon é convertida para um Map(String key :  dynamic valor )
    return jsonDecode(body) as Map<String, dynamic>;
  }
}
