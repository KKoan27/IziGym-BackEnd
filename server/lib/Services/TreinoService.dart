import 'dart:collection';
import 'dart:core';
import 'package:server/Models/ExercicioModel.dart';
import 'package:server/Models/TreinoModel.dart';
import 'package:server/data/DAO/TreinoDAO.dart';
import 'package:server/Utilitys/Exceptions.dart';
import 'package:server/Models/UserModel.dart';

class TreinoService {

   TreinoDAO treinodao;

   TreinoService(this.treinodao); 




  Future <Set<ExercicioModel>> verifyExercicios(List<String> listaNomesExercicios)async {

    return  await treinodao.recoveryExercicios(listaNomesExercicios);

  }
          
  Future<List<TreinoModel>> listTreinos(String userid) async {

   //Verificando se o usuario existe no BD
    UserModel user = await treinodao.userFind(userid);

    return await treinodao.treinosFindByUserId(user.id!);
    
    


  }

  
  Future<String>insertTreino(TreinoModel treino)async{

        return treinodao.treinoInsert(treino);

      
  }

  // Future<Response> deleteTreino(Request request)async{
  
  
  // }


  // Future<Response> updateTreino(Request request)async{
  
  
  // }


}