import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLInstitution {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        institutionName TEXT,
        iExperimentation TEXT,
        iObservation TEXT,
        iMeasurement TEXT,
        iReplication TEXT,
        iReconstruction TEXT,
        iReenactment TEXT,
        iRecipe TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }
// id: the id of a item
// institutionName, iExperimentation: name and iExperimentation of your activity
// created_at: the time that the item was created. It will be automatically handled by SQLite

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'institution_function.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new item (institution)
  static Future<int> createItem(String institutionName,
      bool? iExperimentation,
      bool? iObservation,
      bool? iMeasurement,
      bool? iReplication,
      bool? iReconstruction,
      bool? iReenactment,
      bool? iRecipe,
      ) async {
    final db = await SQLInstitution.db();

    final data = {'institutionName': institutionName,
      'iExperimentation': iExperimentation,
      'iObservation': iObservation,
      'iMeasurement': iMeasurement,
      'iReplication': iReplication,
      'iReconstruction': iReconstruction,
      'iReenactment': iReenactment,
      'iRecipe': iRecipe};
    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all items (institutions)
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLInstitution.db();
    return db.query('items', orderBy: "institutionName");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLInstitution.db();
    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateItem(int id,
      String institutionName,
      String? iExperimentation,
      String? iObservation,
      String? iMeasurement,
      String? iReplication,
      String? iReconstruction,
      String? iReenactment,
      String? iRecipe,
      ) async {
    final db = await SQLInstitution.db();

    final data = {
      'institutionName': institutionName,
      'iExperimentation': iExperimentation,
      'iObservation': iObservation,
      'iMeasurement': iMeasurement,
      'iReplication': iReplication,
      'iReconstruction': iReconstruction,
      'iReenactment': iReenactment,
      'iRecipe': iRecipe,
      'createdAt': DateTime.now().toString()
    };

    final result =
    await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteItem(int id) async {
    final db = await SQLInstitution.db();
    try {
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}