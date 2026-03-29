import 'package:server/Models/UserModel.dart';
import 'package:server/data/DAO/UserDAO.dart';

class UserController {
  UserDAO? userDAO;

  UserController(UserDAO userdao) {
    userDAO = userdao;
  } //Testando um construtor diferente porque sim
}
