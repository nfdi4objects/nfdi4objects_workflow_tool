import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLInstitution {
  get database => null;
  get institutions => null;

  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE institutions(
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
        iObservation TEXT,
        iMeasurement TEXT,
        iReplication TEXT,
        iReconstruction TEXT,
        iReenactment TEXT,
        iRecipe TEXT,
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
      onCreate: (sql.Database institutionDatabase, int version) async {
        await createTables(institutionDatabase);
      },
    );
  }

  // Create new item (institution)
  static Future<int> createInstitution(String institutionName,
      String? institutionType,
      String? institutionStreet,
      String? institutionCity,
      String? institutionCountry,
      String? institutionPostalCode,
      String? institutionWebPage,
      String? institutionComment,

      String? iExperimentation,
      String? iObservation,
      String? iMeasurement,
      String? iReplication,
      String? iReconstruction,
      String? iReenactment,
      String? iRecipe,

) async {
    final db = await SQLInstitution.db();

    final data = {'institutionName': institutionName,
      'institutionType': institutionType,
      'institutionStreet': institutionStreet,
      'institutionCity': institutionCity,
      'institutionCountry': institutionCountry,
      'institutionPostalCode': institutionPostalCode,
      'institutionWebPage': institutionWebPage,
      'institutionComment': institutionComment,

      'iExperimentation': iExperimentation,
      'iObservation': iObservation,
      'iMeasurement': iMeasurement,
      'iReplication': iReplication,
      'iReconstruction': iReconstruction,
      'iReenactment': iReenactment,
      'iRecipe': iRecipe};
    final id = await db.insert('institutions', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all institutions (institutions)
  static Future<List<Map<String, dynamic>>> getInstitutions() async {
    final db = await SQLInstitution.db();
    return db.query('institutions', orderBy: "institutionName");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getInstitution(int id) async {
    final db = await SQLInstitution.db();
    return db.query('institutions', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateInstitution(int id,
      String institutionName,
      String? institutionType,
      String? institutionStreet,
      String? institutionCity,
      String? institutionCountry,
      String? institutionPostalCode,
      String? institutionWebPage,
      String? institutionComment,

      String? iExperimentation,
      String? iObservation,
      String? iMeasurement,
      String? iReplication,
      String? iReconstruction,
      String? iReenactment,
      String? iRecipe,

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
      'institutionComment': institutionComment,

      'iExperimentation': iExperimentation,
      'iObservation': iObservation,
      'iMeasurement': iMeasurement,
      'iReplication': iReplication,
      'iReconstruction': iReconstruction,
      'iReenactment': iReenactment,
      'iRecipe': iRecipe,
      'createdAt': DateTime.now().toString()
    };

    final result =
    await db.update('institutions', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteInstitution(int id) async {
    final db = await SQLInstitution.db();
    try {
      await db.delete("institutions", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}