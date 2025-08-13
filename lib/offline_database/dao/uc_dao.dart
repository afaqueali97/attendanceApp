import 'package:floor/floor.dart';

import '../entities/uc_entity.dart';

@dao
abstract class UCDao {
  @Query('SELECT * FROM UCEntity')
  Future<List<UCEntity>> getAllUCEntities();

  @Query('SELECT * FROM UCEntity WHERE id = :id')
  Future<UCEntity?> getUCEntityById(String id);

  @Query('SELECT * FROM UCEntity WHERE talukaId = :talukaId')
  Future<List<UCEntity>> getUCEntitiesByTalukaId(String talukaId);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertUCEntity(UCEntity ucEntity);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAllUCEntities(List<UCEntity> ucEntities);

  @delete
  Future<void> deleteUCEntity(UCEntity ucEntity);

  @Query('DELETE FROM UCEntity')
  Future<void> deleteAllUCEntities();
}
