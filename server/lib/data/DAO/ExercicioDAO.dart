import 'package:mongo_dart/mongo_dart.dart';
import 'package:server/Models/ExercicioModel.dart';

class ExercicioDAO {
  Db db;
  ExercicioDAO(this.db);

  Future<WriteResult> exercicioInsert(ExercicioModel exercicio) async {
    return await db.collection('Exercicios').insertOne(exercicio.toJson());
  }

  Future<List<ExercicioModel>> exercicioFindAll() async {
try{

  Stream<Map<String,dynamic>> mapexercicios =  await db.collection('Exercicios').find();
  
    return 
     mapexercicios.forEach((item) {
       ExercicioModel(
      descricao: item['descricao'],
      execucao: item['execucao'],
      musculosAlvo: item['musculosAlvo'],
      nome: item['nome'],
       dicas: item['dicas']);}) as List<ExercicioModel>; 
      
    }   on MongoDartError catch (e){
      throw ("Erro no Mongo : $e");
  }
    }

  Future<List<ExercicioModel>> exercicioFindByName(String search) async {

    try {
         Stream<Map<String,dynamic>> mapexercicios =  await db.collection('Exercicios').find({
      "nome": {"\$regex": search, "\$options": "i"},

    });
return 
      mapexercicios.forEach((item) {
       ExercicioModel(
      descricao: item['descricao'],
      execucao: item['execucao'],
      musculosAlvo: item['musculosAlvo'],
      nome: item['nome'],
       dicas: item['dicas']);}) as List<ExercicioModel>; 
    }  on MongoDartError catch (e){
      throw ("Erro no Mongo : $e");
  }
    }
  
  }