
import '../../models/public/program_model.dart';
import '../app_db_client.dart';
import '../entities/program_entity.dart';
import '../pspa_database.dart';

class ProgramFloorService {

  static final ProgramFloorService _instance =  ProgramFloorService._private();

  ProgramFloorService._private();
  late PSPADatabase database;

  factory ProgramFloorService() {
    return _instance;
  }

  Future<void> saveAllPrograms({required List<ProgramModel> programList}) async {
    final PSPADatabase database = await AppDBClient().initializeDB();
    List<ProgramEntity> programs = programList.map((e) => e.toEntity()).toList();
    await database.programDao.insertAllPrograms(programs);
  }

  Future<void> saveProgramToFloor({required ProgramModel program}) async {
    final PSPADatabase database = await AppDBClient().initializeDB();
    await database.programDao.insertProgram(program.toEntity());
  }

  Future<void> deleteAllPrograms() async {
    final PSPADatabase database = await AppDBClient().initializeDB();
    await database.programDao.deleteAllPrograms();

  }

  Future<List<ProgramModel>> getAllPrograms() async {
    final PSPADatabase database = await AppDBClient().initializeDB();
    List<ProgramEntity> programs = await database.programDao.findAllPrograms();
    return programs.map((e) => ProgramModel.fromEntity(e)).toList();
  }

  Future<ProgramModel> getProgramById({required  String programId}) async{
    final PSPADatabase database = await AppDBClient().initializeDB();
    ProgramModel programModel= ProgramModel.empty();
    ProgramEntity? programEntity=await database.programDao.findProgramById(programId);
    if(programEntity != null){
      return ProgramModel.fromEntity(programEntity);
    }
    return programModel;
  }

  
}