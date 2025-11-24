import 'dart:io';

import 'package:mongo_dart/mongo_dart.dart';

class Usuario {
  ObjectId? id;
  String? nome;
  String? email;
  String? senha;
  double? altura;
  double? peso;

  Usuario({
    this.id,
    required this.nome,
    required this.email,
    required this.senha,
    this.altura,
    this.peso,
  });

  // To pensando o que fazer com isso ainda
  Usuario.setting({this.email, this.altura, this.peso});

  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'nome': nome,
      'email': email,
      'senha': senha,
      'peso': peso!.toDouble(),
      'altura': altura!.toDouble(),
    };
  }

  Map<String, dynamic> toRegister() {
    return {
      'nome': nome,
      'email': email,
      'senha': senha,
      'peso': (peso ?? 0.0).toDouble(), // Garante explicitamente que é double
      'altura': (altura ?? 0.0)
          .toDouble(), // Garante explicitamente que é double
    };
  }

  Map<String, dynamic> toSetting() {
    return {
      'email': email,
      'altura': altura!.toDouble(),
      'peso': peso!.toDouble(),
    };
  }
}
