import 'package:diagram_editor/diagram_editor.dart';
import '/diagram_editor/policy/minimap_policy.dart';
import '/diagram_editor/policy/my_policy_set.dart';
import '/diagram_editor/policy/custom_policy.dart';
import '/diagram_editor/data/custom_component_data.dart';

//import 'package:flutter/foundation.dart';

import 'package:diagram_editor/src/abstraction_layer/rw/canvas_writer.dart';
import 'package:diagram_editor/src/abstraction_layer/rw/state_writer.dart';
import 'package:diagram_editor/src/abstraction_layer/rw/model_writer.dart';
import 'package:diagram_editor/src/canvas_context/canvas_model.dart';
import 'package:diagram_editor/src/canvas_context/canvas_state.dart';

import '/diagram_editor/widget/option_icon.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:io';
import 'dart:convert';

import 'menuinstruments.dart';
import 'menutools.dart';
import '/tasks.dart';

import 'dart:math' as math;

import 'menu.dart';


void main() => runApp(const FlowChartEditor(designName: 'Design Name', jsonData: '', designNameJ: 'DesignNameJ', designColor: Colors.amber, button1color: Colors.amber, button2color: Colors.amber,));

class FlowChartEditor extends StatefulWidget {
  final String designName;
  final Color designColor;
  final Color button1color;
  final Color button2color;

  final String designNameJ;
  final String jsonData;

  const FlowChartEditor({
    super.key,
    required this.designName,
    required this.designColor,
    required this.button1color,
    required this.button2color,

    required this.jsonData,
    required this.designNameJ,
  });

  @override
  FlowChartEditorState createState() => FlowChartEditorState(designName, designNameJ, jsonData);

}

class DiagramPolicySet extends PolicySet {
  @override
  late CanvasWriter canvasWriter;

  DiagramPolicySet(CanvasModelWriter model, CanvasStateWriter state) {
    canvasWriter = CanvasWriter(model, state);  // Initialize canvasWriter with model and state
  }
}

class FlowChartEditorState extends State<FlowChartEditor> {

  late CanvasModel canvasModel;
  late CanvasModelWriter canvasModelWriter;
  late CanvasStateWriter canvasStateWriter;
  late CanvasState canvasState;

  late DiagramData _diagramData;
  late DiagramEditorContext diagramEditorContext;
  late DiagramEditorContext diagramEditorContextMiniMap;
  late DiagramModel diagramModel;

  final String designName;
  final String designNameJ;
  final String jsonData;

  late MyPolicySet myPolicySet;
  late DiagramPolicySet diagramPolicySet;
//  MyPolicySet myPolicySet = MyPolicySet();
  MiniMapPolicySet miniMapPolicySet = MiniMapPolicySet();

//  bool isMenuVisible = true;

  bool isMiniMapVisible = true;
  bool isIMenuVisible = false;
  bool isTMenuVisible = false;
  bool isOptionsVisible = true;

  bool _isDataLoaded = false;

  FlowChartEditorState(this.designName, this.designNameJ, this.jsonData);

  @override
  void initState() {
    super.initState();

    _initializeDiagramFromMostRecentFile();

    myPolicySet = MyPolicySet();

    canvasModel = CanvasModel(PolicySet());
    canvasState = CanvasState();

    // Initialize canvasModelWriter and canvasStateWriter
    canvasModelWriter = CanvasModelWriter(canvasModel, canvasState);
    canvasStateWriter = CanvasStateWriter(canvasState);

    diagramEditorContext = DiagramEditorContext(
      policySet: myPolicySet,
    );
    debugPrint('Diagram editor context: ${diagramEditorContext.policySet}');
    diagramEditorContextMiniMap =
        DiagramEditorContext.withSharedModel(diagramEditorContext, policySet: miniMapPolicySet);

    _diagramData = DiagramData(components: [], links: []);

  }

  Future<void> _initializeDiagramFromMostRecentFile() async {
    if (_isDataLoaded) {
      debugPrint('Diagram is already loaded. Skipping reinitialization.');
      return;
    }

    String? filePath = await getMostRecentFile();

    if (filePath != null) {
      try {
        DiagramData diagramData = await loadDiagramDataFromFile(filePath);

        // Log the deserialization process
        debugPrint('Starting deserialization...');

        setState(() {
          _diagramData = diagramData;
          _isDataLoaded = true;

          // Initialize canvasModel and canvasState
          canvasModel = MyCanvasModel();
          canvasState = CanvasState();

          // Initialize canvasModelWriter and canvasStateWriter
          canvasModelWriter = CanvasModelWriter(canvasModel, canvasState);
          canvasStateWriter = CanvasStateWriter(canvasState);

          // Initialize diagramPolicySet
          diagramPolicySet = DiagramPolicySet(canvasModelWriter, canvasStateWriter);

          // Deserialize the diagram data into the canvas
          deserializeDiagram(diagramData);
        });

        debugPrint('Deserialization finished. Canvas updated.');

      } catch (e) {
        debugPrint('Error during diagram initialization: $e');
      }
    } else {
      debugPrint('No valid file path found.');
    }
  }

