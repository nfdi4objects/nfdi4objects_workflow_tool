import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelperExperiment {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE experiments(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        experimentName TEXT,
        experimentType TEXT,
        experimentReference TEXT,
        experimentAim TEXT,
        experimentSerialNumber TEXT,
        experimentActivityArea TEXT,
        experimentPurpose TEXT,
        experimentWebPage TEXT,
        experimentComment TEXT,
        experimentCompleted TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }
// id: the id of a item
// experimentName, experimentType: name and experimentType of your activity
// created_at: the time that the item was created. It will be automatically handled by SQLite

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'experiments.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new item (experiment)
  static Future<int> createExperiment(String experimentName,
      String? experimentType,
      String? experimentReference,
      String? experimentAim,
      String? experimentSerialNumber,
      String? experimentActivityArea,
      String? experimentPurpose,
      String? experimentWebPage,
      String? experimentComment,
      String experimentCompleted) async {
    final db = await SQLHelperExperiment.db();

    final data = {'experimentName': experimentName,
      'experimentType': experimentType,
      'experimentReference': experimentReference,
      'experimentAim': experimentAim,
      'experimentSerialNumber': experimentSerialNumber,
      'experimentActivityArea': experimentActivityArea,
      'experimentPurpose': experimentPurpose,
      'experimentWebPage': experimentWebPage,
      'experimentComment': experimentComment,
      'experimentCompleted': "false"};
    final id = await db.insert('experiments', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all experiments (experiments)
  static Future<List<Map<String, dynamic>>> getExperiments() async {
    final db = await SQLHelperExperiment.db();
    return db.query('experiments', orderBy: "experimentName");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getExperiment(int id) async {
    final db = await SQLHelperExperiment.db();
    return db.query('experiments', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateExperiment(
      int id, String experimentName,
      String? experimentType,
      String? experimentReference,
      String? experimentAim,
      String? experimentSerialNumber,
      String? experimentActivityArea,
      String? experimentPurpose,
      String? experimentWebPage,
      String? experimentComment,
      String experimentCompleted) async {
    final db = await SQLHelperExperiment.db();

    final data = {
      'experimentName': experimentName,
      'experimentType': experimentType,
      'experimentReference': experimentReference,
      'experimentAim': experimentAim,
      'experimentSerialNumber': experimentSerialNumber,
      'experimentActivityArea': experimentActivityArea,
      'experimentPurpose': experimentPurpose,
      'experimentWebPage': experimentWebPage,
      'experimentComment': experimentComment,
      'experimentCompleted': experimentCompleted,
      'createdAt': DateTime.now().toString()
    };

    final result =
    await db.update('experiments', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteExperiment(int id) async {
    final db = await SQLHelperExperiment.db();
    try {
      await db.delete("experiments", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}