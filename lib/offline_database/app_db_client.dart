
import '../offline_database/pspa_database.dart';

class AppDBClient {

  static final AppDBClient _instance = AppDBClient._private();

  AppDBClient._private();

  factory AppDBClient()=>_instance;

  PSPADatabase? _database;

  final String _databaseName = "SFEROfflineDB";

  Future<PSPADatabase> initializeDB() async {
    _database ??= await $FloorPSPADatabase.databaseBuilder(_databaseName).build();
    return _database!;
  }
}