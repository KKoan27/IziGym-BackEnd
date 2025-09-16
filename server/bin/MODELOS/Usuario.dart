import 'dart:io';

class Usuario {
  String? nome;
  String? email;
  String? senha;

  Usuario({this.nome, this.email, this.senha});

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'email': email,
      'senha': senha,
    };
  }
}
