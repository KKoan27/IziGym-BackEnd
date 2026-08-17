import 'dart:io';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:server/Utilitys/custom_env.dart';

class MongoConn {
  static Db? _db;

  static Future<Db> get database async {
    if (_db == null || !_db!.isConnected) {
      _db = await Db.create( Platform.environment['MONGOURI'] ??
            await Customenv.get<String>(key: 'MONGOURI'),
      );

      if (_db != null) {
        await _db!.open();
      } else {
        throw MongoDartError("Não foi possivel conectar ao Mongo");
      }
    }
    return _db!;
  }

  static Future<void> close() async {
    await _db?.close();
  }
}
