import 'dart:convert';
import 'dart:io';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:server/Controllers/ExercicioController.dart';
import 'package:server/Controllers/TreinosController.dart';
import 'package:server/Services/UserService.dart';
import 'package:server/data/DAO/ExercicioDAO.dart';
import 'package:server/data/DAO/TreinoDAO.dart';
import 'package:server/data/DAO/UserDAO.dart';
import 'package:server/data/Mongo_Conn.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelfio;
import 'package:server/Router.dart';
import 'package:server/Utilitys/custom_env.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart' as cors;
import 'package:server/Controllers/UserController.dart';
import 'package:server/Controllers/ExercicioController.dart';
import 'package:server/Services/ExercicioService.dart';
import 'package:server/data/DAO/ExercicioDAO.dart';

void main() async {
  Db db = await MongoConn.database;
  //DAO's
  TreinoDAO treinodao  = TreinoDAO(db);
  ExercicioDAO exerciciodao = ExercicioDAO(db);
  UserDAO userdao = UserDAO(db);


  //Services
  UserService userservice = UserService(userdao);
  ExercicioService exercicioservice = ExercicioService(exerciciodao);

  // TreinoService treino = treinoservice(treinodao)



  //Controllers
  Treinoscontroller treinoscontroller = Treinoscontroller();
  Exerciciocontroller exerciciocontroller = Exerciciocontroller(exercicioservice);
  UserController userController = UserController(userservice);

  Endpoint rout = Endpoint(
    exercicioctrl: exerciciocontroller,
    userctrl: userController,
    treinoctrl: treinoscontroller,
  );

  const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
    'Access-Control-Allow-Headers': 'Origin, Content-Type',
  };

  var handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(cors.corsHeaders(headers: corsHeaders))
      .addMiddleware(standardResponseMiddleware(corsHeaders))
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

// Organizar essas Middleware

// Nome da função do nosso middleware
Middleware standardResponseMiddleware(Map<String, String> corsHeaders) {
  // A estrutura padrão de um middleware: recebe um handler e retorna outro.
  return (Handler innerHandler) {
    // Este é o novo handler que será executado.
    // Usamos 'async' porque vamos 'await' a resposta do handler interno.
    return (Request request) async {
      // evita quebrar o pré-flight do CORS
      if (request.method == 'OPTIONS') {
        return Response.ok('', headers: {...corsHeaders});
      }

      try {
        final originalResponse = await innerHandler(request);
        final originalBodyString = await originalResponse.readAsString();

        dynamic responseBody;

        if (originalBodyString.isNotEmpty) {
          try {
            responseBody = jsonDecode(originalBodyString);
          } catch (_) {
            responseBody = originalBodyString;
          }
        } else {
          responseBody = {};
        }

        final standardPayload = {
          'methodRequest': request.method,
          'statusCode': originalResponse.statusCode,
          'response': responseBody,
        };

        return originalResponse.change(
          body: jsonEncode(standardPayload),
          headers: {
            ...originalResponse.headers,
            'Content-Type': 'application/json',
          },
        );
      } catch (e, s) {

        print('erro: $e \n\n $s');
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
