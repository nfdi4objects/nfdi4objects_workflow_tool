import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelperRecipe {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE recipes(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        recipeName TEXT,
        recipeType TEXT,
        recipeReference TEXT,
        recipeAim TEXT,
        recipeSerialNumber TEXT,
        recipeActivityArea TEXT,
        recipePurpose TEXT,
        recipeWebPage TEXT,
        recipeComment TEXT,
        recipeCompleted TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }
// id: the id of a item
// recipeName, recipeType: name and recipeType of your activity
// created_at: the time that the item was created. It will be automatically handled by SQLite

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'recipes.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new item (recipe)
  static Future<int> createRecipe(String recipeName,
      String? recipeType,
      String? recipeReference,
      String? recipeAim,
      String? recipeSerialNumber,
      String? recipeActivityArea,
      String? recipePurpose,
      String? recipeWebPage,
      String? recipeComment,
      String recipeCompleted) async {
    final db = await SQLHelperRecipe.db();

    final data = {'recipeName': recipeName,
      'recipeType': recipeType,
      'recipeReference': recipeReference,
      'recipeAim': recipeAim,
      'recipeSerialNumber': recipeSerialNumber,
      'recipeActivityArea': recipeActivityArea,
      'recipePurpose': recipePurpose,
      'recipeWebPage': recipeWebPage,
      'recipeComment': recipeComment,
      'recipeCompleted': "false"};
    final id = await db.insert('recipes', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all recipes (recipes)
  static Future<List<Map<String, dynamic>>> getRecipes() async {
    final db = await SQLHelperRecipe.db();
    return db.query('recipes', orderBy: "recipeName");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getRecipe(int id) async {
    final db = await SQLHelperRecipe.db();
    return db.query('recipes', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateRecipe(
      int id, String recipeName,
      String? recipeType,
      String? recipeReference,
      String? recipeAim,
      String? recipeSerialNumber,
      String? recipeActivityArea,
      String? recipePurpose,
      String? recipeWebPage,
      String? recipeComment,
      String recipeCompleted) async {
    final db = await SQLHelperRecipe.db();

    final data = {
      'recipeName': recipeName,
      'recipeType': recipeType,
      'recipeReference': recipeReference,
      'recipeAim': recipeAim,
      'recipeSerialNumber': recipeSerialNumber,
      'recipeActivityArea': recipeActivityArea,
      'recipePurpose': recipePurpose,
      'recipeWebPage': recipeWebPage,
      'recipeComment': recipeComment,
      'recipeCompleted': recipeCompleted,
      'createdAt': DateTime.now().toString()
    };

    final result =
    await db.update('recipes', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteRecipe(int id) async {
    final db = await SQLHelperRecipe.db();
    try {
      await db.delete("recipes", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}