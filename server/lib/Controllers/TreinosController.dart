import 'dart:convert';

import 'package:server/Models/TreinosModel.dart';
import 'package:server/Services/TreinoService.dart';
import 'package:shelf/shelf.dart';
import 'package:server/Utilitys/Exceptions.dart';
import 'package:server/Utilitys/ReturnJson.dart';


class Treinoscontroller {

  TreinoService treinoservice;

  Treinoscontroller(this.treinoservice);




  Future<Response> listTreinos (Request request) async{

try{
    String? userid = request.url.queryParameters['userid'];

  if(userid == null) throw MissingParametersException();
     List<TreinosModel> listatreinoresponse  =   await treinoservice.listTreinos(userid);

    return Response.ok(jsonEncode(listatreinoresponse));

}
on TreinoNotFoundException catch(e){
  return Response.ok("Usuario não tem treino cadastrado");

}
catch (e){
 return Response.badRequest(body: jsonEncode({'erro' : e.toString()}));
}


  }


  
  Future<Response> insertTreino(Request request)async{

    try{
      Map<String,dynamic>? bodyrequest =  await returnjson(request);

   if (bodyrequest == null ||
          bodyrequest['userId'] == null ||
          bodyrequest['nomeTreino'] == null ||
          bodyrequest['exercicios'] == null)  throw MissingParametersException();
      
    
      final exerciciosRequestDoBody = bodyrequest['exercicios'] as List<dynamic>;

      for( var i in exerciciosRequestDoBody){

        print(" nome: ${i['nome']} \n ");


      }
      throw Exception("testando");

       
       
      //  List<Map<String,dynamic>> mapExerciciosByName =  exerciciosRequestDoBody.map(
      //   (i) => {
      //     i['nome'] as String : i
      //     }).toList();


          

          

    
    // TreinosModel  treinoRequest = TreinosModel( 
    //      nome: bodyrequest['nomeTreino'],
    //    userId: bodyrequest['userId'],
    //    itemTreino:  
    //    bodyrequest['exercicios']
       
    //    ItemTreino(exercicio: exercicio, repeticoes: repeticoes, intervalo: intervalo)

    // )      
      
      treinoservice.insertTreino(request);

    } 
    catch (e){  

      return Response.badRequest(body: jsonEncode({'erro' : e.toString()}) );

    }
  }

//   Future<Response> deleteTreino(Request request)async{
  
//   try{

// }
// catch (e){
  
// }

//   }


//   Future<Response> updateTreino(Request request)async{
  
//   try{

// }
// catch (e){
  
// }

//   }

}
