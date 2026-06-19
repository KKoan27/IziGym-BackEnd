import 'package:mongo_dart/mongo_dart.dart';
import 'package:server/Models/ExercicioModel.dart';
import 'package:server/Models/TreinoModel.dart';
import 'package:server/Models/UserModel.dart';
import 'package:server/Utilitys/Exceptions.dart';
class TreinoDAO {
  Db db;
  TreinoDAO(this.db);

  Future<UserModel> userFind(String userid) async {
     ObjectId useridparsed = ObjectId.parse(userid);
      Map<String,dynamic>? user =  await db.collection('Usuarios').findOne({'_id': useridparsed });

      if(user == null){
        throw UserNotFoundException(); 
      }
      return UserModel(id: user['_id'] as ObjectId,email: user['email'], nome: user['nome'], senha: user['senha'], altura: user['altura'], peso: user['peso']);

  }
    
  Future<WriteResult?> treinoInsert(TreinoModel treino) async {


      
    
  }

  Future<WriteResult> treinoUpdate(ObjectId id, TreinoModel treino) async {
    return await db.collection('Treinos').updateOne(
      {'_id': id},
      {'\$set': treino.toJson()},
    );
  }



  Future<List<ExercicioModel>> recoveryExercicios (Set<String> listaNomesExercicios) async {

  

         List<Map<String,dynamic>> exerciciosDB = await db.collection('Exercicios').find({'nome' :{'\$in' : listaNomesExercicios} }).toList();
  
        if(exerciciosDB.length != listaNomesExercicios.length){
          
          
        }
  } 


  Future<List<TreinoModel>> treinosFindByUserId(ObjectId id) async {
     List<Map<String,dynamic>> listTreinosDb =  await db.collection('Treinos').find({'userId': id}).toList();
    
    if(listTreinosDb.isEmpty ){
      throw TreinoNotFoundException();
    }
     
      return listTreinosDb.map((treinolinha) {
       var exerciciolinha = treinolinha['exercicios'] as List<dynamic>? ??[];

        return TreinoModel(
        nome: treinolinha['nomeTreino'],
        userId: treinolinha['userId'] as ObjectId,
        itemTreino: exerciciolinha.map((itemT){
        return ItemTreino(
              repeticoes: itemT['repeticoes'],
              intervalo: itemT['intervalo'] ,
              exercicio:
              ExercicioModel(
                  nome:itemT['nome'],
                  musculosAlvo:List<String>.from(itemT['musculosAlvo'] ??[]),
                  descricao:itemT['descricao'],
                  execucao:itemT['execucao'],
                  dicas:itemT['dicas'] != null ? List<String>.from(itemT['dicas']) : null)
                  
                );
             }).toList()
        
        );
      }).toList();

  }

  Future<WriteResult> treinoDelete(ObjectId id) async {
    return await db.collection('Treinos').deleteOne({'_id': id});
  }

  // Future methods for other operations can be added here
}
