import 'package:mongo_dart/mongo_dart.dart';

class MongoConn {
  static Db? _db;

  static Future<Db> get database async {
    if (_db == null || !_db!.isConnected) {
      _db = await Db.create(
        "mongodb+srv://DELCO:Senhaforte2711@cluster0.z3vmnhg.mongodb.net/IZIGYM_DB",
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
