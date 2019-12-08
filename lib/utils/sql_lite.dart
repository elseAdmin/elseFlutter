import 'dart:io';

import 'package:else_app_two/utils/app_startup_data.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:logger/logger.dart';
class SqlLiteManager{
  final logger = Logger();
  static Database _db;

  Future<Database> get db async {

    if (_db != null)
      return _db;

    _db = await initDb();
    return _db;

  }

  initDb() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, "visits.db");

    await deleteDatabase(path);
    var theDb = await openDatabase(path, version: 1,
        onCreate: _onCreate);

    return theDb;
  }

  _onCreate(Database db, int version) async {
    // Database is created, create the table
    await db.execute(
        "CREATE TABLE visits (id INTEGER PRIMARY KEY, uuid TEXT, major TEXT, minor TEXT, time TEXT)");
  }

  insertBeaconVisit(String major,String minor) async{
    var dbClient = await db;
    await dbClient.insert("visits",{'uuid':StartupData.uuid,'major':major, 'minor':minor, 'time':DateTime.now().millisecondsSinceEpoch.toString()});
  }

  getLastVisitForBeacon(String major,String minor) async {
    List rowValue = await getDbRow(major, minor, StartupData.uuid);
    if(rowValue.length != 0){
      logger.i("timestamp of last visit : "+rowValue[0].row[4]);
      return rowValue[0].row[4];
    }else{
      return null;
    }

  /*  var lastVisitTimestamp;
    row.then((rowValue){

    });*/
  }

  Future getDbRow(String major,String minor,String uuid) async{
    var dbClient = await db;
    var result = await dbClient.rawQuery('SELECT * FROM visits');//WHERE uuid=$uuid AND major=$major AND minor=$minor');
    return result.toList();
  }

  updateVisitTime(String major,String minor) async {
    var dbClient = await db;
    await dbClient.rawUpdate(
        'UPDATE visits SET time = ${DateTime.now().millisecondsSinceEpoch.toString()} WHERE major = ${major} AND minor = ${minor}'
    );
  }
}