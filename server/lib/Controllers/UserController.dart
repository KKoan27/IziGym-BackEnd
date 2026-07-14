// ignore: file_names
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

      // PENDENTE: Inserir um message "Usuário cadastrado com sucesso"
      return Response.ok(jsonEncode(UserResponse.toRegister()));

      // Exceções
    } on UserAlreadyExistsException catch (e) {
      return Response(409, body: jsonEncode({'error': e.message}));
    } catch (e, s) {
      print("Erro: $e \n $s");
      return Response.badRequest(body: "Erro ao cadastrar o usuario : $e ");
    }
  }

  Future<Response> Auth(Request request) async {
    try {
      Map<String, dynamic>? body = await returnjson(request);

      if (body == null) throw MissingParametersException();

      UserModel user = UserModel.auth(
        email: body['name'],
        senha: body['password'],
      );

      UserModel userRequest = UserModel.auth(email: body['email'], senha: body['senha'] );
      
      if(userRequest.email == null || userRequest.senha == null) throw MissingParametersException();

      UserModel userResponse = await userservice.Auth(userRequest);


      return Response.ok(jsonEncode({'message' : 'Autenticado com sucesso', 'response' : userResponse.toJson()}));

    } on InvalidPasswordException catch(e){
       return Response.unauthorized( jsonEncode({'invalidPassoword' : e.message}) );
    } 
    on Exception catch(e,s){

      print(s);
      return Response.badRequest(body:  jsonEncode({'error' : e}));

    }
  }
}
