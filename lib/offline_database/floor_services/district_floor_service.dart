import '../../models/metadata/district_model.dart';
import '../app_db_client.dart';
import '../entities/district_entity.dart';
import '../pspa_database.dart';

class DistrictFloorService {

  static final DistrictFloorService _instance =  DistrictFloorService._private();

  DistrictFloorService._private();
  late PSPADatabase database;

  factory DistrictFloorService() {
    return _instance;
  }

  Future<void> saveAllDistricts({required List<DistrictModel> districtList}) async {
    final PSPADatabase database = await AppDBClient().initializeDB();
    for(DistrictModel districtModel in districtList) {
      await database.districtDao.insertDistrict(districtModel.toEntity());
    }
  }
  Future<void> saveDistrictToFloor({required DistrictModel district}) async {
    final PSPADatabase database = await AppDBClient().initializeDB();
    await database.districtDao.insertDistrict(district.toEntity());
  }

  Future<void> deleteAllDistricts() async {
    final PSPADatabase database = await AppDBClient().initializeDB();
    await database.districtDao.deleteAllDistricts();

  }
  Future<List<DistrictModel>> getAllDistricts() async {
    final PSPADatabase database = await AppDBClient().initializeDB();
    List<DistrictEntity> districts = await database.districtDao.getAllDistricts();
    return districts.map((e) => DistrictModel.fromEntity(e)).toList();
  }

  Future<DistrictModel> getDistrictById({required  String districtId}) async{
    final PSPADatabase database = await AppDBClient().initializeDB();
    DistrictModel districtModel= DistrictModel.empty();
    DistrictEntity? districtEntity=await database.districtDao.getDistrictById(districtId);
    if(districtEntity != null){
      return DistrictModel.fromEntity(districtEntity);
    }
    return districtModel;
  }

  Future<List<DistrictModel>> getDistrictsByDivisionId({required String divisionId}) async {
    List<DistrictModel> districts = await getAllDistricts();
    return districts.where((element) => element.divisionId == divisionId).toList();
  }
}
