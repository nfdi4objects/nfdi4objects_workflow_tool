import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
import '/diagram_editor/widget/menu.dart';

class SQLHelperInstrumentMenu {
  final MenuComponentData menuData;
  SQLHelperInstrumentMenu({required this.menuData});


  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'instruments.db',
      version: 1,
    );
  }

  // Read all instruments (instruments)
  static Future<List<Map<String, dynamic>>> getInstruments() async {
    final db = await SQLHelperInstrumentMenu.db();
    return db.query('instruments', orderBy: 'instrumentName, instrumentType');
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getInstrument(int id) async {
    final db = await SQLHelperInstrumentMenu.db();
    return db.query('instruments', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateInstrument(
      int id,
      String instrumentName,
      String? instrumentType,
      String? instrumentActivityArea,
      String? instrumentFunction,
      String? instrumentComment,
      String instrumentBinomial) async {
    final db = await SQLHelperInstrumentMenu.db();

    final data = {
      'instrumentName': instrumentName,
      'instrumentType': instrumentType,
      'instrumentActivityArea': instrumentActivityArea,
      'instrumentFunction': instrumentFunction,
      'instrumentComment': instrumentComment,
      'instrumentBinomial': instrumentBinomial,
      'createdAt': DateTime.now().toString()
    };

    final result =
    await db.update('instruments', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteInstrument(int id) async {
    final db = await SQLHelperInstrumentMenu.db();
    try {
      await db.delete("instruments", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}