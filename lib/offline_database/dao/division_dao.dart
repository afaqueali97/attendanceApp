import 'package:floor/floor.dart';
import '../entities/division_entity.dart';

@dao
abstract class DivisionDao {
  @Query('SELECT * FROM DivisionEntity')
  Future<List<DivisionEntity>> getAllDivision();

  @Query('SELECT * FROM DivisionEntity WHERE id = :id LIMIT 1')
  Future<DivisionEntity?> getDivisionById(String id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertDivision(DivisionEntity divisions);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAllDivisions(List<DivisionEntity> divisions);

  @delete
  Future<void> deleteDivision(DivisionEntity divisions);

  @Query('DELETE FROM DivisionEntity')
  Future<void> deleteAllDivisions();
}
