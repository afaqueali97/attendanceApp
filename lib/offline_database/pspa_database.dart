
import 'package:floor/floor.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'dao/district_dao.dart';
import 'dao/division_dao.dart';
import 'dao/program_dao.dart';
import 'dao/taluka_dao.dart';
import 'dao/uc_dao.dart';
import 'dao/village_dao.dart';
import 'entities/district_entity.dart';
import 'entities/division_entity.dart';
import 'entities/program_entity.dart';
import 'entities/taluka_entity.dart';
import 'entities/uc_entity.dart';
import 'entities/village_entity.dart';

part 'pspa_database.g.dart';

@Database(
    version: 1,
    entities: [
      DivisionEntity,
      DistrictEntity,
      TalukaEntity,
      UCEntity,
      VillageEntity,
      ProgramEntity,
  
    ],
)

abstract class PSPADatabase extends FloorDatabase {
  DivisionDao get divisionDao;
  DistrictDao get districtDao;
  TalukaDao get talukaDao;
  UCDao get ucDao;
  VillageDao get villageDao;
  ProgramDao get programDao;

}