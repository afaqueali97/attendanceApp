
import '../../models/metadata/union_council_model.dart';
import '../app_db_client.dart';
import '../entities/uc_entity.dart';
import '../pspa_database.dart';

class UCFloorService {

  static final UCFloorService _instance =  UCFloorService._private();

  UCFloorService._private();
  late PSPADatabase database;

  factory UCFloorService() {
    return _instance;
  }

  Future<void> saveUCToFloor({required UnionCouncilModel uc}) async {
    final PSPADatabase database = await AppDBClient().initializeDB();
    await database.ucDao.insertUCEntity(uc.toEntity());
  }

  Future<void> saveAllUCs({required List<UnionCouncilModel> ucList}) async {
    List<UCEntity> ueList = ucList.map((e) => e.toEntity()).toList();
    final PSPADatabase database = await AppDBClient().initializeDB();
    for(UCEntity ue in ueList) {
      await database.ucDao.insertUCEntity(ue);
    }
    // await database.ucDao.insertAllUCEntities(ueList);
  }

  Future<void> deleteAllUCts() async {
    final PSPADatabase database = await AppDBClient().initializeDB();
    await database.ucDao.deleteAllUCEntities();

  }
  Future<List<UnionCouncilModel>> getAllUCs() async {
    final PSPADatabase database = await AppDBClient().initializeDB();
    List<UCEntity> ucs = await database.ucDao.getAllUCEntities();
    return ucs.map((e) => UnionCouncilModel.fromEntity(e)).toList();
  }

  Future<List<UnionCouncilModel>> getUCListByTalukaId({required  String talukaId}) async{
    final PSPADatabase database = await AppDBClient().initializeDB();
    List<UCEntity> ucs = await database.ucDao.getUCEntitiesByTalukaId(talukaId);

    return ucs.map((e) => UnionCouncilModel.fromEntity(e)).toList();
  }

  Future<UnionCouncilModel> getUcById({required  String ucId}) async{
    final PSPADatabase database = await AppDBClient().initializeDB();
    UnionCouncilModel ucModel= UnionCouncilModel.empty();
    UCEntity? ucEntity=await database.ucDao.getUCEntityById(ucId);
    if(ucEntity != null){
      return UnionCouncilModel.fromEntity(ucEntity);
    }
    return ucModel;
  }

}
