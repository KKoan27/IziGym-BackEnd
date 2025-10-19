import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'Mongo_Conn.dart';
import 'MODELOS/Exercicio.dart';
import 'MODELOS/Usuario.dart';

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
