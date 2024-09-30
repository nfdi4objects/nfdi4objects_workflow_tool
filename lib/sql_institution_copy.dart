import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLInstitution {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        institutionName TEXT,
        institutionType TEXT,
        institutionStreet TEXT,
        institutionCity TEXT,
        institutionCountry TEXT,
        institutionPostalCode TEXT,
        institutionWebPage TEXT,
        institutionComment TEXT,
        institutionEmail TEXT,
        iExperimentation TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }
// id: the id of a item
// institutionName, institutionType: name and institutionType of your activity
// created_at: the time that the item was created. It will be automatically handled by SQLite

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'institution.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new item (institution)
  static Future<int> createItem(String institutionName,
      String? institutionType,
      String? institutionStreet,
      String? institutionCity,
      String? institutionCountry,
      String? institutionPostalCode,
      String? institutionWebPage,
      String? iExperimentation,
      String? institutionComment,


) async {
    final db = await SQLInstitution.db();

    final data = {'institutionName': institutionName,
    'institutionType': institutionType,
    'institutionStreet': institutionStreet,
    'institutionCity': institutionCity,
    'institutionCountry': institutionCountry,
    'institutionPostalCode': institutionPostalCode,
    'institutionWebPage': institutionWebPage,
    'iExperimentation': iExperimentation,

    'institutionComment': institutionComment};
    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all items (institutions)
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLInstitution.db();
    return db.query('items', orderBy: "id");
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
    String? institutionType,
    String? institutionStreet,
    String? institutionCity,
    String? institutionCountry,
    String? institutionPostalCode,
    String? institutionWebPage,
    String? iExperimentation,
    String? institutionComment,

) async {
    final db = await SQLInstitution.db();

    final data = {
      'institutionName': institutionName,
      'institutionType': institutionType,
      'institutionStreet': institutionStreet,
      'institutionCity': institutionCity,
      'institutionCountry': institutionCountry,
      'institutionPostalCode': institutionPostalCode,
      'institutionWebPage': institutionWebPage,
      'iExperimentation': iExperimentation,

      'institutionComment': institutionComment,
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