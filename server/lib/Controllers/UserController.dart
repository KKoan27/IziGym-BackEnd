import 'dart:convert';

import 'package:server/Models/UserModel.dart';
import 'package:server/Services/UserService.dart';
import 'package:shelf/shelf.dart';
import 'package:server/Utilitys/ReturnJson.dart';
import 'package:server/Utilitys/Exceptions.dart';
class UserController {
  UserService userservice;
  

  UserController(this.userservice);

// Arquitetura do Handler - Entra um request no parametro e retorna uma Response (promessa)
  Future<Response> Register(Request request) async {
    try {
      Map<String, dynamic>? body = await returnjson(request);

//Verificação do body da requisição
      if (body == null) {
        return Response.badRequest(body: "Corpo de requisição nulo");
      }
      UserModel usuario = UserModel(
        nome: body['nome'],
        email: body['email'],
        senha: body['senha'],
        peso: 0.0,
        altura: 0.0,
      );

// Mandando para o service
      UserModel UserResponse = await userservice.Register(usuario);
      print(jsonEncode(UserResponse));
      return Response.ok(jsonEncode(UserResponse));
 
// Exceções
    
    } 
    on  UserAlreadyExistsException  catch( e){
      return Response(409, body: jsonEncode({'error' : e.message}));
    
    } 
  
    catch (e) {
      return Response.badRequest(body: "Erro ao cadastrar o usuario : $e");
    }
   

  }

  Future<Response> Auth(Request request) async {
    try {

      Map<String,dynamic>? body = await returnjson( request);

      if(body == null) throw MissingParametersException();

      UserModel user = UserModel(email: body['name'], senha: body['password'] );
      

    } catch{

    }
  }
}



