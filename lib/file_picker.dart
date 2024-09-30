import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '/diagram_editor/model/diagram_data.dart';
import '/diagram_editor/data/custom_component_data.dart';
import '/diagram_editor/data/custom_link_data.dart';

class DiagramLoader extends StatefulWidget {
  const DiagramLoader({super.key});

  @override
  _DiagramLoaderState createState() => _DiagramLoaderState();
}

class _DiagramLoaderState extends State<DiagramLoader> {
  String? _fileName;
  Map<String, dynamic>? _diagramData;

  Future<void> _pickFileAndLoadDiagram() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      String fileContent = await file.readAsString();
      setState(() {
        _fileName = result.files.single.name;
        _diagramData = jsonDecode(fileContent);
        _deserializeDiagram(_diagramData!);
      });
    } else {
      // User canceled the picker
    }
  }

  void _deserializeDiagram(Map<String, dynamic> json) {
    DiagramData.fromJson(
      json,
      decodeCustomComponentData: (componentJson) {
        return MyComponentData.fromJson(componentJson);
      },
      decodeCustomLinkData: (linkJson) {
        return MyLinkData.fromJson(linkJson);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Load Diagram'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _pickFileAndLoadDiagram,
              child: const Text('Pick JSON File'),
            ),
            if (_fileName != null) ...[
              const SizedBox(height: 20),
              Text('Selected file: $_fileName'),
            ],
          ],
        ),
      ),
    );
  }
}
