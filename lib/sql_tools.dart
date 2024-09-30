import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelperTools {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE tools(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        toolName TEXT,
        toolType TEXT,
        toolActivityArea TEXT,
        toolFunction TEXT,
        toolComment TEXT,
        toolBinomial TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }
// id: the id of a item
// toolName, toolType: name and toolType of your activity
// created_at: the time that the item was created. It will be automatically handled by SQLite

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'tools.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new item (tool)
  static Future<int> createTool(String toolName,
      String? toolType,
      String? toolActivityArea,
      String? toolFunction,
      String? toolComment,
      String? toolBinomial) async {
    final db = await SQLHelperTools.db();

    final data = {'toolName': toolName,
      'toolType': toolType,
      'toolActivityArea': toolActivityArea,
      'toolFunction': toolFunction,
      'toolComment': toolComment,
      'toolBinomial': toolBinomial};
    final id = await db.insert('tools', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all tools (tools)
  static Future<List<Map<String, dynamic>>> getTools() async {
    final db = await SQLHelperTools.db();
    return db.query('tools', orderBy: 'toolName, toolType');
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getTool(int id) async {
    final db = await SQLHelperTools.db();
    return db.query('tools', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateTool(
      int id,
      String toolName,
      String? toolType,
      String? toolActivityArea,
      String? toolFunction,
      String? toolComment,
      String toolBinomial) async {
    final db = await SQLHelperTools.db();

    final data = {
      'toolName': toolName,
      'toolType': toolType,
      'toolActivityArea': toolActivityArea,
      'toolFunction': toolFunction,
      'toolComment': toolComment,
      'toolBinomial': toolBinomial,
      'createdAt': DateTime.now().toString()
    };

    final result =
    await db.update('tools', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteTool(int id) async {
    final db = await SQLHelperTools.db();
    try {
      await db.delete("tools", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}