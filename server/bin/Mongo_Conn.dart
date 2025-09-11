import 'package:mongo_dart/mongo_dart.dart';

class Mongoconn {
  static Db? _db;

  static Future<Db> get database async {
    if (_db == null || !_db!.isConnected) {
      _db = await Db.create(
        "mongodb+srv://DELCO:Senhaforte2711@cluster0.z3vmnhg.mongodb.net/IZIGYM_DB",
      );
      await _db!.open();
    }
    return _db!;
  }

  static Future<void> close() async {
    await _db?.close();
  }
}
