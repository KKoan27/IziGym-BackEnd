import 'package:server/server.dart' as server;
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelfio;

void main() async {
  final serv = await shelfio.serve(
    (request) => Response(200, body: 'ok'),
    'localhost',
    8080,
  );

  print("serv start 8080");
}
