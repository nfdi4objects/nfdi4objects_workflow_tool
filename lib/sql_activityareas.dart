import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelperActivityAreas {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        activityAreaName TEXT,
        activityAreaType TEXT,
        activityAreaFunction TEXT,
        activityAreaComment TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }
// id: the id of a item
// activityAreaName, activityAreaType: name and activityAreaType of your activity
// created_at: the time that the item was created. It will be automatically handled by SQLite

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'activityAreas.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new item (activityArea)
  static Future<int> createItem(String activityAreaName,
      String? activityAreaType,
      String? activityAreaFunction,
      String? activityAreaComment) async {
    final db = await SQLHelperActivityAreas.db();

    final data = {'activityAreaName': activityAreaName,
      'activityAreaType': activityAreaType,
      'activityAreaFunction': activityAreaFunction,
      'activityAreaComment': activityAreaComment};
    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all items (activityAreas)
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelperActivityAreas.db();
    return db.query('items', orderBy: "activityAreaName");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelperActivityAreas.db();
    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateItem(
      int id,
      String activityAreaName,
      String? activityAreaType,
      String? activityAreaFunction,
      String? activityAreaComment) async {
    final db = await SQLHelperActivityAreas.db();

    final data = {
      'activityAreaName': activityAreaName,
      'activityAreaType': activityAreaType,
      'activityAreaFunction': activityAreaFunction,
      'activityAreaComment': activityAreaComment,
      'createdAt': DateTime.now().toString()
    };

    final result =
    await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteItem(int id) async {
    final db = await SQLHelperActivityAreas.db();
    try {
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}