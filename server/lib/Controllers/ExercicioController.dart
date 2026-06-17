import 'package:server/Services/ExercicioService.dart';
import 'package:shelf/shelf.dart';
import 'dart:convert';

class Exerciciocontroller {

  ExercicioService? exercicioservice;

  Exerciciocontroller(this.exercicioservice);

  

  Future<Response> ListExercicios(Request request)async {

    try{
       String? search = request.url.queryParameters['q'];

      List<Map<String,dynamic>> exercicioResponse= await  exercicioservice.SearchExercicio(search: search)!;
    
    return Response.ok(jsonEncode(exercicioResponse));

    }
    catch(e){
      
      return Response.badRequest(body: jsonEncode({'erro' : e}) );
    }


  }

}
