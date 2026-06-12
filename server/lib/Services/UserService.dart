import 'package:mongo_dart/mongo_dart.dart';
import 'package:server/Models/UserModel.dart';
import 'package:server/data/DAO/UserDAO.dart';
import 'package:server/Utilitys/Exceptions.dart';
 class  UserService {

    UserDAO userdao;

    UserService(this.userdao);



      Future<UserModel> Register(UserModel usuario) async{

             if (await userdao.findUser(usuario) != null )  throw UserAlreadyExistsException();

      WriteResult resultInsert = await userdao.InsertUser(usuario);
       
      if (resultInsert.hasWriteErrors) throw Exception(" ${resultInsert.errmsg}");
      
      return UserModel.register(
        id: resultInsert.id,
        nome: usuario.nome,
        email: usuario.email);
    }

  
  
}