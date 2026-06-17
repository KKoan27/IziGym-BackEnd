
import 'package:server/data/DAO/ExercicioDAO.dart';
import 'package:server/Models/ExercicioModel.dart';


class ExercicioService {

  ExercicioDAO exerciciodao;

ExercicioService(this.exerciciodao);



  Future<List<ExercicioModel>>SearchExercicio  ({String? search}) async{
  
  List<ExercicioModel> exList = [];
  if (search == null || search.isEmpty) {
        exList =await exerciciodao.exercicioFindAll();
        } else {
          exList = await exerciciodao.exercicioFindByName(search);
        }
    return exList;





}
}