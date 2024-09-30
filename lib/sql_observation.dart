import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelperObservation {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE observations(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        observationName TEXT,
        observationType TEXT,
        observationReference TEXT,
        observationAim TEXT,
        observationSerialNumber TEXT,
        observationActivityArea TEXT,
        observationPurpose TEXT,
        observationWebPage TEXT,
        observationComment TEXT,
        observationCompleted TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }
// id: the id of a item
// observationName, observationType: name and observationType of your activity
// created_at: the time that the item was created. It will be automatically handled by SQLite

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'observations.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new item (observation)
  static Future<int> createObservation(String observationName,
      String? observationType,
      String? observationReference,
      String? observationAim,
      String? observationSerialNumber,
      String? observationActivityArea,
      String? observationPurpose,
      String? observationWebPage,
      String? observationComment,
      String observationCompleted) async {
    final db = await SQLHelperObservation.db();

    final data = {'observationName': observationName,
      'observationType': observationType,
      'observationReference': observationReference,
      'observationAim': observationAim,
      'observationSerialNumber': observationSerialNumber,
      'observationActivityArea': observationActivityArea,
      'observationPurpose': observationPurpose,
      'observationWebPage': observationWebPage,
      'observationComment': observationComment,
      'observationCompleted': "false"};
    final id = await db.insert('observations', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all observations (observations)
  static Future<List<Map<String, dynamic>>> getObservations() async {
    final db = await SQLHelperObservation.db();
    return db.query('observations', orderBy: "observationName");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getObservation(int id) async {
    final db = await SQLHelperObservation.db();
    return db.query('observations', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateObservation(
      int id, String observationName,
      String? observationType,
      String? observationReference,
      String? observationAim,
      String? observationSerialNumber,
      String? observationActivityArea,
      String? observationPurpose,
      String? observationWebPage,
      String? observationComment,
      String observationCompleted) async {
    final db = await SQLHelperObservation.db();

    final data = {
      'observationName': observationName,
      'observationType': observationType,
      'observationReference': observationReference,
      'observationAim': observationAim,
      'observationSerialNumber': observationSerialNumber,
      'observationActivityArea': observationActivityArea,
      'observationPurpose': observationPurpose,
      'observationWebPage': observationWebPage,
      'observationComment': observationComment,
      'observationCompleted': observationCompleted,
      'createdAt': DateTime.now().toString()
    };

    final result =
    await db.update('observations', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteObservation(int id) async {
    final db = await SQLHelperObservation.db();
    try {
      await db.delete("observations", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}