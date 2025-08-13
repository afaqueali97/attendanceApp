import '../../models/metadata/village_model.dart';
import '../app_db_client.dart';
import '../entities/village_entity.dart';
import '../pspa_database.dart';

class VillageFloorService {

  static final VillageFloorService _instance =  VillageFloorService._private();

  VillageFloorService._private();
  late PSPADatabase database;

  factory VillageFloorService() {
    return _instance;
  }
  

  Future<void> saveAllVillages({required List<VillageModel> villageList}) async {
    final PSPADatabase database = await AppDBClient().initializeDB();
    List<VillageEntity> veList = villageList.map<VillageEntity>((e) => e.toEntity()).toList();
    await database.villageDao.insertAllVillageEntities(veList);
  }
  Future<void> saveVillageToFloor({required VillageModel village}) async {
    final PSPADatabase database = await AppDBClient().initializeDB();
    await database.villageDao.insertVillageEntity(village.toEntity());
  }

  Future<void> deleteAllVillages() async {
    final PSPADatabase database = await AppDBClient().initializeDB();
    await database.villageDao.deleteAllVillageEntities();

  }
  Future<List<VillageModel>> getAllVillages() async {
    final PSPADatabase database = await AppDBClient().initializeDB();
    List<VillageEntity> villages = await database.villageDao.getAllVillageEntities();
    return villages.map<VillageModel>((e) => VillageModel.fromEntity(e)).toList();
  }

  Future<void> deleteVillage({required VillageModel village}) async {
    final PSPADatabase database = await AppDBClient().initializeDB();
    try {
      await database.villageDao.deleteVillageEntity(village.toEntity());
    } on Exception catch (_) {}
  }

  Future<List<VillageModel>> getVillageListByUcId({required  String ucId}) async{
    final PSPADatabase database = await AppDBClient().initializeDB();
    List<VillageEntity> villages = await database.villageDao.getVillageEntitiesByUcId(ucId);
    return villages.map<VillageModel>((e) => VillageModel.fromEntity(e)).toList();
  }

  Future<VillageModel> getVillageById({required  String villageId}) async{
    final PSPADatabase database = await AppDBClient().initializeDB();
    VillageModel villageModel= VillageModel.empty();
    VillageEntity? villageEntity=await database.villageDao.getVillageEntityById(villageId);
    if(villageEntity != null){
      return VillageModel.fromEntity(villageEntity);
    }

    return villageModel;
  }

}
