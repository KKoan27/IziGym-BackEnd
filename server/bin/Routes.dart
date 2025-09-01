import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class Rotas {
  Handler get handler {
    final router = Router();

    // PARA CADA ROTA TEM QUE ENTRA COMO PARAM UM REQ E RETORNAR UM RESPONSE

    //
    router.get("/", (Request request) {
      return Response(200, body: "primeira rota");
    });

    router.get('/ola/<id>', (Request req) {
      var UserID = req.params['id'];

      return Response.ok("Ola mundo SR. ${UserID}");
    });

    return router;
  }
}
