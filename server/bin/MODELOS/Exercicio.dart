import 'dart:io';

class Exercicio {
  String _nome;
  String _musculosAlvo;
  String _descricao;
  String _execucao;
  String? _dicas;

  Exercicio({
    required String nome,
    required String musculosalvo,
    required String descricao,
    required String execucao,
    String? dicas,
  }) : _nome = nome,
       _musculosAlvo = musculosalvo,
       _descricao = descricao,
       _execucao = execucao,
       _dicas = dicas;

  String get nome => _nome;
  String get musculosalvo => _musculosAlvo;
  String get descricao => _descricao;
  String get execucao => _execucao;
  String? get dicas => _dicas;

  set nome(String? name) {
    if (name != null) {
      return;
    }
  }
}
