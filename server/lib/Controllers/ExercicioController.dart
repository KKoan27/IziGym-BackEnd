import 'package:server/Services/ExercicioService.dart';
import 'package:shelf/shelf.dart';
import 'dart:convert';
import 'package:server/Models/ExercicioModel.dart';

class Exerciciocontroller {
  ExercicioService exercicioservice;

  Exerciciocontroller(this.exercicioservice);

  Future<Response> listexercicios(Request request) async {
    try {
      String? search = request.url.queryParameters['q'];
      List<Map<String, dynamic>> exercicioResponse =
          await exercicioservice.SearchExercicio(search: search);

      return Response.ok(jsonEncode({'exercicios': exercicioResponse}));
    } catch (e, s) {
      print(s);
      return Response.badRequest(body: jsonEncode({'erro': e.toString()}));
    }
  }
}
