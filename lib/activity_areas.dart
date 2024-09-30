import 'package:flutter/material.dart';
import 'main.dart';
import 'sql_activityareas.dart';
import 'help_activityareas.dart';
import 'resources.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:flag/flag.dart';

void main() {
  runApp(const ActivityAreasForm());
}

class ActivityAreasForm extends StatelessWidget {
  const ActivityAreasForm({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove the debug banner
        debugShowCheckedModeBanner: false,
        title: 'ActivityArea',
        theme: ThemeData(
          primarySwatch: Colors.lightBlue,
        ),
        home: const ActivityAreaPage());
  }
}

class ActivityAreaPage extends StatefulWidget {
  const ActivityAreaPage({super.key});

  @override
  State<ActivityAreaPage> createState() => _ActivityAreaPageState();
}

class _ActivityAreaPageState extends State<ActivityAreaPage> {
  // All tools
  List<Map<String, dynamic>> _activityAreas = [];

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshActivityArea() async {
    final data = await SQLHelperActivityAreas.getItems();
    setState(() {
      _activityAreas = data;
      _isLoading = false;
    });
  }

  void _onChanged(dynamic val) => debugPrint(val.toString());

  @override
  void initState() {
    super.initState();
    _refreshActivityArea(); // Loading the diary when the app starts
  }

  final TextEditingController _activityAreaNameController = TextEditingController();
  final TextEditingController _activityAreaTypeController = TextEditingController();
  final TextEditingController _activityAreaFunctionController = TextEditingController();
  final TextEditingController _activityAreaCommentController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingTool =
      _activityAreas.firstWhere((element) => element['id'] == id);
      _activityAreaNameController.text = existingTool['activityAreaName'];
      _activityAreaTypeController.text = existingTool['activityAreaType'];
      _activityAreaFunctionController.text = existingTool['activityAreaFunction'];
      _activityAreaCommentController.text = existingTool['activityAreaComment'];
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
//            crossAxisAlignment: CrossAxisAlignment.end,
            children: [

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _activityAreaNameController,
                  decoration: const InputDecoration(hintText: 'Activity Area NAME'),
                ),
              ),

              Padding(
                  padding: const EdgeInsets.only(top:10, left:10, right:10),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      const Text("How is this activity area relevant?", style: TextStyle(
                          fontSize: 24
                      ),),

                      FormBuilderFilterChip<String>(
                        alignment: WrapAlignment.spaceEvenly,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        name: 'activity_area_function',
                        labelStyle: const TextStyle(fontSize: 24),
                        selectedColor: Colors.red,
                        elevation: 5,
                        options: const [
                          FormBuilderChipOption(
                            value: 'iExperimentation',
                            avatar: CircleAvatar(child: Icon(Icons.science_outlined)),
                            child: Text('Experimentation'),
                          ),
                          FormBuilderChipOption(
                            value: 'iObservation',
                            avatar: CircleAvatar(child: Icon(Icons.biotech_outlined)),
                            child: Text('Observation'),
                          ),
                          FormBuilderChipOption(
                            value: 'iMeasurement',
                            avatar: CircleAvatar(child: Icon(Icons.bar_chart)),
                            child: Text('Measurement'),
                          ),
                          FormBuilderChipOption(
                            value: 'iReplication',
                            avatar: CircleAvatar(child: Icon(Icons.content_copy_outlined)),
                            child: Text('Replication'),
                          ),

                          FormBuilderChipOption(
                            value: 'iReconstruction',
                            avatar: CircleAvatar(child: Icon(Icons.foundation)),
                            child: Text('Reconstruction'),
                          ),
                          FormBuilderChipOption(
                            value: 'iReenactment',
                            avatar: CircleAvatar(child: Icon(Icons.theater_comedy_outlined)),
                            child: Text('Reenactment'),
                          ),
                        ],
                        onChanged: _onChanged,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.minLength(1),
                        ]),
                      ),

                    ],)
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _activityAreaCommentController,
                  decoration: const InputDecoration(hintText: 'Activity Area COMMENT'),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('BACK'),
                    onPressed: () {

                      Navigator.of(context).pop();
                    },
                  ),

                  ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: Text(id == null ? 'SAVE' : 'UPDATE'),

                    onPressed: () async {
                      // Save new tool
                      if (id == null) {
                        await _addItem();
                      }

                      if (id != null) {
                        await _updateItem(id);
                      }

                      // Clear the text fields
                      _activityAreaNameController.text = '';
                      _activityAreaTypeController.text = '';
                      _activityAreaFunctionController.text = '';
                      _activityAreaCommentController.text = '';
                      // Close the bottom sheet
                      if (!mounted) return;
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          ),
        ));
  }

// Insert a new tool to the database
  Future<void> _addItem() async {
    await SQLHelperActivityAreas.createItem(
        _activityAreaNameController.text,
        _activityAreaTypeController.text,
        _activityAreaFunctionController.text,
        _activityAreaCommentController.text);
    _refreshActivityArea();
  }

  // Update an existing tool
  Future<void> _updateItem(int id) async {
    await SQLHelperActivityAreas.updateItem(
        id, _activityAreaNameController.text,
        _activityAreaTypeController.text,
        _activityAreaFunctionController.text,
        _activityAreaCommentController.text);
    _refreshActivityArea();
  }

  // Delete an item
  void _deleteItem(int id) async {
    await SQLHelperActivityAreas.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Activity Area deleted!'),
    ));
    _refreshActivityArea();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('N4O Workflow Tool: ActivityArea'),
        leading: const Icon(Icons.directions_run),
        backgroundColor: Colors.lightBlue,

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
                MaterialPageRoute(builder: (context) => const HelpActivityAreas()),
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
                MaterialPageRoute(builder: (context) => const HelpActivityAreas()),
              );

            },
          ),
          IconButton(
            icon: const Icon(Icons.help),
            iconSize: 40,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpActivityAreas()),
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
        itemCount: _activityAreas.length,
        itemBuilder: (context, index) => Card(
          color: Colors.lightBlue[200],
          margin: const EdgeInsets.all(15),
          child: ListTile(
              title: Text(_activityAreas[index]['activityAreaName']),
              subtitle: Text(_activityAreas[index]['activityAreaType']),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showForm(_activityAreas[index]['id']),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () =>
                          _deleteItem(_activityAreas[index]['id']),
                    ),
                  ],
                ),
              )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),

      bottomNavigationBar: BottomNavigationBar(
        unselectedLabelStyle: const TextStyle(color: Colors.white),
        onTap: (compoundIndex) {
          StepState.disabled.index;
          switch (compoundIndex) {
            case 0:
              {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AvailableResources()),
                );
                setState(() {
                  compoundIndex = 0;
                });
              }

              break;

            case 1:
              {
                setState(() {
                  compoundIndex = 1;
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
//                  compoundIndex = 2;
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
//          BottomNavigationBarItem(
//            icon: Icon(Icons.camera_alt,
//                color: Colors.white),
//            label: 'Photo',
//          ),
        ],
      ),

    );
  }
}