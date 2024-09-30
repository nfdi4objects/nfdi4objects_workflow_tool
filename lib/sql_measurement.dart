import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelperMeasurement {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE measurements(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        measurementName TEXT,
        measurementType TEXT,
        measurementReference TEXT,
        measurementAim TEXT,
        measurementSerialNumber TEXT,
        measurementActivityArea TEXT,
        measurementPurpose TEXT,
        measurementWebPage TEXT,
        measurementComment TEXT,
        measurementCompleted TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }
// id: the id of a item
// measurementName, measurementType: name and measurementType of your activity
// created_at: the time that the item was created. It will be automatically handled by SQLite

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'measurements.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new item (measurement)
  static Future<int> createMeasurement(String measurementName,
      String? measurementType,
      String? measurementReference,
      String? measurementAim,
      String? measurementSerialNumber,
      String? measurementActivityArea,
      String? measurementPurpose,
      String? measurementWebPage,
      String? measurementComment,
      String measurementCompleted) async {
    final db = await SQLHelperMeasurement.db();

    final data = {'measurementName': measurementName,
      'measurementType': measurementType,
      'measurementReference': measurementReference,
      'measurementAim': measurementAim,
      'measurementSerialNumber': measurementSerialNumber,
      'measurementActivityArea': measurementActivityArea,
      'measurementPurpose': measurementPurpose,
      'measurementWebPage': measurementWebPage,
      'measurementComment': measurementComment,
      'measurementCompleted': "false"};
    final id = await db.insert('measurements', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all measurements (measurements)
  static Future<List<Map<String, dynamic>>> getMeasurements() async {
    final db = await SQLHelperMeasurement.db();
    return db.query('measurements', orderBy: "measurementName");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getMeasurement(int id) async {
    final db = await SQLHelperMeasurement.db();
    return db.query('measurements', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateMeasurement(
      int id, String measurementName,
      String? measurementType,
      String? measurementReference,
      String? measurementAim,
      String? measurementSerialNumber,
      String? measurementActivityArea,
      String? measurementPurpose,
      String? measurementWebPage,
      String? measurementComment,
      String measurementCompleted) async {
    final db = await SQLHelperMeasurement.db();

    final data = {
      'measurementName': measurementName,
      'measurementType': measurementType,
      'measurementReference': measurementReference,
      'measurementAim': measurementAim,
      'measurementSerialNumber': measurementSerialNumber,
      'measurementActivityArea': measurementActivityArea,
      'measurementPurpose': measurementPurpose,
      'measurementWebPage': measurementWebPage,
      'measurementComment': measurementComment,
      'measurementCompleted': measurementCompleted,
      'createdAt': DateTime.now().toString()
    };

    final result =
    await db.update('measurements', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteMeasurement(int id) async {
    final db = await SQLHelperMeasurement.db();
    try {
      await db.delete("measurements", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}