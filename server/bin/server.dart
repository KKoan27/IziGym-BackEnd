import 'dart:io';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:server/Controllers/ExercicioController.dart';
import 'package:server/Controllers/TreinosController.dart';
import 'package:server/Services/TreinoService.dart';
import 'package:server/Services/UserService.dart';
import 'package:server/data/DAO/ExercicioDAO.dart';
import 'package:server/data/DAO/TreinoDAO.dart';
import 'package:server/data/DAO/UserDAO.dart';
import 'package:server/data/Mongo_Conn.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelfio;
import 'package:server/Router.dart';
import 'package:server/Utilitys/custom_env.dart';
import 'package:server/Controllers/UserController.dart';
import 'package:server/Services/ExercicioService.dart';
import 'package:server/Utilitys/Middlewares.dart';

void main() async {
  //Conexão com o BD
  Db db = await MongoConn.database;

  //DAO's
  TreinoDAO treinodao = TreinoDAO(db);
  ExercicioDAO exerciciodao = ExercicioDAO(db);
  UserDAO userdao = UserDAO(db);

  //Services
  UserService userservice = UserService(userdao);
  ExercicioService exercicioservice = ExercicioService(exerciciodao);
  TreinoService treinoservice = TreinoService(treinodao);

  //Controllers
  Treinoscontroller treinoscontroller = Treinoscontroller(treinoservice);
  Exerciciocontroller exerciciocontroller = Exerciciocontroller(
    exercicioservice,
  );
  UserController userController = UserController(userservice);

  Endpoint rout = Endpoint(
    exercicioctrl: exerciciocontroller,
    userctrl: userController,
    treinoctrl: treinoscontroller,
  );

  var handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(standardRespondeMiddleware())
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
