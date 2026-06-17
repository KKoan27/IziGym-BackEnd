import 'dart:io';

class ExercicioModel {
  String _nome;
  final List<String> _musculosAlvo;
  final String _descricao;
  String _execucao;
  List<String?>? _dicas;

  ExercicioModel({
    required String nome,
    required List<String> musculosAlvo,
    required String descricao,
    required String execucao,
    List<String?>? dicas,
  }) : _nome = nome,
       _musculosAlvo = musculosAlvo,
       _descricao = descricao,
       _execucao = execucao,
       _dicas = dicas;

  // Getters
  String get nome => _nome;
  List<String> get musculosAlvo => _musculosAlvo;
  String get descricao => _descricao;
  String get execucao => _execucao;
  List<String?>? get dicas => _dicas;

  // Setters
  set nome(String name) {
    _nome = name;
  }

  set dicas(String dica) {
    _dicas!.add(dica);
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'nome': _nome,
      'musculosAlvo': _musculosAlvo,
      'descricao': _descricao,
      'execucao': _execucao,
      'dicas': _dicas,
    };
  }
}
