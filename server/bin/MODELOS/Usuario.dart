import 'dart:io';

class Usuario {
  String _nome;
  String _email;
  String _senha;

  Usuario({required String nome, required String email, required String senha})
    : _nome = nome,
      _email = email,
      _senha = senha;

  String get nome => _nome;
  String get email => _email;
  String get senha => _senha;
}
