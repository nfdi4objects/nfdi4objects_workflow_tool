import 'package:diagram_editor/diagram_editor.dart';
import '/diagram_editor/data/custom_component_data.dart';
import '/diagram_editor/policy/my_policy_set.dart';
import 'package:flutter/material.dart';
import '/sql_instruments_menu.dart';

import 'menu.dart';
import 'package:sqflite/sqflite.dart' as sql;

class InstrumentsMenu extends StatefulWidget {
  final MyPolicySet instrumentPolicySet;

  const InstrumentsMenu({super.key, required this.instrumentPolicySet});

  @override
  _InstrumentsMenuState createState() => _InstrumentsMenuState();
}

class _InstrumentsMenuState extends State<InstrumentsMenu> {
  List<String> instrumentBinomials = [];

  @override
  void initState() {
    super.initState();
    initInstrumentBinomials();
  }

  Future<void> initInstrumentBinomials() async {
    List<Map<String, dynamic>> instruments = await SQLHelperInstrumentMenu.getInstruments();
    List<String> tempInstrumentBinomials = instruments.map<String>((instrument) => instrument['instrumentBinomial'] as String).toList();
    setState(() {
      instrumentBinomials = tempInstrumentBinomials;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ...instrumentBinomials.map(
              (instrumentBinomial) {
            var componentData = getComponentData('bean_right', {'instrumentBinomial': instrumentBinomial});
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
                          child: DraggableInstrument(
                            instrumentPolicySet: widget.instrumentPolicySet,
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
            color: Colors.indigo,
            borderColor: Colors.indigo,
            borderWidth: 0.0,
            text: row['instrumentBinomial'].toString(),
            textAlignment: Alignment.center,
            textSize: 15,
          ),
          type: 'bean_right',
        );
      default:
        return ComponentData(
          size: const Size(120, 72),
          minSize: const Size(80, 64),
          data: MyComponentData(
            color: Colors.white,
            borderColor: Colors.indigo,
            borderWidth: 2.0,
            text: row['instrumentBinomial'].toString(),
            textAlignment: Alignment.center,
            textSize: 15,
          ),
          type: 'bean_right',
        );
    }
  }
}

class DraggableInstrument extends StatelessWidget {
  final MyPolicySet instrumentPolicySet;
  final ComponentData componentData;

  const DraggableInstrument({super.key,
    required this.instrumentPolicySet,
    required this.componentData,
  });

  @override
  Widget build(BuildContext context) {
    return Draggable<ComponentData>(
      affinity: Axis.horizontal,
      ignoringFeedbackSemantics: true,
      data: componentData,
      childWhenDragging: instrumentPolicySet.showComponentBody(componentData),
      feedback: Material(
        color: Colors.transparent,
        child: SizedBox(
          width: componentData.size.width,
          height: componentData.size.height,
          child: instrumentPolicySet.showComponentBody(componentData),
        ),
      ),
      child: instrumentPolicySet.showComponentBody(componentData),
    );
  }
}

class SQLInstrumentMenu {
  Future<List<SQLHelperInstrumentMenu>> getInstruments() async {
    // Open the database connection
    final db = await sql.openDatabase('instruments.db');

    // Query the database to retrieve the instruments
    final results = await db.query('instruments', columns: ['instrumentBinomial']);

    // Create a list of InstrumentComponentData objects from the query results
    List<SQLHelperInstrumentMenu> instruments = results.map((row) {
      MenuComponentData myData = MenuComponentData(
        id: row['id'].toString(),
        position: const Offset(0, 0),
        size: const Size(120.0, 72.0),
        minSize: const Size(80.0, 64.0),
        type: 'bean_right',
        zOrder: 0,
        parentId: '',
        childrenIds: [],
        connections: [],

        id2: 'unique_id',
        type2: 'bean_right',
        color: Colors.white,
        borderColor: Colors.indigo,
        borderWidth: 2,
        text: row['instrumentBinomial'].toString(),
        textAlignment: 'right',
        textSize: 15,
        isHighlightVisible: false,
      );

      return SQLHelperInstrumentMenu(
        menuData: myData,
      );

    }).toList();

    // Close the database connection
    await db.close();

    return instruments;
  }
}
