
// import 'package:pspa/models/item_model.dart';
// import 'package:pspa/offline_database/entities/division_entity.dart';
// import 'package:pspa/offline_database/pspa_database.dart';

import '../../models/item_model.dart';
import '../app_db_client.dart';
import '../entities/division_entity.dart';
import '../pspa_database.dart';

class DivisionFloorService {

  static final DivisionFloorService _instance =  DivisionFloorService._private();

  DivisionFloorService._private();
  late PSPADatabase database;

  factory DivisionFloorService() {
    return _instance;
  }

  Future<void> saveAllDivisions({required List<ItemModel> divisionList}) async {
    final PSPADatabase database = await AppDBClient().initializeDB();
    for(ItemModel divisionModel in divisionList) {
      await database.divisionDao.insertDivision(divisionModel.toEntity());
    }
  }
  Future<void> saveDivisionToFloor({required ItemModel division}) async {
    final PSPADatabase database = await AppDBClient().initializeDB();
    await database.divisionDao.insertDivision(division.toEntity());
  }

  Future<void> deleteAllDivisions() async {
    final PSPADatabase database = await AppDBClient().initializeDB();
    await database.divisionDao.deleteAllDivisions();

  }
  Future<List<ItemModel>> getAllDivision() async {
    final PSPADatabase database = await AppDBClient().initializeDB();
    List<DivisionEntity> divisions = await database.divisionDao.getAllDivision();
    return divisions.map((e) => ItemModel.fromEntity(e)).toList();
  }

  Future<ItemModel> getDivisionById({required  String divisionId}) async{
    final PSPADatabase database = await AppDBClient().initializeDB();
    ItemModel divisionModel= ItemModel.empty();
    DivisionEntity? divisionEntity = await database.divisionDao.getDivisionById(divisionId);
    if(divisionEntity != null){
      return ItemModel.fromEntity(divisionEntity);
    }
    return divisionModel;
  }

}
