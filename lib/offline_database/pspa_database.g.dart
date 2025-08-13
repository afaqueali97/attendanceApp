// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pspa_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorPSPADatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$PSPADatabaseBuilder databaseBuilder(String name) =>
      _$PSPADatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$PSPADatabaseBuilder inMemoryDatabaseBuilder() =>
      _$PSPADatabaseBuilder(null);
}

class _$PSPADatabaseBuilder {
  _$PSPADatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$PSPADatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$PSPADatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<PSPADatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$PSPADatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$PSPADatabase extends PSPADatabase {
  _$PSPADatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  DivisionDao? _divisionDaoInstance;

  DistrictDao? _districtDaoInstance;

  TalukaDao? _talukaDaoInstance;

  UCDao? _ucDaoInstance;

  VillageDao? _villageDaoInstance;

  ProgramDao? _programDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `DivisionEntity` (`id` TEXT NOT NULL, `name` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `DistrictEntity` (`id` TEXT NOT NULL, `divisionId` TEXT NOT NULL, `name` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `TalukaEntity` (`id` TEXT NOT NULL, `districtId` TEXT NOT NULL, `name` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `UCEntity` (`id` TEXT NOT NULL, `talukaId` TEXT NOT NULL, `name` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `VillageEntity` (`id` TEXT NOT NULL, `ucId` TEXT NOT NULL, `name` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ProgramEntity` (`id` TEXT NOT NULL, `title` TEXT NOT NULL, `iconPath` TEXT NOT NULL, `programDescription` TEXT NOT NULL, `borderColorCode` INTEGER NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  DivisionDao get divisionDao {
    return _divisionDaoInstance ??= _$DivisionDao(database, changeListener);
  }

  @override
  DistrictDao get districtDao {
    return _districtDaoInstance ??= _$DistrictDao(database, changeListener);
  }

  @override
  TalukaDao get talukaDao {
    return _talukaDaoInstance ??= _$TalukaDao(database, changeListener);
  }

  @override
  UCDao get ucDao {
    return _ucDaoInstance ??= _$UCDao(database, changeListener);
  }

  @override
  VillageDao get villageDao {
    return _villageDaoInstance ??= _$VillageDao(database, changeListener);
  }

  @override
  ProgramDao get programDao {
    return _programDaoInstance ??= _$ProgramDao(database, changeListener);
  }
}

class _$DivisionDao extends DivisionDao {
  _$DivisionDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _divisionEntityInsertionAdapter = InsertionAdapter(
            database,
            'DivisionEntity',
            (DivisionEntity item) =>
                <String, Object?>{'id': item.id, 'name': item.name}),
        _divisionEntityDeletionAdapter = DeletionAdapter(
            database,
            'DivisionEntity',
            ['id'],
            (DivisionEntity item) =>
                <String, Object?>{'id': item.id, 'name': item.name});

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<DivisionEntity> _divisionEntityInsertionAdapter;

  final DeletionAdapter<DivisionEntity> _divisionEntityDeletionAdapter;

  @override
  Future<List<DivisionEntity>> getAllDivision() async {
    return _queryAdapter.queryList('SELECT * FROM DivisionEntity',
        mapper: (Map<String, Object?> row) => DivisionEntity(
            id: row['id'] as String, name: row['name'] as String));
  }

  @override
  Future<DivisionEntity?> getDivisionById(String id) async {
    return _queryAdapter.query(
        'SELECT * FROM DivisionEntity WHERE id = ?1 LIMIT 1',
        mapper: (Map<String, Object?> row) => DivisionEntity(
            id: row['id'] as String, name: row['name'] as String),
        arguments: [id]);
  }

  @override
  Future<void> deleteAllDivisions() async {
    await _queryAdapter.queryNoReturn('DELETE FROM DivisionEntity');
  }

  @override
  Future<void> insertDivision(DivisionEntity divisions) async {
    await _divisionEntityInsertionAdapter.insert(
        divisions, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertAllDivisions(List<DivisionEntity> divisions) async {
    await _divisionEntityInsertionAdapter.insertList(
        divisions, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteDivision(DivisionEntity divisions) async {
    await _divisionEntityDeletionAdapter.delete(divisions);
  }
}

class _$DistrictDao extends DistrictDao {
  _$DistrictDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _districtEntityInsertionAdapter = InsertionAdapter(
            database,
            'DistrictEntity',
            (DistrictEntity item) => <String, Object?>{
                  'id': item.id,
                  'divisionId': item.divisionId,
                  'name': item.name
                }),
        _districtEntityDeletionAdapter = DeletionAdapter(
            database,
            'DistrictEntity',
            ['id'],
            (DistrictEntity item) => <String, Object?>{
                  'id': item.id,
                  'divisionId': item.divisionId,
                  'name': item.name
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<DistrictEntity> _districtEntityInsertionAdapter;

  final DeletionAdapter<DistrictEntity> _districtEntityDeletionAdapter;

  @override
  Future<List<DistrictEntity>> getAllDistricts() async {
    return _queryAdapter.queryList('SELECT * FROM DistrictEntity',
        mapper: (Map<String, Object?> row) => DistrictEntity(
            id: row['id'] as String,
            divisionId: row['divisionId'] as String,
            name: row['name'] as String));
  }

  @override
  Future<DistrictEntity?> getDistrictById(String id) async {
    return _queryAdapter.query('SELECT * FROM DistrictEntity WHERE id = ?1',
        mapper: (Map<String, Object?> row) => DistrictEntity(
            id: row['id'] as String,
            divisionId: row['divisionId'] as String,
            name: row['name'] as String),
        arguments: [id]);
  }

  @override
  Future<List<DistrictEntity>> getDistrictsByDivisionId(
      String divisionId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM DistrictEntity WHERE division_id = ?1',
        mapper: (Map<String, Object?> row) => DistrictEntity(
            id: row['id'] as String,
            divisionId: row['divisionId'] as String,
            name: row['name'] as String),
        arguments: [divisionId]);
  }

  @override
  Future<void> deleteAllDistricts() async {
    await _queryAdapter.queryNoReturn('DELETE FROM DistrictEntity');
  }

  @override
  Future<void> insertDistrict(DistrictEntity district) async {
    await _districtEntityInsertionAdapter.insert(
        district, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertAllDistricts(List<DistrictEntity> districts) async {
    await _districtEntityInsertionAdapter.insertList(
        districts, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteDistrict(DistrictEntity district) async {
    await _districtEntityDeletionAdapter.delete(district);
  }
}

class _$TalukaDao extends TalukaDao {
  _$TalukaDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _talukaEntityInsertionAdapter = InsertionAdapter(
            database,
            'TalukaEntity',
            (TalukaEntity item) => <String, Object?>{
                  'id': item.id,
                  'districtId': item.districtId,
                  'name': item.name
                }),
        _talukaEntityDeletionAdapter = DeletionAdapter(
            database,
            'TalukaEntity',
            ['id'],
            (TalukaEntity item) => <String, Object?>{
                  'id': item.id,
                  'districtId': item.districtId,
                  'name': item.name
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TalukaEntity> _talukaEntityInsertionAdapter;

  final DeletionAdapter<TalukaEntity> _talukaEntityDeletionAdapter;

  @override
  Future<List<TalukaEntity>> getAllTalukas() async {
    return _queryAdapter.queryList('SELECT * FROM TalukaEntity',
        mapper: (Map<String, Object?> row) => TalukaEntity(
            id: row['id'] as String,
            districtId: row['districtId'] as String,
            name: row['name'] as String));
  }

  @override
  Future<TalukaEntity?> getTalukaById(String id) async {
    return _queryAdapter.query('SELECT * FROM TalukaEntity WHERE id = ?1',
        mapper: (Map<String, Object?> row) => TalukaEntity(
            id: row['id'] as String,
            districtId: row['districtId'] as String,
            name: row['name'] as String),
        arguments: [id]);
  }

  @override
  Future<List<TalukaEntity>> getTalukaListByDistrictId(
      String districtId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM TalukaEntity WHERE districtId = ?1',
        mapper: (Map<String, Object?> row) => TalukaEntity(
            id: row['id'] as String,
            districtId: row['districtId'] as String,
            name: row['name'] as String),
        arguments: [districtId]);
  }

  @override
  Future<void> deleteAllTalukas() async {
    await _queryAdapter.queryNoReturn('DELETE FROM TalukaEntity');
  }

  @override
  Future<void> insertTaluka(TalukaEntity taluka) async {
    await _talukaEntityInsertionAdapter.insert(
        taluka, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertAllTalukas(List<TalukaEntity> talukaList) async {
    await _talukaEntityInsertionAdapter.insertList(
        talukaList, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteTaluka(TalukaEntity taluka) async {
    await _talukaEntityDeletionAdapter.delete(taluka);
  }
}

class _$UCDao extends UCDao {
  _$UCDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _uCEntityInsertionAdapter = InsertionAdapter(
            database,
            'UCEntity',
            (UCEntity item) => <String, Object?>{
                  'id': item.id,
                  'talukaId': item.talukaId,
                  'name': item.name
                }),
        _uCEntityDeletionAdapter = DeletionAdapter(
            database,
            'UCEntity',
            ['id'],
            (UCEntity item) => <String, Object?>{
                  'id': item.id,
                  'talukaId': item.talukaId,
                  'name': item.name
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<UCEntity> _uCEntityInsertionAdapter;

  final DeletionAdapter<UCEntity> _uCEntityDeletionAdapter;

  @override
  Future<List<UCEntity>> getAllUCEntities() async {
    return _queryAdapter.queryList('SELECT * FROM UCEntity',
        mapper: (Map<String, Object?> row) => UCEntity(
            id: row['id'] as String,
            talukaId: row['talukaId'] as String,
            name: row['name'] as String));
  }

  @override
  Future<UCEntity?> getUCEntityById(String id) async {
    return _queryAdapter.query('SELECT * FROM UCEntity WHERE id = ?1',
        mapper: (Map<String, Object?> row) => UCEntity(
            id: row['id'] as String,
            talukaId: row['talukaId'] as String,
            name: row['name'] as String),
        arguments: [id]);
  }

  @override
  Future<List<UCEntity>> getUCEntitiesByTalukaId(String talukaId) async {
    return _queryAdapter.queryList('SELECT * FROM UCEntity WHERE talukaId = ?1',
        mapper: (Map<String, Object?> row) => UCEntity(
            id: row['id'] as String,
            talukaId: row['talukaId'] as String,
            name: row['name'] as String),
        arguments: [talukaId]);
  }

  @override
  Future<void> deleteAllUCEntities() async {
    await _queryAdapter.queryNoReturn('DELETE FROM UCEntity');
  }

  @override
  Future<void> insertUCEntity(UCEntity ucEntity) async {
    await _uCEntityInsertionAdapter.insert(
        ucEntity, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertAllUCEntities(List<UCEntity> ucEntities) async {
    await _uCEntityInsertionAdapter.insertList(
        ucEntities, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteUCEntity(UCEntity ucEntity) async {
    await _uCEntityDeletionAdapter.delete(ucEntity);
  }
}

class _$VillageDao extends VillageDao {
  _$VillageDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _villageEntityInsertionAdapter = InsertionAdapter(
            database,
            'VillageEntity',
            (VillageEntity item) => <String, Object?>{
                  'id': item.id,
                  'ucId': item.ucId,
                  'name': item.name
                }),
        _villageEntityDeletionAdapter = DeletionAdapter(
            database,
            'VillageEntity',
            ['id'],
            (VillageEntity item) => <String, Object?>{
                  'id': item.id,
                  'ucId': item.ucId,
                  'name': item.name
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<VillageEntity> _villageEntityInsertionAdapter;

  final DeletionAdapter<VillageEntity> _villageEntityDeletionAdapter;

  @override
  Future<List<VillageEntity>> getAllVillageEntities() async {
    return _queryAdapter.queryList('SELECT * FROM VillageEntity',
        mapper: (Map<String, Object?> row) => VillageEntity(
            id: row['id'] as String,
            ucId: row['ucId'] as String,
            name: row['name'] as String));
  }

  @override
  Future<VillageEntity?> getVillageEntityById(String id) async {
    return _queryAdapter.query('SELECT * FROM VillageEntity WHERE id = ?1',
        mapper: (Map<String, Object?> row) => VillageEntity(
            id: row['id'] as String,
            ucId: row['ucId'] as String,
            name: row['name'] as String),
        arguments: [id]);
  }

  @override
  Future<List<VillageEntity>> getVillageEntitiesByUcId(String ucId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM VillageEntity WHERE ucId = ?1',
        mapper: (Map<String, Object?> row) => VillageEntity(
            id: row['id'] as String,
            ucId: row['ucId'] as String,
            name: row['name'] as String),
        arguments: [ucId]);
  }

  @override
  Future<void> deleteAllVillageEntities() async {
    await _queryAdapter.queryNoReturn('DELETE FROM VillageEntity');
  }

  @override
  Future<void> insertVillageEntity(VillageEntity villageEntity) async {
    await _villageEntityInsertionAdapter.insert(
        villageEntity, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertAllVillageEntities(
      List<VillageEntity> villageEntities) async {
    await _villageEntityInsertionAdapter.insertList(
        villageEntities, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteVillageEntity(VillageEntity villageEntity) async {
    await _villageEntityDeletionAdapter.delete(villageEntity);
  }
}

class _$ProgramDao extends ProgramDao {
  _$ProgramDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _programEntityInsertionAdapter = InsertionAdapter(
            database,
            'ProgramEntity',
            (ProgramEntity item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'iconPath': item.iconPath,
                  'programDescription': item.programDescription,
                  'borderColorCode': item.borderColorCode
                }),
        _programEntityDeletionAdapter = DeletionAdapter(
            database,
            'ProgramEntity',
            ['id'],
            (ProgramEntity item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'iconPath': item.iconPath,
                  'programDescription': item.programDescription,
                  'borderColorCode': item.borderColorCode
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ProgramEntity> _programEntityInsertionAdapter;

  final DeletionAdapter<ProgramEntity> _programEntityDeletionAdapter;

  @override
  Future<List<ProgramEntity>> findAllPrograms() async {
    return _queryAdapter.queryList('SELECT * FROM ProgramEntity',
        mapper: (Map<String, Object?> row) => ProgramEntity(
            id: row['id'] as String,
            title: row['title'] as String,
            iconPath: row['iconPath'] as String,
            programDescription: row['programDescription'] as String,
            borderColorCode: row['borderColorCode'] as int));
  }

  @override
  Future<ProgramEntity?> findProgramById(String id) async {
    return _queryAdapter.query('SELECT * FROM ProgramEntity WHERE id = ?1',
        mapper: (Map<String, Object?> row) => ProgramEntity(
            id: row['id'] as String,
            title: row['title'] as String,
            iconPath: row['iconPath'] as String,
            programDescription: row['programDescription'] as String,
            borderColorCode: row['borderColorCode'] as int),
        arguments: [id]);
  }

  @override
  Future<void> deleteAllPrograms() async {
    await _queryAdapter.queryNoReturn('DELETE FROM ProgramEntity');
  }

  @override
  Future<void> insertProgram(ProgramEntity programEntity) async {
    await _programEntityInsertionAdapter.insert(
        programEntity, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertAllPrograms(List<ProgramEntity> programEntities) async {
    await _programEntityInsertionAdapter.insertList(
        programEntities, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteProgram(ProgramEntity programEntity) async {
    await _programEntityDeletionAdapter.delete(programEntity);
  }
}
