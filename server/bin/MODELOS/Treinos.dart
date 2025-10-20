import 'Exercicio.dart';
import 'Usuario.dart';

class Treinos {
  String _nome;
  String _userId;
  List<ItemTreino> itemTreino;

  Treinos({
    required String nome,
    required String userId,
    required this.itemTreino,
  }) : _nome = nome,
       _userId = userId;

  String get userId => _userId;

  Map<String, dynamic> toJson() {
    return {
      'nomeTreino': _nome,
      'userId': _userId,
      'exercicios': itemTreino.map((itemTreino) {
        return itemTreino.toJson();
      }).toList(),
    };
  }
}

class ItemTreino {
  int series;
  int repeticoes;
  Exercicio exercicio;

  ItemTreino({
    required this.exercicio,
    required this.repeticoes,
    required this.series,
  });

  Map<String, dynamic> toJson() {
    return {
      // Aqui também, aninhamos o JSON do exercício dentro do JSON do item de treino
      // O '...' pega todas as chaves de exercicio.toJson()
      // (ex: 'nome', 'musculoAlvo') e as coloca aqui
      ...exercicio.toJson(),
      'series': series,
      'repeticoes': repeticoes,
    };
  }
}
