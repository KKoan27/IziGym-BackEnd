import 'package:mongo_dart/mongo_dart.dart';
import 'package:server/Models/ExercicioModel.dart';

class ExercicioDAO {
  Db db;
  ExercicioDAO(this.db);

  Future<WriteResult> exercicioInsert(ExercicioModel exercicio) async {
    return await db.collection('Exercicios').insertOne(exercicio.toJson());
  }

  Future<List<ExercicioModel>> exercicioFindAll() async {
    try {
      List<Map<String, dynamic>> mapexercicios = await db
          .collection('Exercicios')
          .find()
          .toList();

      return mapexercicios.map((event) {
        return ExercicioModel(
          descricao: event['descricao'],
          nome: event['nome'],
          execucao: event['execucao'],
          musculosAlvo: List<String>.from(event['musculosAlvo'] ?? []),
          dicas: event['dicas'] != null
              ? List<String>.from(event['dicas'])
              : null,
        );
      }).toList();
    } on MongoDartError catch (e) {
      throw ("Erro no Mongo : $e");
    }
  }

  Future<List<ExercicioModel>> exercicioFindByName(String search) async {
    try {
      Stream<Map<String, dynamic>> mapexercicios = await db
          .collection('Exercicios')
          .find({
            "nome": {"\$regex": search, "\$options": "i"},
          });
      return mapexercicios.map((event) {
        return ExercicioModel(
          descricao: event['descricao'],
          nome: event['nome'],
          execucao: event['execucao'],
          musculosAlvo: List<String>.from(event['musculosAlvo'] ?? []),
          dicas: event['dicas'] != null
              ? List<String>.from(event['dicas'])
              : null,
        );
      }).toList();
    } on MongoDartError catch (e) {
      throw ("Erro no Mongo : $e");
    }
  }
}
