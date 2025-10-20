import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelfio;
import 'Routes.dart';
import 'Utilitys/custom_env.dart';
import 'dart:io'; 

void main() async {
  Endpoint rout = Endpoint();
  
var handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(rout.handler);

  final address = '0.0.0.0';
  final platformPort = Platform.environment['PORT'];
  final port = platformPort != null
      ? int.parse(platformPort)
      : await Customenv.get<int>(key: 'SERVER_PORT');

  await shelfio.serve(handler, address, port);

  print("serv start $address : $port ");
}
