import 'dart:convert';
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
      .addMiddleware(standardResponseMiddleware())
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

Middleware standardResponseMiddleware() {
  // A estrutura padrão de um middleware: recebe um handler e retorna outro.
  return (Handler innerHandler) {
    // Este é o novo handler que será executado.
    // Usamos 'async' porque vamos 'await' a resposta do handler interno.
    return (Request request) async {
      try {
        // 1. Deixa a requisição passar e AGUARDA a resposta original.
        final originalResponse = await innerHandler(request);

        // 2. Lê o corpo da resposta original como uma string.
        final originalBodyString = await originalResponse.readAsString();

        // 3. Tenta decodificar o corpo original. Se não for JSON, usa a string como está.
        dynamic responseBody;
        if (originalBodyString.isNotEmpty) {
          try {
            responseBody = jsonDecode(originalBodyString);
          } catch (e) {
            // Se a decodificação falhar, o corpo não era JSON. Usamos a string bruta.
            responseBody = originalBodyString;
          }
        } else {
          // Se o corpo original for vazio, representamos como um objeto vazio.
          responseBody = {};
        }

        // 4. Monta a nova estrutura (payload) da resposta.
        final standardPayload = {
          'methodRequest': request.method,
          'statusCode': originalResponse.statusCode,
          'response': responseBody,
        };

        // 5. Cria e retorna uma NOVA resposta padronizada.
        // Usamos '.change()' para manter os headers originais, se houver,
        // e apenas sobrescrever o body e o Content-Type.
        return originalResponse.change(
          body: jsonEncode(standardPayload), // Codifica o novo mapa para JSON
          headers: {'Content-Type': 'application/json'},
        );
      } catch (e, s) {
        print(s);
        // Se ocorrer um erro em algum handler interno, podemos padronizar a resposta de erro também.
        print('Erro capturado no middleware de resposta padrão: $e');
        final errorPayload = {
          'methodRequest': request.method,
          'statusCode': 500,
          'response': {
            'error': 'Ocorreu um erro interno no servidor.',
            'details': e.toString(),
          },
        };
        return Response.internalServerError(
          body: jsonEncode(errorPayload),
          headers: {'Content-Type': 'application/json'},
        );
      }
    };
  };
}
