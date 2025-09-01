import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class Rotas {
  Handler get handler {
    final router = Router();

    var db = mongo.Db(
      "mongodb+srv://DELCO:<Senhaforte2711>@cluster0.z3vmnhg.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0",
    );

    db.open();

    // PARA CADA ROTA TEM QUE ENTRA COMO PARAM UM REQ E RETORNAR UM RESPONSE
    //
    router.get("/", (Request request) {
      return Response(200, body: "primeira rota");
    });

    // Aqui to apenas utilizando URL
    // localhost:8080/ola/{ id que quiser}
    router.get('/ola/<id>', (Request req, String id) {
      return Response.ok("Ola mundo SR. ${id}");
    });

    // Capturando o queryparam
    //localhost:8080/testandoqueryparam?nome={valor};
    router.get("/testandoqueryparam", (Request req) {
      final query = req.url.queryParameters['nome'];

      return Response.ok('deu certo :${query}');
    });

    router.post("/postandoitem", (Request req) async {
      var result = await req.readAsString();
      Map json = jsonDecode(result);

      if (json['user'] == "admin" && json['senha'] == 2711) {
        return Response.ok("Bem vindo ${json['user']}");
      } else {
        return Response.ok("Bem vindo usuario");
      }
    });

    return router;
  }
}
