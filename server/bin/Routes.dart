import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'dart:convert';
import 'package:mongo_dart/mongo_dart.dart';
import 'Mongo_Conn.dart';

class Endpoint {
  Handler get handler {
    final rout = Router();

    rout.get("/", (Request request) {
      // ACESSANDO ALGUM QUERYPARAM
      String? teste = request.url.queryParameters['nome'];

      return Response(200, body: "primeira rota : $teste");
    });

    rout.post("/second", (Request request) async {
      Db db = await Mongoconn.database;
      Map<String, dynamic>? teste2 = await returnjson(request);
      String resposta = "";
      var collection = db.collection('Usuarios');

      try {
        await collection.insertOne({
          'nome': teste2?['nome'],
          'email': teste2?['email'],
          'senha': teste2?['senha'],
        });

        resposta = "Valor inserido : ${teste2?['nome']}";

        return Response(200, body: "SEGUNDA ROTA :  $resposta");
      } on MongoDartError catch (e) {
        print("ERRO : $e");
        resposta = "Deu ruim na inserção";

        return Response(500, body: resposta);
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
