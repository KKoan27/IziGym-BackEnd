import 'dart:ffi';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:server/Models/UserModel.dart';
import 'package:server/data/DAO/UserDAO.dart';
import 'package:shelf/shelf.dart';
import 'package:server/Utilitys/ReturnJson.dart';

class UserController {
  UserDAO userDAO;

  UserController(this.userDAO);

  //Testando um construtor diferente porque sim

  Future<Response> Register(Request request) async {
    try {
      Map<String, dynamic>? body = await returnjson(request);

      if (body == null) {
        return Response.badRequest(body: "Corpo de requisição nulo");
      }
      Usuario usuario = Usuario(
        nome: body['nome'],
        email: body['email'],
        senha: body['senha'],
      );

      Usuario? userExists = await userDAO.findUser(usuario);

      if (userExists != null)
        // ignore: curly_braces_in_flow_control_structures
        return Response.badRequest(body: "Usuario já existe");

      WriteResult resultInsert = await userDAO.InsertUser(usuario);
      if (resultInsert.hasWriteErrors)
        throw Exception(" ${resultInsert.errmsg}");
    } catch (e) {
      return Response.badRequest(body: "Erro ao cadastrar o usuario : $e");
    }

    return Response.ok("Usuario cadastrado");
  }
}
