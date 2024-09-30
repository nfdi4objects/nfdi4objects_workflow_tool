import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelperReplication {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE replications(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        replicationName TEXT,
        replicationType TEXT,
        replicationReference TEXT,
        replicationAim TEXT,
        replicationSerialNumber TEXT,
        replicationActivityArea TEXT,
        replicationPurpose TEXT,
        replicationWebPage TEXT,
        replicationComment TEXT,
        replicationCompleted TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }
// id: the id of a item
// replicationName, replicationType: name and replicationType of your activity
// created_at: the time that the item was created. It will be automatically handled by SQLite

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'replications.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new item (replication)
  static Future<int> createReplication(String replicationName,
      String? replicationType,
      String? replicationReference,
      String? replicationAim,
      String? replicationSerialNumber,
      String? replicationActivityArea,
      String? replicationPurpose,
      String? replicationWebPage,
      String? replicationComment,
      String replicationCompleted) async {
    final db = await SQLHelperReplication.db();

    final data = {'replicationName': replicationName,
      'replicationType': replicationType,
      'replicationReference': replicationReference,
      'replicationAim': replicationAim,
      'replicationSerialNumber': replicationSerialNumber,
      'replicationActivityArea': replicationActivityArea,
      'replicationPurpose': replicationPurpose,
      'replicationWebPage': replicationWebPage,
      'replicationComment': replicationComment,
      'replicationCompleted': "false"};
    final id = await db.insert('replications', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all replications (replications)
  static Future<List<Map<String, dynamic>>> getReplications() async {
    final db = await SQLHelperReplication.db();
    return db.query('replications', orderBy: "replicationName");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getReplication(int id) async {
    final db = await SQLHelperReplication.db();
    return db.query('replications', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateReplication(
      int id, String replicationName,
      String? replicationType,
      String? replicationReference,
      String? replicationAim,
      String? replicationSerialNumber,
      String? replicationActivityArea,
      String? replicationPurpose,
      String? replicationWebPage,
      String? replicationComment,
      String replicationCompleted) async {
    final db = await SQLHelperReplication.db();

    final data = {
      'replicationName': replicationName,
      'replicationType': replicationType,
      'replicationReference': replicationReference,
      'replicationAim': replicationAim,
      'replicationSerialNumber': replicationSerialNumber,
      'replicationActivityArea': replicationActivityArea,
      'replicationPurpose': replicationPurpose,
      'replicationWebPage': replicationWebPage,
      'replicationComment': replicationComment,
      'replicationCompleted': replicationCompleted,
      'createdAt': DateTime.now().toString()
    };

    final result =
    await db.update('replications', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteReplication(int id) async {
    final db = await SQLHelperReplication.db();
    try {
      await db.delete("replications", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}