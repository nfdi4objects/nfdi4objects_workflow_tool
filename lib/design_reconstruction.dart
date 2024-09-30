import 'package:flutter/material.dart';
import 'main.dart';
import 'sql_reconstruction.dart';
import 'help_reconstruction.dart';
import 'resources.dart';
import 'package:flag/flag.dart';
//import 'camera.dart';
import 'tasks.dart';

void main() {
  runApp(const ReconstructionForm());
}

class ReconstructionForm extends StatelessWidget {
  const ReconstructionForm({super.key});

  TextStyle? _getTextStyle(bool checked) {
    if (!checked) return null;

    return const TextStyle(
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove the debug banner
        debugShowCheckedModeBanner: false,
        title: 'Reconstruction',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: const ReconstructionPage());
  }
}

class ReconstructionPage extends StatefulWidget {
  const ReconstructionPage({super.key});

  @override
  State<ReconstructionPage> createState() => _ReconstructionPageState();
}

class _ReconstructionPageState extends State<ReconstructionPage> {
  List<Reconstruction> _reconstruction = [];

  bool _isLoading = true;

//  bool _isChecked = false;

  Future<void> _refreshReconstruction() async {
    setState(() {
      _isLoading = true;
    });

    Future<void> loadReconstruction() async {
      final reconstructionMaps = await SQLHelperReconstruction.getReconstructions();
      final reconstructions = reconstructionMaps.map((map) => Reconstruction.fromMap(map)).toList();
      setState(() {
        _reconstruction = reconstructions;

        _isLoading = false;
      });
    }

    final database = await SQLHelperReconstruction.getReconstructions();

    final List<Map<String, dynamic>> maps = database;

    await Future.delayed(const Duration(milliseconds: 100)); // Add a short delay

    setState(() {
      _reconstruction = maps.map((map) => Reconstruction.fromMap(map)).toList();

      _isLoading = false;

    });
  }

  void _testReconstruction() {
    if (_reconstruction.indexWhere((reconstruction) => reconstruction.reconstructionName == _reconstructionNameController.text) == -1) {
      setState(() {
        _reconstruction.add({'reconstructionName': _reconstructionNameController.text} as Reconstruction);

      });
    } else {
      const Text('Name already entered.');
    }
  }

  void _onChanged(dynamic val) => debugPrint(val.toString());

  @override
  void initState() {
    super.initState();

    _refreshReconstruction();
  }

