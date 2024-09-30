import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class TaskTranslator {
  final Database database;
  final String designName;

  TaskTranslator(this.database, this.designName);

  // Fetch tasks from the database and convert them to JSON format
  Future<String> fetchTasksAsJson() async {
    // Fetch data from the database
    final List<Map<String, dynamic>> queryResults = await database.query(
      'tasks',
      where: 'designName = ?',
      whereArgs: [designName],
    );

    // Check if queryResults is empty
    if (queryResults.isEmpty) {
      return '{}';  // Return an empty JSON object if no results
    }

    // Collect all components in a list
    final List<Map<String, dynamic>> components = queryResults.map((row) {
      int newIndex = row['newIndex'];

      return {
        'id': row['id'].toString(),
//        'id': row['id'].toString(),
        'position': [0.0, 0.0 + (newIndex * 240.0)],
        'size': [120.0, 72.0],
        'min_size': [80.0, 64.0],
        'type': 'rect',
        'z_order': 0,
        'parent_id': null,
        'children_ids': [],
        'connections': [],
        'dynamic_data': {
          'id': 'unique_id',
          'type': 'rect',
          'color': '#FFB6C1',
          'borderColor': '#000000',
//          'color': 4292886779,
//          'borderColor': 4278190080,
          'borderWidth': 2.0,
          'text': row['taskName'],
          'textAlignment': 'center',
          'textSize': 20.0,
          'isHighlightVisible': false,
        }
      };
    }).toList();  // Convert each row to a component

    // Create a final map with components and links
    final Map<String, dynamic> diagramData = {
      "components": components,  // All components are collected into one list
      "links": []  // Add any links here, if needed
    };

    // Encode the final map to JSON and return it
    return jsonEncode(diagramData);
  }

  // Save the JSON data to a file
  Future<void> saveJsonToFile(String jsonData) async {

    final String designNameJ = designName.replaceAll(' ', '_');

    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final directory = Directory('${appDocDir.path}/$designNameJ');

      if (!(await directory.exists())) {
        await directory.create(recursive: true);
      }

      final String timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      final String fileName = '$designNameJ\_$timestamp.json';
      final String filePath = '${directory.path}/$fileName';

      final file = File(filePath);
      await file.writeAsString(jsonData);

      debugPrint('JSON data successfully saved to $filePath');
    } catch (e) {
      debugPrint('Error saving file: $e');
    }
  }

  // Method to generate and save the JSON data
  Future<String> generateAndSaveJson() async {
    final String jsonData = await fetchTasksAsJson();
    await saveJsonToFile(jsonData);
    return jsonData;
  }
}
