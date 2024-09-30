import 'package:flutter/material.dart';
import 'main.dart';
import 'sql_tools.dart';
import 'help_tools.dart';
import 'resources.dart';
import 'package:camera/camera.dart' show availableCameras;
import 'camera.dart';
import 'package:flag/flag.dart';

void main() {
  runApp(const ToolsForm());
}

class ToolsForm extends StatelessWidget {
  const ToolsForm({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove the debug banner
        debugShowCheckedModeBanner: false,
        title: 'Tools',
        theme: ThemeData(
          primarySwatch: Colors.lightBlue,
        ),
        home: const ToolsPage());
  }
}

class ToolsPage extends StatefulWidget {
  const ToolsPage({super.key});

  @override
  State<ToolsPage> createState() => _ToolsPageState();
}

class _ToolsPageState extends State<ToolsPage> {
  // All tools
  List<Map<String, dynamic>> _tools = [];

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshTools() async {
    final data = await SQLHelperTools.getTools();
    setState(() {
      _tools = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshTools();
  }

  final _toolNameController = TextEditingController();
  final _toolTypeController = TextEditingController();
  final _toolActivityAreaController = TextEditingController();
  final _toolFunctionController = TextEditingController();
  final _toolCommentController = TextEditingController();
  final _toolBinomialController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingTool =
      _tools.firstWhere((element) => element['id'] == id);
      _toolNameController.text = existingTool['toolName'];
      _toolTypeController.text = existingTool['toolType'];
      _toolActivityAreaController.text = existingTool['toolActivityArea'];
      _toolFunctionController.text = existingTool['toolFunction'];
      _toolCommentController.text = existingTool['toolComment'];
      _toolBinomialController.text = existingTool['toolBinomial'];
    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (context) => SingleChildScrollView(
          padding: EdgeInsets.only(
            top: 15,
            left: 15,
            right: 15,
            // this will prevent the soft keyboard from covering the text fields
            bottom: MediaQuery.of(context).viewInsets.bottom + 120,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _toolNameController,
                  decoration: const InputDecoration(hintText: 'Tool NAME'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _toolTypeController,
                  decoration: const InputDecoration(hintText: 'Tool TYPE'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _toolActivityAreaController,
                  decoration: const InputDecoration(hintText: 'Tool ACTIVITY Area'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _toolFunctionController,
                  decoration: const InputDecoration(hintText: 'Tool FUNCTION (related verb)'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _toolCommentController,
                  decoration: const InputDecoration(hintText: 'Tool COMMENT'),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('BACK'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlueAccent[100],
                    ),
                    onPressed: () {

                      Navigator.of(context).pop();
                    },
                  ),

                  ElevatedButton.icon(
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('PHOTO'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlueAccent[100],
                    ),
                    onPressed: () async {
                      String toolBinomial = (_toolTypeController.text.isNotEmpty ? '${_toolTypeController.text} ' : '') + _toolNameController.text;
                      debugPrint(toolBinomial);
                      //save new tool
                      if (id == null) {
                        await _addTool(_toolNameController.text, _toolTypeController.text, _toolActivityAreaController.text, _toolFunctionController.text, _toolCommentController.text, toolBinomial);

                      }
                      if (id != null) {
                        await _updateTool(id, _toolNameController.text, _toolTypeController.text, _toolActivityAreaController.text, _toolFunctionController.text, _toolCommentController.text, toolBinomial);
                      }

                      String toolName = _toolNameController.text.isNotEmpty
                          ? _toolNameController.text
                          : 'TOOL';

                      String toolType = _toolTypeController.text.isNotEmpty
                          ? _toolTypeController.text
                          : '';

                      String resourceNameMessage = '$toolType $toolName';

                      await availableCameras().then((value) => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => CameraApp(cameras: value, resourceName: resourceNameMessage, resourceType: 'tool'))));

                    },
                  ),

                  ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: Text(id == null ? 'SAVE' : 'UPDATE'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlueAccent[100],
                    ),
                    onPressed: () async {
                      String toolBinomial = (_toolTypeController.text.isNotEmpty ? '${_toolTypeController.text} ' : '') + _toolNameController.text;
                      //save new tool
                      if (id == null) {
                        await _addTool(_toolNameController.text, _toolTypeController.text, _toolActivityAreaController.text, _toolFunctionController.text, _toolCommentController.text, toolBinomial);

                      }
                      if (id != null) {
                        await _updateTool(id, _toolNameController.text, _toolTypeController.text, _toolActivityAreaController.text, _toolFunctionController.text, _toolCommentController.text, toolBinomial);
                      }

                      // Clear the text fields
                      _toolNameController.text = '';
                      _toolTypeController.text = '';
                      _toolActivityAreaController.text = '';
                      _toolFunctionController.text = '';
                      _toolCommentController.text = '';
                      _toolBinomialController.text = '';
                      // Close the bottom sheet
                      if (!mounted) return;
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),


              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('ADD'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent[100],
                ),
                onPressed: () async {
                  String toolBinomial = (_toolTypeController.text.isNotEmpty ? '${_toolTypeController.text} ' : '') + _toolNameController.text;

                  if (id == null) {
                    // Adding a new task
                    await _addTool(_toolNameController.text, _toolTypeController.text, _toolActivityAreaController.text, _toolFunctionController.text, _toolCommentController.text, toolBinomial);
                  } else {
                    // Updating an existing task
                    await _updateTool(id, _toolNameController.text, _toolTypeController.text, _toolActivityAreaController.text, _toolFunctionController.text, _toolCommentController.text, toolBinomial);

                    // Clear the text fields
                    _toolNameController.text = '';
                    _toolTypeController.text = '';
                    _toolActivityAreaController.text = '';
                    _toolFunctionController.text = '';
                    _toolCommentController.text = '';
                    _toolBinomialController.text = '';
                  }

                  if (!mounted) return;

                },
              ),



            ],
          ),
        ));
  }

  Future<void> _addTool(String toolName, String? toolType, String? toolActivityArea, String? toolFunction, String? toolComment, String toolBinomial) async {
    await SQLHelperTools.createTool(toolName, toolType, toolActivityArea, toolFunction, toolComment, toolBinomial);
    _refreshTools();
  }

  Future<void> _updateTool(int id, toolName, String? toolType, String? toolActivityArea, String? toolFunction, String? toolComment, String toolBinomial) async {
    await SQLHelperTools.updateTool(id, toolName, toolType, toolActivityArea, toolFunction, toolComment, toolBinomial);
    _refreshTools();
  }

  void _deleteTool(int id) async {
    await SQLHelperTools.deleteTool(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Tool deleted!'),
    ));
    _refreshTools();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('N4O Workflow Tool: Tools'),
        leading: const Icon(Icons.build_outlined),
        backgroundColor: Colors.lightBlue,
        elevation: 5,

        actions: <Widget>[

          IconButton(
            icon:
            Flag.fromCode(
              FlagsCode.DE,
              height: 100,
            ),

            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpTools()),
              );

            },
          ),

          IconButton(
            icon:
            Flags.fromCode(
              const [
                FlagsCode.GB,
                FlagsCode.US,
              ],
              height: 35,
              width: 35 * 4 / 3,
            ),

            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpTools()),
              );

            },
          ),

          IconButton(
            icon: const Icon(Icons.help),
            iconSize: 40,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpTools()),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 40),
        itemCount: _tools.length,
        itemBuilder: (context, index) => Card(
          color: Colors.lightBlueAccent[100],
          margin: const EdgeInsets.all(15),
          child: ListTile(
              title: Text(_tools[index]['toolName']),
              subtitle: Text(_tools[index]['toolType']),
              trailing: SizedBox(
                width: 150,
                child: Row(
                  children: [
                    IconButton(
                      iconSize: 30,
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showForm(_tools[index]['id']),
                    ),
                    const SizedBox(
                      width: 30.0,
                    ),
                    IconButton(
                      iconSize: 30,
                      icon: const Icon(Icons.delete),
                      onPressed: () =>
                          _deleteTool(_tools[index]['id']),
                    ),
                  ],
                ),
              )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlueAccent,
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),

      bottomNavigationBar: BottomNavigationBar(
        unselectedLabelStyle: const TextStyle(color: Colors.white),
        onTap: (toolIndex) {
          StepState.disabled.index;
          switch (toolIndex) {
            case 0:
              {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AvailableResources()),
                );
                setState(() {
                  toolIndex = 0;
                });
              }

              break;

            case 1:
              {
                setState(() {
                  toolIndex = 1;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NFDIexperimentApp()),
                );
              }

              break;

//            case 2:
//              {
//                setState(() {
//                  toolIndex = 2;
//                });
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                      builder: (context) => const PhotosVideo()),
//                );
//              }
//
//              break;
          }
        },

        backgroundColor: Colors.lightBlueAccent,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_back,
                color: Colors.white),
            label: 'Resources',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home,
                color: Colors.white),
            label: 'Home',
          ),
//          BottomNavigationBarTool(
//            icon: Icon(Icons.camera_alt,
//                color: Colors.white),
//            label: 'Photo',
//          ),
        ],
      ),

    );
  }
}