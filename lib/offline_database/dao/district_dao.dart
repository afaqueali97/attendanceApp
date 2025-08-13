import 'package:floor/floor.dart';
import '../entities/district_entity.dart';

@dao
abstract class DistrictDao {
  @Query('SELECT * FROM DistrictEntity')
  Future<List<DistrictEntity>> getAllDistricts();

  @Query('SELECT * FROM DistrictEntity WHERE id = :id')
  Future<DistrictEntity?> getDistrictById(String id);

  @Query('SELECT * FROM DistrictEntity WHERE division_id = :divisionId')
  Future<List<DistrictEntity>> getDistrictsByDivisionId(String divisionId);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertDistrict(DistrictEntity district);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAllDistricts(List<DistrictEntity> districts);

  @delete
  Future<void> deleteDistrict(DistrictEntity district);

  @Query('DELETE FROM DistrictEntity')
  Future<void> deleteAllDistricts();
}