  final _reconstructionNameController = TextEditingController();
  final _reconstructionTypeController = TextEditingController();
  final _reconstructionReferenceController = TextEditingController();
  final _reconstructionAimController = TextEditingController();
  final _reconstructionSerialNumberController = TextEditingController();
  final _reconstructionActivityAreaController = TextEditingController();
  final _reconstructionPurposeController = TextEditingController();
  final _reconstructionWebPageController = TextEditingController();
  final _reconstructionCommentController = TextEditingController();
  final _reconstructionCompletedController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int? id) async {

//    List<String> initialValues = [];

    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingReconstruction =
      _reconstruction.firstWhere((element) => element.id == id);
      _reconstructionNameController.text = existingReconstruction.reconstructionName;
      _reconstructionTypeController.text = existingReconstruction.reconstructionType;
      _reconstructionReferenceController.text = existingReconstruction.reconstructionReference;
      _reconstructionAimController.text = existingReconstruction.reconstructionAim;
      _reconstructionSerialNumberController.text = existingReconstruction.reconstructionSerialNumber;
      _reconstructionActivityAreaController.text = existingReconstruction.reconstructionActivityArea;
      _reconstructionPurposeController.text = existingReconstruction.reconstructionPurpose;
      _reconstructionWebPageController.text = existingReconstruction.reconstructionWebPage;
      _reconstructionCommentController.text = existingReconstruction.reconstructionComment;
      _reconstructionCompletedController.text = existingReconstruction.reconstructionCompleted ? 'true' : 'false';

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
            children: [

              const Text(
                'Plan a RECONSTRUCTION:',
                style: TextStyle(
                    fontSize: 24),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextFormField(
                  controller: _reconstructionNameController,
                  decoration: const InputDecoration(hintText: 'Reconstruction NAME'),

                  autovalidateMode: AutovalidateMode.always,
                  validator: (value) {
                    if (_reconstruction.indexWhere((reconstruction) => reconstruction.reconstructionName == value) != -1) {
                      return 'Must be unique.';
                    }
                    return null;
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _reconstructionTypeController,
                  decoration: const InputDecoration(hintText: 'Reconstruction TYPE'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _reconstructionSerialNumberController,
                  decoration: const InputDecoration(hintText: 'Reconstruction SERIAL NUMBER (other identifier)'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _reconstructionReferenceController,
                  decoration: const InputDecoration(hintText: 'WHAT do you want to reconstruct?'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _reconstructionAimController,
                  decoration: const InputDecoration(hintText: 'WHY do you want to reconstruct this?'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _reconstructionActivityAreaController,
                  decoration: const InputDecoration(hintText: 'Reconstruction ACTIVITY Area'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _reconstructionPurposeController,
                  decoration: const InputDecoration(hintText: 'Reconstruction PURPOSE'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _reconstructionWebPageController,
                  decoration: const InputDecoration(hintText: 'Reconstruction WEB PAGE'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _reconstructionCommentController,
                  decoration: const InputDecoration(hintText: 'Reconstruction COMMENT'),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('BACK'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[200]
                    ),
                    onPressed: () {

                      Navigator.of(context).pop();
                    },
                  ),

                  ElevatedButton.icon(
                    icon: const Icon(Icons.check_box_outlined),
                    label: const Text('TASKS'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green
                    ),

                    onPressed: () async {
                      // Save new reconstruction
                      if (id == null) {
                        await _addReconstruction();
                      }

                      if (id != null) {
                        _testReconstruction;
                        await _updateReconstruction(id);
                      }

                      String designName = _reconstructionNameController.text.isNotEmpty
                          ? _reconstructionNameController.text
                          : 'RECONSTRUCTION';

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TasksForm(designName: 'Reconstruction $designName', designColor: Colors.green, button1color: Colors.green.shade100, button2color: Colors.green.shade200, tasks: const [],)),
                      );

                    },
                  ),

                  ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: Text(id == null ? 'SAVE' : 'UPDATE'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green
                    ),
                    onPressed: () async {
                      // Save new reconstruction
                      if (id == null) {
                        await _addReconstruction();
                      }

                      if (id != null) {
                        _testReconstruction;
                        await _updateReconstruction(id);
                      }

                      // Clear the text fields
                      _reconstructionNameController.text = '';
                      _reconstructionTypeController.text = '';
                      _reconstructionReferenceController.text = '';
                      _reconstructionAimController.text = '';
                      _reconstructionSerialNumberController.text = '';
                      _reconstructionActivityAreaController.text = '';
                      _reconstructionPurposeController.text = '';
                      _reconstructionWebPageController.text = '';
                      _reconstructionCommentController.text = '';

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

// Insert a new reconstruction to the database
  Future<void> _addReconstruction() async {
    await SQLHelperReconstruction.createReconstruction(
        _reconstructionNameController.text, _reconstructionTypeController.text, _reconstructionReferenceController.text, _reconstructionAimController.text, _reconstructionSerialNumberController.text, _reconstructionActivityAreaController.text, _reconstructionPurposeController.text, _reconstructionWebPageController.text, _reconstructionCommentController.text, _reconstructionCompletedController.text);
    _refreshReconstruction();
  }

  // Update an existing reconstruction
  Future<void> _updateReconstruction(id) async {
    await SQLHelperReconstruction.updateReconstruction(
        id, _reconstructionNameController.text, _reconstructionTypeController.text, _reconstructionReferenceController.text, _reconstructionAimController.text, _reconstructionSerialNumberController.text, _reconstructionActivityAreaController.text, _reconstructionPurposeController.text, _reconstructionWebPageController.text, _reconstructionCommentController.text, _reconstructionCompletedController.text);
    _refreshReconstruction();
  }

  // Delete an item
  void _deleteReconstruction(id, String reconstructionName) async {
    await SQLHelperReconstruction.deleteReconstruction(id);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('$reconstructionName deleted!'),
    ));
    _refreshReconstruction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('N4O Workflow Tool: Reconstruction Plan'),
        leading: const Icon(Icons.foundation),
        backgroundColor: Colors.green,
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
                MaterialPageRoute(
                    builder: (context) => const HelpReconstruction()),
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
                MaterialPageRoute(
                    builder: (context) => const HelpReconstruction()),
              );
            },
          ),

          IconButton(
            icon: const Icon(Icons.help),
            iconSize: 40,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const HelpReconstruction()),
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
        itemCount: _reconstruction.length,

        itemBuilder: (context, index) {
          if (index < _reconstruction.length) {
            return Card(

              color: Colors.green[100],
              margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),

              child: CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,

                title: Text(_reconstruction[index].reconstructionName),
                subtitle: Text(_reconstruction[index].reconstructionType),

                value: _reconstruction[index].reconstructionCompleted,

                onChanged: (bool? isChecked) {

                  setState(() {
                    _reconstruction[index].reconstructionCompleted = isChecked ?? false;
                  });

                  // Update the database
                  SQLHelperReconstruction.updateReconstruction(
                    _reconstruction[index].id,
                    _reconstruction[index].reconstructionName,
                    _reconstruction[index].reconstructionType,
                    _reconstruction[index].reconstructionReference,
                    _reconstruction[index].reconstructionAim,
                    _reconstruction[index].reconstructionSerialNumber,
                    _reconstruction[index].reconstructionActivityArea,
                    _reconstruction[index].reconstructionPurpose,
                    _reconstruction[index].reconstructionWebPage,
                    _reconstruction[index].reconstructionComment,
                    _reconstruction[index].reconstructionCompleted ? 'true' : 'false',
                  );
                },

                secondary: SizedBox(
                  width: 150,
                  child: Row(
                    children: [

                      Expanded(
                        child: IconButton(
                          iconSize: 30,
                          icon: const Icon(Icons.edit),
                          onPressed: () =>
                              _showForm(_reconstruction[index].id),
                        ),
                      ),
                      const SizedBox(
                          width: 30.0

                      ),
                      Expanded(
                        child: IconButton(
                          iconSize: 30,
                          icon: const Icon(Icons.delete),
                          onPressed: () =>
                              _deleteReconstruction(_reconstruction[index].id,
                                  _reconstruction[index].reconstructionName),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(null),
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),

      bottomNavigationBar: BottomNavigationBar(

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
//                      builder: (_) => const FlowChart()),
//                );
//              }
//
//              break;

          }
        },

        backgroundColor: Colors.green,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_back),
            label: 'Resources',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
//          BottomNavigationBarItem(
//            icon: Icon(Icons.schema_outlined,
//                color: Colors.white),
//            label: 'FLOW CHART',
//          ),
        ],
      ),
      //     ),
    );
  }
}

class Reconstruction {
  int id;
  late String reconstructionName;
  late String reconstructionType;
  late String reconstructionReference;
  late String reconstructionAim;
  late String reconstructionSerialNumber;
  late String reconstructionActivityArea;
  late String reconstructionPurpose;
  late String reconstructionWebPage;
  late String reconstructionComment;
  bool reconstructionCompleted;

  Reconstruction({required this.id, required this.reconstructionName, required this.reconstructionType,
    required this.reconstructionReference,
    required this.reconstructionAim,
    required this.reconstructionSerialNumber,
    required this.reconstructionActivityArea,
    required this.reconstructionPurpose,
    required this.reconstructionWebPage,
    required this.reconstructionComment,
    required this.reconstructionCompleted
  });

  factory Reconstruction.fromMap(Map<String, dynamic> map) {
    return Reconstruction(
      id: map['id'] as int,
      reconstructionName: map['reconstructionName'] as String,
      reconstructionType: map['reconstructionType'] as String,
      reconstructionReference: map['reconstructionReference'] as String,
      reconstructionAim: map['reconstructionAim'] as String,
      reconstructionSerialNumber: map['reconstructionSerialNumber'] as String,
      reconstructionActivityArea: map['reconstructionActivityArea'] as String,
      reconstructionPurpose: map['reconstructionPurpose'] as String,
      reconstructionWebPage: map['_reconstructionWebPage'] != null ? map['_reconstructionWebPage'] as String : '',
//      reconstructionWebPage: map['_reconstructionWebPage'] as String,
      reconstructionComment: map['reconstructionComment'] as String,
      reconstructionCompleted: map['reconstructionCompleted'] == 'true',
    );
  }
}
