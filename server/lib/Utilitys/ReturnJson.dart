// Função para fazer a conversão do body em um dicionario!!
import 'dart:convert';

import 'package:shelf/shelf.dart';

Future<Map<String, dynamic>?>? returnjson(Request request) async {
  //lendo todo o body do JSON em string no momento
  final body = await request.readAsString();
  //Aqui todo a strign jSon é convertida para um Map(String key :  dynamic valor )
  return jsonDecode(body) as Map<String, dynamic>;
}
