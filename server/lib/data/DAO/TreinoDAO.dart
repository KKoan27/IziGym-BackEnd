import 'package:mongo_dart/mongo_dart.dart';
import 'package:server/Models/TreinosModel.dart';

class TreinoDAO {
  Db db;
  TreinoDAO(this.db);

  Future<WriteResult> treinoInsert(Treinos treino) async {
    return await db.collection('Treinos').insertOne(treino.toJson());
  }

  Future<WriteResult> treinoUpdate(ObjectId id, Treinos treino) async {
    return await db.collection('Treinos').updateOne(
      {'_id': id},
      {'\$set': treino.toJson()},
    );
  }

  Future<List<Map<String, dynamic>>> treinoFindByUser(ObjectId userId) async {
    return await db.collection('Treinos').find({'userId': userId}).toList();
  }

  Future<Map<String, dynamic>?> treinoFindById(ObjectId id) async {
    return await db.collection('Treinos').findOne({'_id': id});
  }

  Future<WriteResult> treinoDelete(ObjectId id) async {
    return await db.collection('Treinos').deleteOne({'_id': id});
  }

  // Future methods for other operations can be added here
}
