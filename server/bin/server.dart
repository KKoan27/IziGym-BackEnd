import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelfio;
import 'Routes.dart';
import 'Utilitys/custom_env.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart' as cors;

void main() async {
  Endpoint rout = Endpoint();
  const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
    'Access-Control-Allow-Headers': 'Origin, Content-Type',
  };

  var handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(cors.corsHeaders(headers: corsHeaders))
      .addHandler(rout.handler);

  // Lendo o ADDRESS dinamicamente
  final platformAddress = Platform.environment['SERVER_ADDRESS'];
  final address =
      platformAddress ?? await Customenv.get<String>(key: 'SERVER_ADDRESS');

  // Lendo a PORT dinamicamente
  final platformPort = Platform.environment['SERVER_PORT'];
  final port = platformPort != null
      ? int.parse(platformPort)
      : await Customenv.get<int>(key: 'SERVER_PORT');

  final server = await shelfio.serve(handler, address, port);

  print("🚀 Servidor iniciado em http://${server.address.host}:${server.port}");
}
