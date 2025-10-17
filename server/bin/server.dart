import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelfio;
import 'Routes.dart';

void main() async {
  Endpoint rout = Endpoint();
  String address = 'localhost';
  int port = 8080;

  var handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(rout.handler);

  await shelfio.serve(handler, address, port);

  print("serv start 8080");
}
