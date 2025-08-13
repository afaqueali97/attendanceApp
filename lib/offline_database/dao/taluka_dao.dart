import 'package:floor/floor.dart';

import '../entities/taluka_entity.dart';

@dao
abstract class TalukaDao {
  @Query('SELECT * FROM TalukaEntity')
  Future<List<TalukaEntity>> getAllTalukas();

  @Query('SELECT * FROM TalukaEntity WHERE id = :id')
  Future<TalukaEntity?> getTalukaById(String id);

  @Query('SELECT * FROM TalukaEntity WHERE districtId = :districtId')
  Future<List<TalukaEntity>> getTalukaListByDistrictId(String districtId);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertTaluka(TalukaEntity taluka);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAllTalukas(List<TalukaEntity> talukaList);

  @delete
  Future<void> deleteTaluka(TalukaEntity taluka);

  @Query('DELETE FROM TalukaEntity')
  Future<void> deleteAllTalukas();
}
