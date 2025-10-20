import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelfio;
import 'Routes.dart';
import 'Utilitys/custom_env.dart';

void main() async {
  Endpoint rout = Endpoint();
  var address = await Customenv.get<String>(key: 'SERVER_ADDRESS');
  var port = await Customenv.get<int>(key: 'SERVER_PORT');

  var handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(rout.handler);

  await shelfio.serve(handler, address, port);

  print("serv start $address : $port ");
}