  Future<String?> getMostRecentFile() async {
    final String designNameJ = designName.replaceAll(' ', '_');
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final directory = Directory('${appDocDir.path}/$designNameJ');

      if (!await directory.exists()) {
        debugPrint('Directory does not exist');
        return null;
      }

      List<FileSystemEntity> files = directory.listSync()
          .where((file) => file.path.endsWith('.json'))
          .toList()
        ..sort((a, b) => File(b.path).lastModifiedSync().compareTo(File(a.path).lastModifiedSync()));

      return files.isNotEmpty ? files.first.path : null;
    } catch (e) {
      debugPrint('Error finding the most recent file: $e');
      return null;
    }
  }

  void _setUpCanvas(DiagramData diagramData) {
    setState(() {
      _diagramData = diagramData;
      _isDataLoaded = true;

      // Initialize canvas model and state
      canvasModel = MyCanvasModel();
      canvasState = CanvasState();
      canvasModelWriter = CanvasModelWriter(canvasModel, canvasState);
      canvasStateWriter = CanvasStateWriter(canvasState);
      diagramPolicySet = DiagramPolicySet(canvasModelWriter, canvasStateWriter);

      // Deserialize diagram components and links
      deserializeDiagram(diagramData);
    });
  }

  void deserializeDiagram(DiagramData diagramData) {
    diagramPolicySet.canvasWriter.model.removeAllComponents();

    for (var component in diagramData.components) {
      ComponentData newComponentData = ComponentData.fromJson({
        'id': component.id,
        'position': [component.position.dx, component.position.dy],
        'size': [component.size.width, component.size.height],
        'min_size': [component.minSize.width, component.minSize.height],
        'type': component.type,
        'z_order': component.zOrder,
        'parent_id': component.parentId?.isEmpty ?? true ? null : component.parentId,
        'children_ids': component.childrenIds,
        'connections': component.connections.map((connection) => connection.toJson()).toList(),

//        'data': {
//
//          'color': Color(component.dynamicData['color']), // Access dynamic_data property correctly
//
//          'borderColor': Color(component.dynamicData['borderColor']), // Access dynamic_data property correctly
//
//          'borderWidth': component.dynamicData['borderWidth'],
//
//          'text': component.dynamicData['text'],
//
//          'textAlignment': component.dynamicData['textAlignment'],
//
//          'textSize': component.dynamicData['textSize'],
//
//          'isHighlightVisible': component.dynamicData['isHighlightVisible'],
//
//        },


      });
      diagramPolicySet.canvasWriter.model.addComponent(newComponentData);
//      diagramEditorContextMiniMap = DiagramEditorContext.withSharedModel(diagramEditorContext, policySet: miniMapPolicySet);
      diagramEditorContextMiniMap.policySet.canvasWriter.model.addComponent(newComponentData);
//      diagramPolicySet.canvasWriter.model.updateCanvas();
    }

    for (var link in diagramData.links) {
      myPolicySet.canvasWriter.model.connectTwoComponents(
        data: link,
        sourceComponentId: link.sourceId,
        targetComponentId: link.targetId,
      );
      diagramModel.connectTwoComponents(link); // Update the diagramModel
    }

    setState(() {
      // Ensure canvas updates
//      debugPrint('Total components added to canvas: ${diagramPolicySet.canvasWriter.model.getComponents().length}');
      debugPrint('Redrawing canvas...');
    });
  }

// void deserializeDiagram(DiagramData diagramData) {
//   canvasWriter.model.removeAllComponents();

//   // Deserialize each component
//   for (var component in diagramData.components) {
//     debugPrint('Adding component: ${component.id} at position: ${component.position}');

//     // Add the component to the canvas
//     canvasWriter.model.addComponent(component);

//     // Debug print the component data
//     debugPrint('Component data: ${component.data}');
//   }

