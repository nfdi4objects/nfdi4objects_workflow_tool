import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelperCompounds {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE compounds(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        compoundName TEXT,
        compoundType TEXT,
        compoundManufacturer TEXT,
        compoundComment TEXT,
        compoundBinomial TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }
// id: the id of a item
// compoundName, compoundType: name and compoundType of your activity
// created_at: the time that the item was created. It will be automatically handled by SQLite

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'compounds.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new item (compound)
  static Future<int> createItem(String compoundName, String? compoundType, String? compoundManufacturer, String? compoundComment, String compoundBinomial) async {
    final db = await SQLHelperCompounds.db();

    final data = {'compoundName': compoundName, 'compoundType': compoundType, 'compoundManufacturer': compoundManufacturer, 'compoundComment': compoundComment, 'compoundBinomial': compoundBinomial};
    final id = await db.insert('compounds', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all compounds (compounds)
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelperCompounds.db();
    return db.query('compounds', orderBy: "compoundName, compoundType");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelperCompounds.db();
    return db.query('compounds', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateItem(
      int id, String compoundName, String? compoundType, String? compoundManufacturer, String? compoundComment, String compoundBinomial) async {
    final db = await SQLHelperCompounds.db();

    final data = {
      'compoundName': compoundName,
      'compoundType': compoundType,
      'compoundManufacturer': compoundManufacturer,
      'compoundComment': compoundComment,
      'compoundBinomial': compoundBinomial,
      'createdAt': DateTime.now().toString()
    };

    final result =
    await db.update('compounds', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteItem(int id) async {
    final db = await SQLHelperCompounds.db();
    try {
      await db.delete("compounds", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}