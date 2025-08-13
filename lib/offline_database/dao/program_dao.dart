import 'package:floor/floor.dart';
import '../entities/program_entity.dart';

@dao
abstract class ProgramDao {
  @Query('SELECT * FROM ProgramEntity')
  Future<List<ProgramEntity>> findAllPrograms();

  @Query('SELECT * FROM ProgramEntity WHERE id = :id')
  Future<ProgramEntity?> findProgramById(String id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertProgram(ProgramEntity programEntity);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAllPrograms(List<ProgramEntity> programEntities);

  @delete
  Future<void> deleteProgram(ProgramEntity programEntity);

  @Query('DELETE FROM ProgramEntity')
  Future<void> deleteAllPrograms();
}