//   canvasWriter.model.updateCanvas();
// }




  Future<DiagramData> loadDiagramDataFromFile(String filePath) async {
    try {
      final jsonData = await File(filePath).readAsString();

      if (jsonData.isNotEmpty) {
        final Map<String, dynamic> decodedJson = jsonDecode(jsonData);
        debugPrint('Decoded JSON: $decodedJson');
        return DiagramData.fromJson(decodedJson);
      }
    } catch (e) {
      debugPrint('Error deserializing JSON: $e');
    }
    throw Exception('Failed to load diagram data or invalid JSON');
  }

// Helper method to read JSON from a file
  Future<String> readJsonFromFile(String filePath) async {
    try {
      final file = File(filePath);
      return await file.readAsString();
    } catch (e) {
      debugPrint('Error reading JSON from file: $e');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final designName = widget.designName;
    return MaterialApp(
      // showPerformanceOverlay: !kIsWeb,
      showPerformanceOverlay: false,
      home: Scaffold(

        appBar: AppBar(
          title: Text('${widget.designName} Workflow'),
          leading: const Icon(Icons.schema_outlined),
          backgroundColor: widget.designColor,
          elevation: 5,
        ),

        body: SafeArea(
          child: Stack(
            children: [
              Container(color: Colors.grey),
              Positioned(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: DiagramEditor(
//                    diagramEditorContext: diagramEditorContext,
                    diagramEditorContext: DiagramEditorContext(policySet: myPolicySet),
                  ),
                ),
              ),

              Positioned(
                right: 16,
                top: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: isMiniMapVisible,
                      child: Column(
                        children: [
                          Material(
                            elevation: 5,
                            child: SizedBox(
                              width: 320,
                              height: 240,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                ),
                                child: DiagramEditor(
                                  diagramEditorContext: diagramEditorContextMiniMap,
                                ),
                              ),
                            ),
                          ),
                          Material(
                            elevation: 5,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isMiniMapVisible = !isMiniMapVisible;
                                });
                              },
                              child: Container(
                                color: Colors.yellow[300],
                                child: const Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Text('Hide MiniMAP'),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: !isMiniMapVisible,
                      child: Material(
                        elevation: 5,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isMiniMapVisible = !isMiniMapVisible;
                            });
                          },
                          child: Container(
                            color: Colors.yellow[300],
                            child: const Padding(
                              padding: EdgeInsets.all(4),
                              child: Text('Show MiniMAP'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      OptionIcon(
                        color: Colors.grey.withOpacity(0.7),
                        iconData: isOptionsVisible ? Icons.menu_open : Icons.menu,
                        shape: BoxShape.rectangle,
                        onPressed: () {
                          setState(() {
                            isOptionsVisible = !isOptionsVisible;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      Visibility(
                        visible: isOptionsVisible,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            OptionIcon(
                              tooltip: 'reset view',
                              color: Colors.deepOrange.withOpacity(0.7),
                              iconData: Icons.replay,
                              onPressed: () => myPolicySet.resetView(),
                            ),
                            const SizedBox(width: 8),
                            OptionIcon(
                              tooltip: 'delete all',
                              color: Colors.orange.withOpacity(0.7),
                              iconData: Icons.delete_forever,
                              onPressed: () => myPolicySet.removeAll(),
                            ),
                            const SizedBox(width: 8),
                            OptionIcon(
                              tooltip: 'delete all',
                              color: Colors.orangeAccent.withOpacity(0.7),
                              iconData: Icons.save,
                              onPressed: () => myPolicySet.serialize(),
                            ),
                            const SizedBox(width: 8),
                            OptionIcon(
                              tooltip: myPolicySet.isGridVisible ? 'hide grid' : 'show grid',
                              color: Colors.amber.withOpacity(0.7),
                              iconData: myPolicySet.isGridVisible ? Icons.grid_off : Icons.grid_on,
                              onPressed: () {
                                setState(() {
                                  myPolicySet.isGridVisible = !myPolicySet.isGridVisible;
                                });
                              },
                            ),
                            const SizedBox(width: 8),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Visibility(
                                  visible: myPolicySet.isMultipleSelectionOn,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      OptionIcon(
                                        tooltip: 'select all',
                                        color: Colors.yellowAccent.withOpacity(0.7),
                                        iconData: Icons.all_inclusive,
                                        onPressed: () => myPolicySet.selectAll(),
                                      ),
                                      const SizedBox(height: 8),
                                      OptionIcon(
                                        tooltip: 'duplicate selected',
                                        color: Colors.grey.withOpacity(0.7),
                                        iconData: Icons.copy,
                                        onPressed: () => myPolicySet.duplicateSelected(),
                                      ),
                                      const SizedBox(height: 8),
                                      OptionIcon(
                                        tooltip: 'remove selected',
                                        color: Colors.grey.withOpacity(0.7),
                                        iconData: Icons.delete,
                                        onPressed: () => myPolicySet.removeSelected(),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                OptionIcon(
                                  tooltip: myPolicySet.isMultipleSelectionOn
                                      ? 'cancel multiselection'
                                      : 'enable multiselection',
                                  color: Colors.grey.withOpacity(0.7),
                                  iconData:
                                  myPolicySet.isMultipleSelectionOn ? Icons.group_work : Icons.group_work_outlined,
                                  onPressed: () {
                                    setState(() {
                                      if (myPolicySet.isMultipleSelectionOn) {
                                        myPolicySet.turnOffMultipleSelection();
                                      } else {
                                        myPolicySet.turnOnMultipleSelection();
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),


//              Positioned(
//                top: 0,
//                left: 0,
//                bottom: 0,
//                child: Row(
//                  children: [
//                    Visibility(
//                      visible: isMenuVisible,
//                      child: Container(
//                        color: Colors.grey.withOpacity(0.7),
//                        width: 120,
//                        height: 320,
//                        child: DraggableMenu(myPolicySet: myPolicySet),
//                      ),
//                    ),
//                    RotatedBox(
//                      quarterTurns: 1,
//                      child: GestureDetector(
//                        onTap: () {
//                          setState(() {
//                            isMenuVisible = !isMenuVisible;
//                          });
//                        },
//                        child: Container(
//                          color: Colors.grey[300],
//                          child: Padding(
//                            padding: const EdgeInsets.all(4),
//                            child: Text(isMenuVisible ? 'hide menu' : 'show menu'),
//                          ),
//                        ),
//                      ),
//                    ),
//                  ],
//                ),
//              ),


              Positioned(
                top: 0,
                left: 0,
                bottom: 0,
                child: StatefulBuilder(
                  builder: (context, setStateLocal) {
                    return Row(
                      children: [
                        isTMenuVisible
                            ? Container(
                          color: Colors.lightBlueAccent.withOpacity(0.4),
                          width: 120,
                          height: 320,
                          child: ToolsMenu(toolPolicySet: myPolicySet),
                        )
                            : const SizedBox.shrink(),
                        RotatedBox(
                          quarterTurns: 1,
                          child: Material(
                            elevation: 5,
                            child: GestureDetector(
                              onTap: () {
                                setStateLocal(() {
                                  isTMenuVisible = !isTMenuVisible;
                                });
                              },
                              child: Container(
                                color: Colors.lightBlueAccent[200],
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Text(isTMenuVisible ? 'hide menu' : 'TOOLS'),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              Positioned(
                top: 0,
                right: 0,
                bottom: 0,
                child: StatefulBuilder(
                  builder: (context, setStateLocal) {
                    return Row(
                      children: [
                        RotatedBox(
                          quarterTurns: 3,
                          child: Material(
                            elevation: 5,
                            child: GestureDetector(
                              onTap: () {
                                setStateLocal(() {
                                  isIMenuVisible = !isIMenuVisible;
                                });
                              },
                              child: Container(
                                color: Colors.indigo[200],
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Text(isIMenuVisible ? 'hide menu' : 'INSTRUMENTS'),
                                ),
                              ),
                            ),
                          ),
                        ),
                        isIMenuVisible
                            ? Container(
                          color: Colors.indigo.withOpacity(0.4),
                          width: 120,
                          height: 300,
                          child: InstrumentsMenu(instrumentPolicySet: myPolicySet),
                        )
                            : const SizedBox.shrink(),
                      ],
                    );
                  },
                ),
              )

            ],
          ),
        ),

        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: widget.designColor,
          elevation: 5,
          onPressed: () {
            Navigator.pop(context);

            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TasksPage(designName: designName, designColor: widget.designColor, button1color: widget.button1color, button2color: widget.button2color, tasks: const [],
                ),
                )
            );
          },

          label: const Text('BACK'),
          icon: const Icon(Icons.arrow_back),
        ),

      ),

    );
  }
}

class DiagramData {
  final List<ComponentData> components;
  final List<LinkData> links;

  DiagramData({required this.components, required this.links});

  factory DiagramData.fromJson(Map<String, dynamic> json) {
    return DiagramData(
      components: (json['components'] as List<dynamic>)
          .map((component) => ComponentData.fromJson(component as Map<String, dynamic>))
          .toList(),
      links: (json['links'] as List<dynamic>)
          .map((link) => LinkData.fromJson(link as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'components': components.map((component) => component.toJson()).toList(),
      'links': links.map((link) => link.toJson()).toList(),
    };
  }

  DiagramModel toDiagramModel() {
    DiagramModel model = DiagramModel();
    for (var component in components) {
      model.addComponent(component);
    }
    for (var link in links) {
      model.connectTwoComponents(link);
    }
    return model;
  }
}

class DiagramModel {
  List<ComponentData> _components = [];
  List<LinkData> _links = [];
  // Add components to the diagram
  void addComponent(ComponentData component) {
    _components.add(component);
    debugPrint('Component added: ${component.id}');
  }
  // Add links between components
  void connectTwoComponents(LinkData link) {
    _links.add(link);
  }
  // Getters for components and links
  List<ComponentData> get components => _components;
  List<LinkData> get links => _links;
}

class DynamicData {
  final String id;
  final String type;
  final int color;
  final int borderColor;
  final double borderWidth;
  final String text;
  final String textAlignment;
  final double textSize;
  final bool isHighlightVisible;

  DynamicData({
    required this.id,
    required this.type,
    required this.color,
    required this.borderColor,
    required this.borderWidth,
    required this.text,
    required this.textAlignment,
    required this.textSize,
    required this.isHighlightVisible,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'color': color,
      'borderColor': borderColor,
      'borderWidth': borderWidth,
      'text': text,
      'textAlignment': textAlignment,
      'textSize': textSize,
      'isHighlightVisible': isHighlightVisible,
    };
  }

  factory DynamicData.fromJson(Map<String, dynamic> json) {
    return DynamicData(
      id: json['id'] as String,
      type: json['type'] as String,
      color: json['color'] as int,
      borderColor: json['borderColor'] as int,
      borderWidth: json['borderWidth'] as double,
      text: json['text'] as String,
      textAlignment: json['textAlignment'] as String,
      textSize: json['textSize'] as double,
      isHighlightVisible: json['isHighlightVisible'] as bool,
    );
  }
}

class LinkData {
  final String id;
  final String sourceId;
  final String targetId;

  LinkData({
    required this.id,
    required this.sourceId,
    required this.targetId,
  });

  factory LinkData.fromJson(Map<String, dynamic> json) {
    return LinkData(
      id: json['id'] as String,
      sourceId: json['source_id'] as String,
      targetId: json['target_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'source_id': sourceId,
      'target_id': targetId,
    };
  }
}

class MyCanvasModel extends CanvasModel {
  MyCanvasModel() : super(PolicySet());

  @override
  String addComponent(ComponentData componentData) {
    components[componentData.id] = componentData;
    notifyListeners();  // This ensures the canvas is updated
    return componentData.id;
  }

  @override
  String connectTwoComponents(String sourceComponentId, String targetComponentId, LinkStyle? linkStyle, dynamic data) {
    // Logic to connect two components...

    notifyListeners();
    return sourceComponentId;
  }
}

// Custom component Data which you can assign to a component to dynamic data property.
//class MyComponentData {
//  MyComponentData();
//
//  bool isHighlightVisible = false;
//  Color color = Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
//
//  showHighlight() {
//    isHighlightVisible = true;
//  }
//
//  hideHighlight() {
//    isHighlightVisible = false;
//  }
//
//  // Function used to deserialize the diagram. Must be passed to `canvasWriter.model.deserializeDiagram` for proper deserialization.
//  MyComponentData.fromJson(Map<String, dynamic> json)
//      : isHighlightVisible = json['highlight'],
//        color = Color(int.parse(json['color'], radix: 16));
//
//  // Function used to serialization of the diagram. E.g. to save to a file.
//  Map<String, dynamic> toJson() => {
//    'highlight': isHighlightVisible,
//    'color': color.toString().split('(0x')[1].split(')')[0],
//  };
//}


//class MyComponentData {
//  final Color color;
//  final Color borderColor;
//  final double borderWidth;
//  final String text;
//  final TextAlign textAlignment;
//  final double textSize;
//  final bool isHighlightVisible;
//
//  MyComponentData({
//    required this.color,
//    required this.borderColor,
//    required this.borderWidth,
//    required this.text,
//    required this.textAlignment,
//    required this.textSize,
//    required this.isHighlightVisible,
//  });
//
//  factory MyComponentData.fromJson(Map<String, dynamic> json) {
//    return MyComponentData(
//      color: Color(json['color']),  // Ensure color is parsed correctly
//      borderColor: Color(json['borderColor']),
//      borderWidth: (json['borderWidth'] as num).toDouble(),
//      text: json['text'] ?? '',
//      textAlignment: parseTextAlign(json['textAlignment']),  // Custom parser for TextAlign
//      textSize: (json['textSize'] as num).toDouble(),
//      isHighlightVisible: json['isHighlightVisible'] ?? false,
//    );
//  }
//}

TextAlign parseTextAlign(String? alignment) {
  switch (alignment) {
    case 'center':
      return TextAlign.center;
    case 'left':
      return TextAlign.left;
    case 'right':
      return TextAlign.right;
    default:
      return TextAlign.center;
  }
}





// A place where you can init the canvas or your diagram (eg. load an existing diagram).
//mixin MyInitPolicy implements InitPolicy {
//  @override
//  initializeDiagramEditor() {
//    canvasWriter.state.setCanvasColor(Colors.grey[300]!);
//  }
//}

// This is the place where you can design a component.
// Use switch on componentData.type or componentData.data to define different component designs.
mixin MyComponentDesignPolicy implements ComponentDesignPolicy {
  @override

  Widget showComponentBody(ComponentData componentData) {
    return Container(
      width: componentData.size.width,
      height: componentData.size.height,
      decoration: BoxDecoration(
        color: (componentData.data as MyComponentData).color,
        border: Border.all(
          color: Color((componentData.data as DynamicData).borderColor),
          width: (componentData.data as DynamicData).borderWidth,
        ),
      ),
      child: Center(
        child: Text(
          (componentData.data as DynamicData).text,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: (componentData.data as DynamicData).textSize),
        ),
      ),
    );
  }

}

// You can override the behavior of any gesture on canvas here.
// Note that it also implements CustomPolicy where own variables and functions can be defined and used here.
//mixin MyCanvasPolicy implements CanvasPolicy, CustomPolicy {
//  @override
//  onCanvasTapUp(TapUpDetails details) {
//    canvasWriter.model.hideAllLinkJoints();
//    if (selectedComponentId != null) {
//      hideComponentHighlight(selectedComponentId);
//    } else {
//      canvasWriter.model.addComponent(
//        ComponentData(
//          size: const Size(96, 72),
//          position: canvasReader.state.fromCanvasCoordinates(details.localPosition),
//          data: MyComponentData(),
//        ),
//      );
//    }
//  }
//}

mixin MyCanvasPolicy implements CanvasPolicy, CustomPolicy {
  @override
  onCanvasTapUp(TapUpDetails details) {
    // Hide link joints when tapping on the canvas
    canvasWriter.model.hideAllLinkJoints();

    if (selectedComponentId != null) {
      // If a component is selected, hide its highlight
      hideComponentHighlight(selectedComponentId);
    } else {
      // Calculate the position on the canvas based on the tap
      Offset canvasPosition = canvasReader.state.fromCanvasCoordinates(details.localPosition);

      // Define a new component data
      MyComponentData componentData = MyComponentData(
        color: Colors.blue,         // Set your preferred color
        borderColor: Colors.black,  // Set the border color
        borderWidth: 2.0,           // Set the border width
        text: 'New Component',      // Text to display inside the component
        textAlignment: Alignment.center,
        textSize: 15.0,
      );

      // Add a new component to the canvas
      canvasWriter.model.addComponent(
        ComponentData(
          id: 'unique_id',            // Generate a unique ID if needed
          position: canvasPosition,    // Use the calculated canvas position
          size: const Size(120, 72),   // Set the size of the component
          minSize: const Size(80, 64), // Set the min size of the component
          type: 'rect',                // Define the type, e.g., 'rect'
          data: componentData,         // Pass the component data
        ),
      );
    }
  }
}





// Mixin where component behaviour is defined. In this example it is the movement, highlight and connecting two components.
mixin MyComponentPolicy implements ComponentPolicy, CustomPolicy {
  // variable used to calculate delta offset to move the component.
  late Offset lastFocalPoint;

  @override
  onComponentTap(String componentId) {
    canvasWriter.model.hideAllLinkJoints();

    bool connected = connectComponents(selectedComponentId, componentId);
    hideComponentHighlight(selectedComponentId);
    if (!connected) {
      highlightComponent(componentId);
    }

//    canvasModel = canvasWriter.model.getCanvasModel();
  }

  @override
  onComponentLongPress(String componentId) {
    hideComponentHighlight(selectedComponentId);
    canvasWriter.model.hideAllLinkJoints();
    canvasWriter.model.removeComponent(componentId);
  }

  @override
  onComponentScaleStart(componentId, details) {
    lastFocalPoint = details.localFocalPoint;
  }

  @override
  onComponentScaleUpdate(componentId, details) {
    Offset positionDelta = details.localFocalPoint - lastFocalPoint;
    canvasWriter.model.moveComponent(componentId, positionDelta);
    lastFocalPoint = details.localFocalPoint;
  }

  // This function tests if it's possible to connect the components and if yes, connects them
  bool connectComponents(String? sourceComponentId, String? targetComponentId) {
    if (sourceComponentId == null || targetComponentId == null) {
      return false;
    }
    // tests if the ids are not same (the same component)
    if (sourceComponentId == targetComponentId) {
      return false;
    }
    // tests if the connection between two components already exists (one way)
    if (canvasReader.model
        .getComponent(sourceComponentId)
        .connections
        .any((connection) => (connection is ConnectionOut) && (connection.otherComponentId == targetComponentId))) {
      return false;
    }

    // This connects two components (creates a link between), you can define the design of the link with LinkStyle.
    canvasWriter.model.connectTwoComponents(
      sourceComponentId: sourceComponentId,
      targetComponentId: targetComponentId,
      linkStyle: LinkStyle(
        arrowType: ArrowType.pointedArrow,
        lineWidth: 1.5,
        backArrowType: ArrowType.centerCircle,
      ),
    );

    return true;
  }
}

mixin CustomPolicy implements PolicySet {
  DiagramModel diagramModel = DiagramModel();

  VoidCallback? setStateCallback;

  String? selectedComponentId;
  String serializedDiagram = '{"components": [], "links": []}'; // Default empty diagram

  // Remove all components from the canvas
  void removeAll() {
    canvasWriter.model.removeAllComponents();
  }

  // Reset the canvas view
  void resetView() {
    canvasWriter.state.resetCanvasView();
  }

  // Highlight a specific component by ID
  void highlightComponent(String componentId) {
    final component = canvasReader.model.getComponent(componentId);
    component.data.showHighlight();
    component.updateComponent();
    selectedComponentId = componentId;
  }

  // Hide the highlight of a specific component
  void hideComponentHighlight(String? componentId) {
    if (componentId != null) {
      final component = canvasReader.model.getComponent(componentId);
      component.data.hideHighlight();
      component.updateComponent();
      selectedComponentId = null;
    }
  }

  // Remove all components from the canvas
  void deleteAllComponents() {
    selectedComponentId = null;
    canvasWriter.model.removeAllComponents();
  }

  // Save the diagram to a serialized JSON string
//  void serialize() {
//    serializedDiagram = canvasReader.model.serializeDiagram();
//    debugPrint('Diagram serialized successfully: $serializedDiagram');
//  }

  void serialize() {
    serializedDiagram = canvasReader.model.serializeDiagram();
    debugPrint('Diagram serialized successfully: $serializedDiagram');
    diagramModel = DiagramModel(); // Reset the diagramModel
    DiagramData diagramData = DiagramData.fromJson(jsonDecode(serializedDiagram));
    for (var component in diagramData.components) {
      diagramModel.addComponent(component);
    }
    for (var link in diagramData.links) {
      diagramModel.connectTwoComponents(link);
    }
  }

  // Deserialize the diagram data
  void deserialize() {

    if (setStateCallback != null) {
      setStateCallback!();  // Trigger the setState callback
    }

    // Remove all components before deserialization
    canvasWriter.model.removeAllComponents();

    // Deserialize the diagram
    canvasWriter.model.deserializeDiagram(
      serializedDiagram,
      decodeCustomComponentData: (json) => MyComponentData.fromJson(json),
      decodeCustomLinkData: null,
    );

    // Add components to the canvas
    for (var component in diagramModel.components) {
      debugPrint('Adding component: ${component.id} at position ${component.position}');
      canvasWriter.model.addComponent(ComponentData.fromJson({
        'id': component.id,
        'position': [component.position.dx, component.position.dy],
        'size': [component.size.width, component.size.height],
        'min_size': [component.minSize.width, component.minSize.height],
        'type': component.type,
        'z_order': component.zOrder,
        'parent_id': component.parentId?.isEmpty ?? true ? null : component.parentId,
        'children_ids': component.childrenIds,
        'connections': component.connections.map((c) => component.toJson()).toList(),
      }));
    }
  }
}

//class ComponentData {
//  final String id;
//  final Offset position;
//  final Size size;
//  final Size minSize;
//  final String type;
//  final int zOrder;
//  final String? parentId;
//  final List<String> childrenIds;
//  final List<String> connections;
//  final MyComponentData data;
//
//  ComponentData({
//    required this.id,
//    required this.position,
//    required this.size,
//    required this.minSize,
//    required this.type,
//    required this.zOrder,
//    this.parentId,
//    required this.childrenIds,
//    required this.connections,
//    required this.data,
//  });
//
//  factory ComponentData.fromJson(Map<String, dynamic> json) {
//    return ComponentData(
//      id: json['id'].toString(),
//      position: Offset((json['position'][0] as num).toDouble(), (json['position'][1] as num).toDouble()),
//      size: Size((json['size'][0] as num).toDouble(), (json['size'][1] as num).toDouble()),
//      minSize: Size((json['min_size'][0] as num).toDouble(), (json['min_size'][1] as num).toDouble()),
//      type: json['type'],
//      zOrder: json['z_order'],
//      parentId: json['parent_id'],
//      childrenIds: (json['children_ids'] as List<dynamic>).cast<String>(),
//      connections: (json['connections'] as List<dynamic>).cast<String>(),
//      data: MyComponentData.fromJson(json['dynamic_data']),  // Ensure dynamic data is parsed
//    );
//  }
//}

//class ComponentData {
//  final String id;
//  final Offset position;
//  final Size size;
//  final Size minSize;
//  final String type;
//  final int zOrder;
//  final String? parentId;
//  final List<String> childrenIds;
//  final List<String> connections;
//  final MyComponentData data;
//
//  ComponentData({
//    required this.id,
//    required this.position,
//    required this.size,
//    required this.minSize,
//    required this.type,
//    required this.zOrder,
//    this.parentId,
//    required this.childrenIds,
//    required this.connections,
//    required this.data,
//  });
//
//  factory ComponentData.fromJson(Map<String, dynamic> json) {
//    return ComponentData(
//      id: json['id'].toString(),
//      position: Offset((json['position'][0] as num).toDouble(), (json['position'][1] as num).toDouble()),
//      size: Size((json['size'][0] as num).toDouble(), (json['size'][1] as num).toDouble()),
//      minSize: Size((json['min_size'][0] as num).toDouble(), (json['min_size'][1] as num).toDouble()),
//      type: json['type'],
//      zOrder: json['z_order'],
//      parentId: json['parent_id'],
//      childrenIds: (json['children_ids'] as List<dynamic>).cast<String>(),
//      connections: (json['connections'] as List<dynamic>).cast<String>(),
//      data: MyComponentData.fromJson(json['dynamic_data']),  // Ensure dynamic data is parsed
//    );
//  }
//}

//class ComponentData {
//  ComponentData();
//
//  bool isHighlightVisible = false;
//  Color color = Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
//
//  showHighlight() {
//    isHighlightVisible = true;
//  }
//
//  hideHighlight() {
//    isHighlightVisible = false;
//  }
//
//  factory ComponentData.fromJson(Map<String, dynamic> json) {
//    return ComponentData(
//      id: json['id'].toString(),
//      position: Offset((json['position'][0] as num).toDouble(), (json['position'][1] as num).toDouble()),
//      size: Size((json['size'][0] as num).toDouble(), (json['size'][1] as num).toDouble()),
//      minSize: Size((json['min_size'][0] as num).toDouble(), (json['min_size'][1] as num).toDouble()),
//      type: json['type'],
//      parentId: json['parent_id'],
//      childrenIds: (json['children_ids'] as List<dynamic>).cast<String>(),
//      connections: (json['connections'] as List<dynamic>).cast<String>(),
//      data: json['dynamic_data'] != null
//          ? MyComponentData.fromJson(json['dynamic_data'])
//          : MyComponentData(),  // Fallback to default MyComponentData if missing
//    );
//  }
//
//
//
//  // Function used to deserialize the diagram. Must be passed to canvasWriter.model.deserializeDiagram for proper deserialization.
////  MyComponentData.fromJson(Map<String, dynamic> json)
////      : isHighlightVisible = json['highlight'],
////        color = Color(int.parse(json['color'], radix: 16));
//
//  // Function used to serialization of the diagram. E.g. to save to a file.
//  Map<String, dynamic> toJson() => {
//    'highlight': isHighlightVisible,
//    'color': color.toString().split('(0x')[1].split(')')[0],
//  };
//}