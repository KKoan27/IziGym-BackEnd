import 'dart:io';

import 'package:server/server.dart' as server;
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelfio;
import 'Routes.dart';

void main() async {
  Endpoint rout = Endpoint();

  String Address = 'localhost';
  int port = 8080;

  var handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(rout.handler);

  final serv = await shelfio.serve(handler, Address, port);

  print("serv start 8080");
}
