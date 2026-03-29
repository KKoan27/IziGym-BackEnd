import 'package:mongo_dart/mongo_dart.dart';
import 'package:server/Models/UserModel.dart';
import 'package:shelf/shelf.dart';

class UserDAO {
  Db db;
  UserDAO(this.db);

  Future<WriteResult> InsertUser(Usuario usuario) async {
    return await db.collection('Usuarios').insertOne(usuario.toRegister());
  }

  Future<Usuario?> findUser(Usuario user) async {
    // Criamos um mapa para o $or (Email ou Nome)
    Map<String, dynamic> orFilters = {'email': user.email, 'nome': user.nome};

    // A MÁGICA DA EDIÇÃO:
    // Se o objeto já tem um ID, queremos buscar conflitos com OUTROS usuários

    Map<String, dynamic> query = {r'$or': orFilters};

    // query fica assim:
    //     {
    //   "$or": [
    //     {"email": "vini@academia.com"},
    //     {"nome": "vinicius_arquiteto"}
    //   ]
    // }
    if (user.id != null) {
      query['_id'] = {r'$ne': user.id};

      //     {
      //   "$or": [
      //     {"email": "vini@academia.com"},
      //     {"nome": "vinicius_arquiteto"}
      //   ],
      //   "_id": {
      //     "$ne": ObjectId("65f123abc456def789012345")
      //   }
      // }
    }

    final result = await db.collection('Usuarios').findOne(query);
    return result == null ? null : user;
  }

  Future<bool> AuthUser(Usuario usuario) async {
    var auth = await db.collection('Usuarios').findOne({
      {"email": usuario.email, "senha": usuario.senha},
    });
    if (auth == null) return false;
    return true;
  }

  Future<bool> UpdateUser(Usuario usuario, Usuario updateuser) async {
    try {
      var result = await db
          .collection('Usuarios')
          .updateOne({'_id': usuario.id}, {'\$set': updateuser.toSetting()});

      if (result.hasWriteErrors) {
        throw (("Erro na atualização:${result.writeError!.errmsg}"));
      }
      return true;
    } on MongoDartError catch (mongoError) {
      print("erro no Mongo: ");
      return false;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }
}
