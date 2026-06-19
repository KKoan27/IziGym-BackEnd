import 'dart:convert';
import 'dart:core';
import 'package:server/Models/ExercicioModel.dart';
import 'package:server/Models/TreinoModel.dart';
import 'package:server/Utilitys/ReturnJson.dart';
import 'package:server/data/DAO/TreinoDAO.dart';
import 'package:shelf/shelf.dart';
import 'package:server/Utilitys/Exceptions.dart';
import 'package:server/Models/UserModel.dart';

class TreinoService {

   TreinoDAO treinodao;

   TreinoService(this.treinodao); 




Future <List<ExercicioModel>> verifyExercicios(Set<String> listaNomesExercicios){

          List<ExercicioModel> listExercicios =  treinodao.recoveryExercicios(listaNomesExercicios);

  if(listExercicios =! null){

      return listExercicios;
  }
  else{

    throw ExercicioNotFoundException(); 
  } 
}

  Future<List<TreinoModel>> listTreinos(String userid) async {

   //Verificando se o usuario existe no BD
    UserModel user = await treinodao.userFind(userid);

    return await treinodao.treinosFindByUserId(user.id!);
    
    


  }



  
  Future<TreinoModel> insertTreino(Request request)async{

    
    throw "testando";

      
  }

  // Future<Response> deleteTreino(Request request)async{
  
  
  // }


  // Future<Response> updateTreino(Request request)async{
  
  
  // }


}