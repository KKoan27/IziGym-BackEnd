class UserAlreadyExistsException implements Exception {
  final String message;
  UserAlreadyExistsException([this.message = 'Usuário já cadastrado no sistema']);
}


class ExercicioNotFoundException implements Exception{
  final String message;
  final List<String>? listExercicios;
    ExercicioNotFoundException([this.listExercicios,this.message  = 'Exercicio não encontrado' ,  ]);
}

class UserNotFoundException implements Exception {
  final String message;
  UserNotFoundException([this.message = 'Usuário não encontrado no sistema']);
}
class TreinoNotFoundException implements Exception {
  final String? message;
  TreinoNotFoundException({this.message = 'Treino não encontrado no sistema'});
}

class InvalidPasswordException implements Exception{ 
  final String message;
  InvalidPasswordException([this.message = 'Senha inválida']);
} 

class MissingParametersException implements Exception{
    final String message;
MissingParametersException([this.message = 'Parâmetros faltando']);
}

class DataBaseException implements Exception{
  final String? message;
  DataBaseException([this.message]);

}
