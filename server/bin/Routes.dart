import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'dart:convert';
import 'package:mongo_dart/mongo_dart.dart';
import 'Mongo_Conn.dart';
import 'MODELOS/Exercicio.dart';
import 'MODELOS/Usuario.dart';

class Endpoint {
  Handler get handler {
    final rout = Router();

    // rout.get("/exercicios", (Request request) {
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
        case "Register":
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

        case "AuthUser":
          try {
            var auth = await collection.findOne({'email': body!['email']});
            print(auth);

            if (auth?['email'] != body['email']) {
              return Response.unauthorized("Email incorreto");
            } else if (auth?['senha'] != body['senha']) {
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

    rout.get("/getExercicios", (Request request) async {
      Db db = await MongoConn.database;
      DbCollection collection = db.collection("Exercicios");

      try {
        var exList = await collection.find().toList();
        for (int i = 0; i < exList.length; i++) {
          print(exList[i]);
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
