import 'dart:convert';
import 'package:server/Models/TreinosModel.dart';
import 'package:server/Utilitys/ReturnJson.dart';
import 'package:server/data/DAO/TreinoDAO.dart';
import 'package:shelf/shelf.dart';
import 'package:server/Utilitys/Exceptions.dart';
import 'package:server/Models/UserModel.dart';

class TreinoService {

   TreinoDAO treinodao;

   TreinoService(this.treinodao); 


  Future<List<TreinosModel>> listTreinos(String userid) async {

   //Verificando se o usuario existe no BD
    UserModel user = await treinodao.userFind(userid);

    return await treinodao.treinosFindByUserId(user.id!);

    


  }


  
  Future<TreinosModel> insertTreino(Request request)async{
    throw "testando";
      
  }

  // Future<Response> deleteTreino(Request request)async{
  
  
  // }


  // Future<Response> updateTreino(Request request)async{
  
  
  // }


}