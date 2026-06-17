import 'package:mongo_dart/mongo_dart.dart';

import 'ExercicioModel.dart';
import 'UserModel.dart';

class Treinos {
  String _nome;
  ObjectId _userId;
  List<ItemTreino> itemTreino;

  Treinos({
    required String nome,
    required ObjectId userId,
    required this.itemTreino,
  }) : _nome = nome,
       _userId = userId;

  ObjectId get userId => _userId;
  String get nome => _nome;

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
  int intervalo;
  int repeticoes;
  ExercicioModel exercicio;

  ItemTreino({
    required this.exercicio,
    required this.repeticoes,
    required this.intervalo,
  });

  Map<String, dynamic> toJson() {
    return {
      // Aqui também, aninhamos o JSON do exercício dentro do JSON do item de treino
      // O '...' pega todas as chaves junto com os valores de exercicio.toJson()
      // (ex: 'nome', 'musculoAlvo') e as coloca aqui
      ...exercicio.toJson(),
      'intervalo': intervalo,
      'repeticoes': repeticoes,
    };
  }
}
