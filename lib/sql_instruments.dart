import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLInstrument {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE instruments(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        instrumentName TEXT,
        instrumentType TEXT,
        instrumentManufacturer TEXT,
        instrumentModel TEXT,
        instrumentSerialNumber TEXT,
        instrumentActivityArea TEXT,        
        instrumentFunction TEXT,        
        instrumentComment TEXT,
        instrumentBinomial TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }
// id: the id of a item
// instrumentName, instrumentType: name and instrumentType of your activity
// created_at: the time that the item was created. It will be automatically handled by SQLite

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'instruments.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new item (instrument)
  static Future<int> createInstrument(String instrumentName, String? instrumentType, String? instrumentManufacturer, String? instrumentModel, String? instrumentSerialNumber, String? instrumentActivityArea, String? instrumentFunction, String? instrumentComment, String instrumentBinomial) async {
    final db = await SQLInstrument.db();

    final data = {'instrumentName': instrumentName, 'instrumentType': instrumentType, 'instrumentManufacturer': instrumentManufacturer, 'instrumentModel': instrumentModel, 'instrumentSerialNumber': instrumentSerialNumber, 'instrumentActivityArea': instrumentActivityArea, 'instrumentFunction': instrumentFunction, 'instrumentComment': instrumentComment, 'instrumentBinomial': instrumentBinomial,};
    final id = await db.insert('instruments', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all instruments (instruments)
  static Future<List<Map<String, dynamic>>> getInstruments() async {
    final db = await SQLInstrument.db();
    return db.query('instruments', orderBy: 'instrumentName, instrumentType');
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getInstrument(int id) async {
    final db = await SQLInstrument.db();
    return db.query('instruments', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateInstrument(
      int id, String instrumentName, String? instrumentType, String? instrumentManufacturer, String? instrumentModel, String? instrumentSerialNumber, String? instrumentActivityArea, String? instrumentFunction, String? instrumentComment, String instrumentBinomial) async {
    final db = await SQLInstrument.db();

    final data = {
      'instrumentName': instrumentName,
      'instrumentType': instrumentType,
      'instrumentManufacturer': instrumentManufacturer,
      'instrumentModel': instrumentModel,
      'instrumentSerialNumber': instrumentSerialNumber,
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
    final db = await SQLInstrument.db();
    try {
      await db.delete("instruments", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}