import 'dart:io';

import 'package:mongo_dart/mongo_dart.dart';

class UserModel {
  ObjectId? id;
  String? nome;
  String? email;
  String? senha;
  double? altura;
  double? peso;

  UserModel({
    this.id,
    required this.nome,
    required this.email,
    required this.senha,
    this.altura,
    this.peso,
  });

  UserModel.auth({required this.email, required this.senha});

  UserModel.registerReponse({this.id, this.email, this.nome});

  // To pensando o que fazer com isso ainda
  UserModel.setting({this.email, this.altura, this.peso});

  Map<String, dynamic> toJson() {
    return {
      'id': id!.oid,
      'nome': nome,
      'email': email,
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
