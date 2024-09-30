import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
import '/diagram_editor/widget/menu.dart';

class SQLHelperToolMenu {
  final MenuComponentData menuData;
  SQLHelperToolMenu({required this.menuData});


  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'tools.db',
      version: 1,
    );
  }

  // Read all tools (tools)
  static Future<List<Map<String, dynamic>>> getTools() async {
    final db = await SQLHelperToolMenu.db();
    return db.query('tools', orderBy: 'toolType, toolName');
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getTool(int id) async {
    final db = await SQLHelperToolMenu.db();
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
      String? toolBinomial) async {
    final db = await SQLHelperToolMenu.db();

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
    final db = await SQLHelperToolMenu.db();
    try {
      await db.delete("tools", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}