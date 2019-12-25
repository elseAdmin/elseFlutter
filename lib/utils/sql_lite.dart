import 'package:else_app_two/utils/app_startup_data.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:logger/logger.dart';

class SqlLiteManager {
  final logger = Logger();
  static Database _db;

  static final SqlLiteManager _instance = new SqlLiteManager.internal();
  factory SqlLiteManager() => _instance;
  SqlLiteManager.internal();

  Future<Database> get db async {
    if (_db == null) {
      _db = await initDb();
    }
    return _db;
  }

  initDb() async {
      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, "visits.db");
      await deleteDatabase(path);
      try {
        var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
        return theDb;
      } catch(e){
        logger.i(e);
      }
 return null;
  }

  _onCreate(Database db, int version) async {
    // Database is created, create the table
    await db.execute(
        "CREATE TABLE visits (id INTEGER PRIMARY KEY, uuid TEXT, major TEXT, minor TEXT, time TEXT)");
  }

  insertBeaconVisit(String major, String minor) async {
    Database db = await this.db;
    var id = await db.insert("visits", {
        'uuid': StartupData.uuid,
        'major': major,
        'minor': minor,
        'time': DateTime.now().millisecondsSinceEpoch.toString()
      });
    logger.i("inserted sql record " + major + " " + minor+" "+id.toString());
  }

  getLastVisitForBeacon(String major, String minor) async {
    Map rowValue = await getDbRow(major, minor, StartupData.uuid);
    return rowValue;
  }

  Future getDbRow(String major, String minor, String uuid) async {
    Database db = await this.db;
    List<Map> response = await db.query("visits",where: "uuid = ? AND major = ? AND minor = ?",whereArgs: [uuid,major,minor]);
    if (response.length != 0) {
      logger.i(response[0]);
      return response[0];
    } else {
      logger.i(response.length);
      return null;
    }
  }

  updateVisitTime(String major, String minor) async {
    Database db = await this.db;
    await db.rawUpdate(
        'UPDATE visits SET time = ${DateTime.now().millisecondsSinceEpoch.toString()} WHERE uuid=${StartupData.uuid} AND major = $major AND minor = $minor');
  }
}
