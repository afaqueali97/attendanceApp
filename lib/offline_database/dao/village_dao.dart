import 'package:floor/floor.dart';

import '../entities/village_entity.dart';

@dao
abstract class VillageDao {
  @Query('SELECT * FROM VillageEntity')
  Future<List<VillageEntity>> getAllVillageEntities();

  @Query('SELECT * FROM VillageEntity WHERE id = :id')
  Future<VillageEntity?> getVillageEntityById(String id);

  @Query('SELECT * FROM VillageEntity WHERE ucId = :ucId')
  Future<List<VillageEntity>> getVillageEntitiesByUcId(String ucId);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertVillageEntity(VillageEntity villageEntity);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAllVillageEntities(List<VillageEntity> villageEntities);

  @delete
  Future<void> deleteVillageEntity(VillageEntity villageEntity);

  @Query('DELETE FROM VillageEntity')
  Future<void> deleteAllVillageEntities();
}
