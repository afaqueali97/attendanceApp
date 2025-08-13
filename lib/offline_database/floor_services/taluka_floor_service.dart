
import '../../models/metadata/taluka_model.dart';
import '../app_db_client.dart';
import '../entities/taluka_entity.dart';
import '../pspa_database.dart';

class TalukaFloorService {

  static final TalukaFloorService _instance =  TalukaFloorService._private();

  TalukaFloorService._private();
  late PSPADatabase database;

  factory TalukaFloorService() {
    return _instance;
  }
  

  Future<void> saveAllTalukas({required List<TalukaModel> talukaList}) async {
    final PSPADatabase database = await AppDBClient().initializeDB();
    List<TalukaEntity> tsList = talukaList.map((e) => e.toEntity()).toList();
    await database.talukaDao.insertAllTalukas(tsList);
  }
  Future<void> saveTalukaToFloor({required TalukaModel taluka}) async {
    final PSPADatabase database = await AppDBClient().initializeDB();
    await database.talukaDao.insertTaluka(taluka.toEntity());
  }

  Future<void> deleteAllTalukas() async {
    final PSPADatabase database = await AppDBClient().initializeDB();
    await database.talukaDao.deleteAllTalukas();

  }
  Future<List<TalukaModel>> getAllTalukas() async {
    final PSPADatabase database = await AppDBClient().initializeDB();
    List<TalukaEntity> talukas = await database.talukaDao.getAllTalukas();
    return talukas.map((e) => TalukaModel.fromEntity(e)).toList();
  }

  Future<List<TalukaModel>> getTalukaByDistrictId({required  String districtId}) async{
    final PSPADatabase database = await AppDBClient().initializeDB();
    List<TalukaEntity> talukas =await database.talukaDao.getTalukaListByDistrictId(districtId);
    return talukas.map((e) => TalukaModel.fromEntity(e)).toList();
  }

  Future<TalukaModel> getTalukaById({required  String talukaId}) async{
    final PSPADatabase database = await AppDBClient().initializeDB();
    TalukaModel talukaModel= TalukaModel.empty();
    TalukaEntity? talukaEntity=await database.talukaDao.getTalukaById(talukaId);
    if(talukaEntity != null){
      return TalukaModel.fromEntity(talukaEntity);
    }
    return talukaModel;
  }

}
