import 'package:diagram_editor/diagram_editor.dart';
import '/diagram_editor/data/custom_component_data.dart';
import '/diagram_editor/policy/my_policy_set.dart';
import 'package:flutter/material.dart';
import '/sql_tools_menu.dart';

import 'menu.dart';
import 'package:sqflite/sqflite.dart' as sql;

class ToolsMenu extends StatefulWidget {
  final MyPolicySet toolPolicySet;

  const ToolsMenu({super.key, required this.toolPolicySet});

  @override
  _ToolsMenuState createState() => _ToolsMenuState();
}

class _ToolsMenuState extends State<ToolsMenu> {
  List<String> toolBinomials = [];

  @override
  void initState() {
    super.initState();
    initToolBinomials();
  }

  Future<void> initToolBinomials() async {
    List<Map<String, dynamic>> tools = await SQLHelperToolMenu.getTools();
    List<String> tempToolBinomials = tools.map<String>((tool) => tool['toolBinomial'] as String).toList();
    setState(() {
      toolBinomials = tempToolBinomials;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ...toolBinomials.map(
              (toolBinomial) {
            var componentData = getComponentData('bean_left', {'toolBinomial': toolBinomial});
            return Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                    width: constraints.maxWidth < componentData.size.width
                        ? componentData.size.width * (constraints.maxWidth / componentData.size.width)
                        : componentData.size.width,
                    height: constraints.maxWidth < componentData.size.width
                        ? componentData.size.height * (constraints.maxWidth / componentData.size.width)
                        : componentData.size.height,
                    child: Align(
                      alignment: Alignment.center,
                      child: AspectRatio(
                        aspectRatio: componentData.size.aspectRatio,
                        child: Tooltip(
                          message: componentData.type,
                          child: DraggableTool(
                            toolPolicySet: widget.toolPolicySet,
                            componentData: componentData,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  ComponentData getComponentData(String componentType, Map<String, dynamic> row) {
    switch (componentType) {
      case 'junction':
        return ComponentData(
          size: const Size(16, 16),
          minSize: const Size(4, 4),
          data: MyComponentData(
            color: Colors.blue,
            borderColor: Colors.blue,
            borderWidth: 0.0,
            text: row['toolBinomial'].toString(),
            textAlignment: Alignment.center,
            textSize: 15,
          ),
          type: 'bean_left',
        );
      default:
        return ComponentData(
          size: const Size(120, 72),
          minSize: const Size(80, 64),
          data: MyComponentData(
            color: Colors.white,
            borderColor: Colors.blue,
            borderWidth: 2.0,
            text: row['toolBinomial'].toString(),
            textAlignment: Alignment.center,
            textSize: 15,
          ),
          type: 'bean_left',
        );
    }
  }
}

class DraggableTool extends StatelessWidget {
  final MyPolicySet toolPolicySet;
  final ComponentData componentData;

  const DraggableTool({super.key,
    required this.toolPolicySet,
    required this.componentData,
  });

  @override
  Widget build(BuildContext context) {
    return Draggable<ComponentData>(
      affinity: Axis.horizontal,
      ignoringFeedbackSemantics: true,
      data: componentData,
      childWhenDragging: toolPolicySet.showComponentBody(componentData),
      feedback: Material(
        color: Colors.transparent,
        child: SizedBox(
          width: componentData.size.width,
          height: componentData.size.height,
          child: toolPolicySet.showComponentBody(componentData),
        ),
      ),
      child: toolPolicySet.showComponentBody(componentData),
    );
  }
}

class SQLToolMenu {
  Future<List<SQLHelperToolMenu>> getTools() async {
    // Open the database connection
    final db = await sql.openDatabase('tools.db');

    // Query the database to retrieve the tools
    final results = await db.query('tools', columns: ['toolBinomial']);

    // Create a list of ToolComponentData objects from the query results
    List<SQLHelperToolMenu> tools = results.map((row) {
      MenuComponentData myData = MenuComponentData(
        id: row['id'].toString(),
        position: const Offset(0, 0),
        size: const Size(120.0, 72.0),
        minSize: const Size(80.0, 64.0),
        type: 'bean_left',
        zOrder: 0,
        parentId: '',
        childrenIds: [],
        connections: [],

        id2: 'unique_id',
        type2: 'bean_left',
        color: Colors.white,
        borderColor: Colors.blue,
        borderWidth: 2,
        text: row['toolBinomial'].toString(),
        textAlignment: 'right',
        textSize: 15,
        isHighlightVisible: false,
      );

      return SQLHelperToolMenu(
        menuData: myData,
      );

    }).toList();

    // Close the database connection
    await db.close();

    return tools;
  }
}
