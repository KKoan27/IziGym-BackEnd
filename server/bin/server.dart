import 'package:server/server.dart' as server;
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelfio;
import 'Routes.dart';

void main() async {
  Rotas rout = Rotas();

  final server = await shelfio.serve(rout.handler, 'localhost', 8080);

  print("serv start 8080");
}
