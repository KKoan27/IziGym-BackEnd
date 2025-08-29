import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class Rotas {
  Handler? get handler {
    final rout = Router();

    rout.get("/", (Request request) {
      return Response(200, body: "primeira rota");
    });
  }
}
