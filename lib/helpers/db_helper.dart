import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';
import 'dart:async';

class DbHelper {
  static Future<Database> databaseForJourneys() async {
    //......................................Getting access to DB
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
        // searches for db ,if not found,it creats db
        path.join(dbPath, 'Journeys.db'), onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE Journeys(id INTEGER PRIMARY KEY,name TEXT,targetWeight REAL,targetDurationInWeeks INTEGER,weightTableName TEXT,lose0Gain1 INTEGER,journeyOver INTEGER)');
    }, version: 1);

    //......................................Getting access to DB
  }

  static Future<Database> databaseForWeight(
      String weightDatabaseTableName) async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, '$weightDatabaseTableName.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE $weightDatabaseTableName(dateTime TEXT PRIMARY KEY,weight REAL,havePicture01 INTEGER,picturePath TEXT)');
    }, version: 1);
  }

  static Future<void> insertJourney(
    String table,
    Map<String, Object> newJourney,
    //  Map<String, Object> weight,
    /*   {Map<String, Object> weight}*/
  ) async {
    String weightDatabaseTableName = 'weight${newJourney['id'].toString()}';
//..............................inserting journey
    final dbForJourneys = await DbHelper.databaseForJourneys();
    dbForJourneys.insert(table, newJourney,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    // insertWeight(weightDatabaseTableName,
    //   weight); //creating table and inserting first weight
    //..............................inserting jourey
  }

  static Future<void> insertWeight(
      String weightDatabaseTableName, Map<String, Object> weight) async {
    final dbForWeight =
        await DbHelper.databaseForWeight(weightDatabaseTableName);
    dbForWeight.insert(weightDatabaseTableName, weight,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<int> deleteSingleWeight(
      String dateTime, String weightDatabaseTableName) async {
    final dbPath = await sql.getDatabasesPath();
    final dbPathWhereTableIs = path.join(dbPath, '$weightDatabaseTableName.db');
    final database = await sql.openDatabase(dbPathWhereTableIs);
    int futureCount = await database.delete(
      '$weightDatabaseTableName',
      where: 'dateTime = ?',
      whereArgs: [
        dateTime
      ], /*
      'DELETE FROM $table WHERE dateTime = "$dateTime"',  [dateTime]*/
    );
    // assert(futureCount == 1);

    return futureCount;
  }

  static Future<int> deleteDatabase(String weightDatabaseTableName) async {
    // Get a location using getDatabasesPath
    var databasesPath = await sql.getDatabasesPath();
    String paath = path.join(databasesPath, '$weightDatabaseTableName.db');
    await sql.deleteDatabase(paath);
  }

  static Future<int> deleteSingleJourney(int id, String table) async {
    //final dbPath = await sql.getDatabasesPath();
    //final dbPathWhereTableIs = path.join(dbPath, 'Journeys.db');
    //final database = await sql.openDatabase(dbPathWhereTableIs);
    final database = await DbHelper.databaseForJourneys();
    int futureCount = await database.delete(
      'Journeys',
      where: 'id = ?',
      whereArgs: [
        id
      ], /*
      'DELETE FROM $table WHERE dateTime = "$dateTime"',  [dateTime]*/
    );
    // assert(futureCount == 1);

    return futureCount;
  }

  static Future<List<Map<String, dynamic>>> getJourneyData() async {
    final db = await DbHelper.databaseForJourneys();
    return db.query('Journeys');
  }

  static Future<List<Map<String, dynamic>>> getWeightData(
      String weightDatabaseTableName) async {
    final db = await DbHelper.databaseForWeight(weightDatabaseTableName);
    return db.query('$weightDatabaseTableName');
  }
}
