import 'package:mongo_dart/mongo_dart.dart';
import 'package:server/Models/ExercicioModel.dart';

class ExercicioDAO {
  Db db;
  ExercicioDAO(this.db);

  Future<WriteResult> exercicioInsert(Exercicio exercicio) async {
    return await db.collection('Exercicios').insertOne(exercicio.toJson());
  }

  Future<List<Map<String, dynamic>>> exercicioFindAll() async {
    return await db.collection('Exercicios').find().toList();
  }

  Future<List<Map<String, dynamic>>> exercicioFindByName(String search) async {
    return await db.collection('Exercicios').find({
      "nome": {"\$regex": search, "\$options": "i"},
    }).toList();
  }

  // Future methods for updating, deleting, etc. can be added here
}