import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelperTasks {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        oldIndex INTEGER,
        newIndex INTEGER,
        designName TEXT,
        taskName TEXT,
        taskType TEXT,
        taskActivityArea TEXT,
        taskFunction TEXT,
        taskComment TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

// id: the id of a item
// taskName, taskType: name and taskType of your activity
// created_at: the time that the item was created. It will be automatically handled by SQLite

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'tasks3.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Read all tasks (tasks)
  static Future<List<Map<String, dynamic>>> getTasks(String designName) async {
    final db = await SQLHelperTasks.db();
    return db.query('tasks', where: 'designName = "$designName"', orderBy: 'newIndex');
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getTask(int id) async {
    final db = await SQLHelperTasks.db();
    return db.query('tasks', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Create new item (task)
  static Future<int> createTask(
      int? oldIndex,
      int? newIndex,
      String designName,
      String taskName,
      String? taskType,
      String? taskActivityArea,
      String? taskFunction,
      String? taskComment) async {
    final db = await SQLHelperTasks.db();

    final data = {'designName': designName,
      'taskName': taskName,
      'taskType': taskType,
      'taskActivityArea': taskActivityArea,
      'taskFunction': taskFunction,
      'taskComment': taskComment};
    final id = await db.insert('tasks', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Update an item by id
  static Future<int> updateTask(
      int id,
      int? oldIndex,
      int? newIndex,
      String designName,
      String taskName,
      String? taskType,
      String? taskActivityArea,
      String? taskFunction,
      String? taskComment) async {
    final db = await SQLHelperTasks.db();

    final data = {
      'oldIndex': oldIndex,
      'newIndex': newIndex,
      'designName': designName,
      'taskName': taskName,
      'taskType': taskType,
      'taskActivityArea': taskActivityArea,
      'taskFunction': taskFunction,
      'taskComment': taskComment,
      'createdAt': DateTime.now().toString()
    };

    final result =
    await db.update('tasks', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Update the oldIndex and newIndex columns when the user reorders the items
  static Future<void> reorderTasks(int oldIndex, int newIndex) async {
    final db = await SQLHelperTasks.db();
    // Update the newIndex column for the item that was moved
    await db.update('items', {'newIndex': newIndex}, where: "id = ?", whereArgs: [newIndex]);
    // Update the oldIndex column for the item that was moved
    await db.update('items', {'oldIndex': oldIndex}, where: "id = ?", whereArgs: [oldIndex]);
  }
  
  // Delete
  static Future<void> deleteTask(int id) async {
    final db = await SQLHelperTasks.db();
    try {
      await db.delete("tasks", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}