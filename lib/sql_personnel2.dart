import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLPerson {
  get database => null;
  get persons => null;

  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE persons(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        personName TEXT,
        personPosition TEXT,
        personExperience TEXT,
        personEmail TEXT,
        personFunction TEXT,
        personActivityArea TEXT, 
        personComment TEXT,
            
        pExperimentation TEXT,
        pObservation TEXT,
        pMeasurement TEXT,
        pReplication TEXT,
        pReconstruction TEXT,
        pReenactment TEXT,
        pRecipe TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }
// id: the id of a item
// personName, personPosition: name and personPosition of your activity
// created_at: the time that the item was created. It will be automatically handled by SQLite

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'SQLPersonnn.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new item (person)
  static Future<int> createItem(String personName, String? personPosition, String? personExperience, String? personEmail, String? personFunction, String? personActivityArea, String? personComment,

      String? pExperimentation,
      String? pObservation,
      String? pMeasurement,
      String? pReplication,
      String? pReconstruction,
      String? pReenactment,
      String? pRecipe,
      
      ) async {
    final db = await SQLPerson.db();

    final data = {'personName': personName, 'personPosition': personPosition, 'personExperience': personExperience, 'personEmail': personEmail, 'personFunction': personFunction, 'personActivityArea': personActivityArea, 'personComment': personComment,

      'pExperimentation': pExperimentation,
      'pObservation': pObservation,
      'pMeasurement': pMeasurement,
      'pReplication': pReplication,
      'pReconstruction': pReconstruction,
      'pReenactment': pReenactment,
      'pRecipe': pRecipe};
    final id = await db.insert('persons', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all persons (persons)
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLPerson.db();
    return db.query('persons', orderBy: "id");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLPerson.db();
    return db.query('persons', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateItem(
      int id, String personName, String? personPosition, String? personExperience, String? personEmail, String? personFunction, String? personActivityArea, String? personComment,

      String? pExperimentation,
      String? pObservation,
      String? pMeasurement,
      String? pReplication,
      String? pReconstruction,
      String? pReenactment,
      String? pRecipe,
      
      ) async {
    final db = await SQLPerson.db();

    final data = {
      'personName': personName,
      'personPosition': personPosition,
      'personExperience': personExperience,
      'personEmail': personEmail,
      'personFunction': personFunction,
      'personActivityArea': personActivityArea,
      'personComment': personComment,
      
      'pExperimentation': pExperimentation,
      'pObservation': pObservation,
      'pMeasurement': pMeasurement,
      'pReplication': pReplication,
      'pReconstruction': pReconstruction,
      'pReenactment': pReenactment,
      'pRecipe': pRecipe,
      
      'createdAt': DateTime.now().toString()
    };

    final result =
    await db.update('persons', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteItem(int id) async {
    final db = await SQLPerson.db();
    try {
      await db.delete("persons", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}