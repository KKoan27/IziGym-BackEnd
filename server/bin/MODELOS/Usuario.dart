import 'dart:io';

import 'package:mongo_dart/mongo_dart.dart';

class Usuario {
  ObjectId? id;
  String? nome;
  String? email;
  String? senha;

  Usuario({this.id, this.nome, this.email, this.senha});

  Map<String, dynamic> toJson() {
    return {'id': id.toString(), 'nome': nome, 'email': email, 'senha': senha};
  }

  Map<String, dynamic> toRegister() {
    return {'nome': nome, 'email': email, 'senha': senha};
  }
}
