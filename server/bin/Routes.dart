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

    rout.get("/", (Request request) {
      // ACESSANDO ALGUM QUERYPARAM
      String? teste = request.url.queryParameters['nome'];

      return Response(200, body: "primeira rota : $teste");
    });

    // Rota para adicinoar DOC no Banco de dados, ATENÇÃO PARA OS CAMPOS (nome, email, senha) todos são string
    rout.post("/second", (Request request) async {
      Db db = await MongoConn.database;
      Map<String, dynamic>? body = await returnjson(request);
      String resposta = "";
      var collection = db.collection('Usuarios');
      Usuario User = Usuario(
        nome: body?['nome'],
        email: body?['email'],
        senha: body?['senha'],
      );

      try {
        await collection.insertOne({
          'nome': User.nome,
          'email': User.email,
          'senha': User.senha,
        });

        resposta = "Valor inserido : ${User.nome}";

        return Response(200, body: "SEGUNDA ROTA :  $resposta");
      } on MongoDartError catch (e) {
        print("ERRO : $e");
        resposta = "Deu ruim na inserção";

        return Response(500, body: resposta);
      }
    });

    rout.get("/getExercicios", (Request request) async {
      Db db = await MongoConn.database;
      DbCollection collection = db.collection("Exercicios");

      var body = await returnjson(request);

     
      db

      await for (var exercicio in collection.find()) {}

      return Response.ok("");
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
