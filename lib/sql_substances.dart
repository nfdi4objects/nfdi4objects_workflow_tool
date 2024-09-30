import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelperSubstances {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE substances(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        substanceName TEXT,
        substanceType TEXT,
        substanceComment TEXT,
        substanceBinomial TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }
// id: the id of a item
// substanceName, substanceType: name and substanceType of your activity
// created_at: the time that the item was created. It will be automatically handled by SQLite

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'substances.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new item (substance)
  static Future<int> createSubstance(String substanceName, String? substanceType, String? substanceComment, String substanceBinomial) async {
    final db = await SQLHelperSubstances.db();

    final data = {'substanceName': substanceName, 'substanceType': substanceType, 'substanceComment': substanceComment, 'substanceBinomial': substanceBinomial};
    final id = await db.insert('substances', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all substances (substances)
  static Future<List<Map<String, dynamic>>> getSubstances() async {
    final db = await SQLHelperSubstances.db();
    return db.query('substances', orderBy: 'substanceName, substanceType');
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getSubstance(int id) async {
    final db = await SQLHelperSubstances.db();
    return db.query('substances', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateSubstance(
      int id, String substanceName, String? substanceType, String? substanceComment, String substanceBinomial) async {
    final db = await SQLHelperSubstances.db();

    final data = {
      'substanceName': substanceName,
      'substanceType': substanceType,
      'substanceComment': substanceComment,
      'substanceBinomial': substanceBinomial,
      'createdAt': DateTime.now().toString()
    };

    final result =
    await db.update('substances', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteSubstance(int id) async {
    final db = await SQLHelperSubstances.db();
    try {
      await db.delete("substances", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}