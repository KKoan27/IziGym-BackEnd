  import 'dart:convert';

import 'package:server/Models/ExercicioModel.dart';
import 'package:server/Models/TreinoModel.dart';
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
     List<TreinoModel> listatreinoresponse  =   await treinoservice.listTreinos(userid);

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
List<ExercicioModel> listexercicios = [];


  List<String> listaNomesExercicios = exerciciosRequestDoBody.map((e) => e['nome'] as String).toList();


  

//       for( var i in exerciciosRequestDoBody){


//         final exercicios = i['exercicios'] as List<Map<String,dynamic>>;
        
//         for(Map<String,dynamic> j in exercicios){
//  listexercicios.add(    ExercicioModel(
//                     nome: j['nome'],
//                     musculosAlvo: List<String>.from(j['musculoAlvo'] ??[]) , 
//                     descricao: j['descricao'], 
//                     execucao: j['execucao']));
//         }
          


//       }

      print(listexercicios);

      
      throw Exception("testando");

       
       
     
          

    
    // TreinosModel  treinoRequest = TreinosModel( 
    //      nome: bodyrequest['nomeTreino'],
    //    userId: bodyrequest['userId'],
    //    itemTreino:  
    //    bodyrequest['exercicios']
       
    //    ItemTreino(exercicio: exercicio, repeticoes: repeticoes, intervalo: intervalo)

    // )      
      

    } 
    catch (e,s){  
        print(s);
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
