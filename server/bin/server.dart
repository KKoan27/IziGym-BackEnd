import 'package:server/server.dart' as server;
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelfio;
import 'Routes.dart';

void main() async {
  Endpoint rout = Endpoint();

<<<<<<< HEAD
  final serv = await shelfio.serve(rout.handler, 'localhost', 8080);
=======
  final server = await shelfio.serve(rout.handler, 'localhost', 8080);
>>>>>>> cf80dce0116962332630cf364acee815bfde2b0d

  print("serv start 8080");
}
