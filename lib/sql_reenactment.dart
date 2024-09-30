import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelperReenactment {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE reenactments(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        reenactmentName TEXT,
        reenactmentType TEXT,
        reenactmentReference TEXT,
        reenactmentAim TEXT,
        reenactmentSerialNumber TEXT,
        reenactmentActivityArea TEXT,
        reenactmentPurpose TEXT,
        reenactmentWebPage TEXT,
        reenactmentComment TEXT,
        reenactmentCompleted TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }
// id: the id of a item
// reenactmentName, reenactmentType: name and reenactmentType of your activity
// created_at: the time that the item was created. It will be automatically handled by SQLite

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'reenactments.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new item (reenactment)
  static Future<int> createReenactment(String reenactmentName,
      String? reenactmentType,
      String? reenactmentReference,
      String? reenactmentAim,
      String? reenactmentSerialNumber,
      String? reenactmentActivityArea,
      String? reenactmentPurpose,
      String? reenactmentWebPage,
      String? reenactmentComment,
      String reenactmentCompleted) async {
    final db = await SQLHelperReenactment.db();

    final data = {'reenactmentName': reenactmentName,
      'reenactmentType': reenactmentType,
      'reenactmentReference': reenactmentReference,
      'reenactmentAim': reenactmentAim,
      'reenactmentSerialNumber': reenactmentSerialNumber,
      'reenactmentActivityArea': reenactmentActivityArea,
      'reenactmentPurpose': reenactmentPurpose,
      'reenactmentWebPage': reenactmentWebPage,
      'reenactmentComment': reenactmentComment,
      'reenactmentCompleted': "false"};
    final id = await db.insert('reenactments', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all reenactments (reenactments)
  static Future<List<Map<String, dynamic>>> getReenactments() async {
    final db = await SQLHelperReenactment.db();
    return db.query('reenactments', orderBy: "reenactmentName");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getReenactment(int id) async {
    final db = await SQLHelperReenactment.db();
    return db.query('reenactments', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateReenactment(
      int id, String reenactmentName,
      String? reenactmentType,
      String? reenactmentReference,
      String? reenactmentAim,
      String? reenactmentSerialNumber,
      String? reenactmentActivityArea,
      String? reenactmentPurpose,
      String? reenactmentWebPage,
      String? reenactmentComment,
      String reenactmentCompleted) async {
    final db = await SQLHelperReenactment.db();

    final data = {
      'reenactmentName': reenactmentName,
      'reenactmentType': reenactmentType,
      'reenactmentReference': reenactmentReference,
      'reenactmentAim': reenactmentAim,
      'reenactmentSerialNumber': reenactmentSerialNumber,
      'reenactmentActivityArea': reenactmentActivityArea,
      'reenactmentPurpose': reenactmentPurpose,
      'reenactmentWebPage': reenactmentWebPage,
      'reenactmentComment': reenactmentComment,
      'reenactmentCompleted': reenactmentCompleted,
      'createdAt': DateTime.now().toString()
    };
    final result =
    await db.update('reenactments', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // item completed
  static Future<int> updateTaskStatus(
      int id,
      String reenactmentCompleted) async {
    final db = await SQLHelperReenactment.db();

    final data = {
      'reenactmentCompleted': reenactmentCompleted,
      'createdAt': DateTime.now().toString()
    };
    final result =
    await db.update('reenactments', data, where: "id = ?", whereArgs: [id]);
    return result;
  }


  // Delete
  static Future<void> deleteReenactment(int id) async {
    final db = await SQLHelperReenactment.db();
    try {
      await db.delete("reenactments", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}