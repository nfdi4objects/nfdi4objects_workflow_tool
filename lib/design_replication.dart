import 'package:flutter/material.dart';
import 'main.dart';
import 'sql_replication.dart';
import 'help_replication.dart';
import 'resources.dart';
import 'package:flag/flag.dart';
//import 'camera.dart';
import 'tasks.dart';

void main() {
  runApp(const ReplicationForm());
}

class ReplicationForm extends StatelessWidget {
  const ReplicationForm({super.key});

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
        title: 'Replication',
        theme: ThemeData(
          primarySwatch: Colors.lightGreen,
        ),
        home: const ReplicationPage());
  }
}

class ReplicationPage extends StatefulWidget {
  const ReplicationPage({super.key});

  @override
  State<ReplicationPage> createState() => _ReplicationPageState();
}

class _ReplicationPageState extends State<ReplicationPage> {
  List<Replication> _replication = [];

  bool _isLoading = true;

//  bool _isChecked = false;

  Future<void> _refreshReplication() async {
    setState(() {
      _isLoading = true;
    });

    Future<void> loadReplication() async {
      final replicationMaps = await SQLHelperReplication.getReplications();
      final replications = replicationMaps.map((map) => Replication.fromMap(map)).toList();
      setState(() {
        _replication = replications;

        _isLoading = false;
      });
    }

    final database = await SQLHelperReplication.getReplications();

    final List<Map<String, dynamic>> maps = database;

    await Future.delayed(const Duration(milliseconds: 100)); // Add a short delay

    setState(() {
      _replication = maps.map((map) => Replication.fromMap(map)).toList();

      _isLoading = false;

    });
  }

  void _testReplication() {
    if (_replication.indexWhere((replication) => replication.replicationName == _replicationNameController.text) == -1) {
      setState(() {
        _replication.add({'replicationName': _replicationNameController.text} as Replication);

      });
    } else {
      const Text('Name already entered.');
    }
  }

  void _onChanged(dynamic val) => debugPrint(val.toString());

  @override
  void initState() {
    super.initState();

    _refreshReplication();
  }

  final _replicationNameController = TextEditingController();
  final _replicationTypeController = TextEditingController();
  final _replicationReferenceController = TextEditingController();
  final _replicationAimController = TextEditingController();
  final _replicationSerialNumberController = TextEditingController();
  final _replicationActivityAreaController = TextEditingController();
  final _replicationPurposeController = TextEditingController();
  final _replicationWebPageController = TextEditingController();
  final _replicationCommentController = TextEditingController();
  final _replicationCompletedController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int? id) async {

//    List<String> initialValues = [];

    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingReplication =
      _replication.firstWhere((element) => element.id == id);
      _replicationNameController.text = existingReplication.replicationName;
      _replicationTypeController.text = existingReplication.replicationType;
      _replicationReferenceController.text = existingReplication.replicationReference;
      _replicationAimController.text = existingReplication.replicationAim;
      _replicationSerialNumberController.text = existingReplication.replicationSerialNumber;
      _replicationActivityAreaController.text = existingReplication.replicationActivityArea;
      _replicationPurposeController.text = existingReplication.replicationPurpose;
      _replicationWebPageController.text = existingReplication.replicationWebPage;
      _replicationCommentController.text = existingReplication.replicationComment;
      _replicationCompletedController.text = existingReplication.replicationCompleted ? 'true' : 'false';

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
                'Plan a REPLICATION:',
                style: TextStyle(
                    fontSize: 24),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextFormField(
                  controller: _replicationNameController,
                  decoration: const InputDecoration(hintText: 'Replication NAME'),

                  autovalidateMode: AutovalidateMode.always,
                  validator: (value) {
                    if (_replication.indexWhere((replication) => replication.replicationName == value) != -1) {
                      return 'Must be unique.';
                    }
                    return null;
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _replicationTypeController,
                  decoration: const InputDecoration(hintText: 'Replication TYPE'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _replicationSerialNumberController,
                  decoration: const InputDecoration(hintText: 'Replication SERIAL NUMBER (other identifier)'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _replicationReferenceController,
                  decoration: const InputDecoration(hintText: 'WHAT do you want to replicate?'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _replicationAimController,
                  decoration: const InputDecoration(hintText: 'WHY do you want to replicate this?'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _replicationActivityAreaController,
                  decoration: const InputDecoration(hintText: 'Replication ACTIVITY Area'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _replicationPurposeController,
                  decoration: const InputDecoration(hintText: 'Replication PURPOSE'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _replicationWebPageController,
                  decoration: const InputDecoration(hintText: 'Replication WEB PAGE'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _replicationCommentController,
                  decoration: const InputDecoration(hintText: 'Replication COMMENT'),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('BACK'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreen[200]
                    ),
                    onPressed: () {

                      Navigator.of(context).pop();
                    },
                  ),

                  ElevatedButton.icon(
                    icon: const Icon(Icons.check_box_outlined),
                    label: const Text('TASKS'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreen
                    ),

                    onPressed: () async {
                      // Save new replication
                      if (id == null) {
                        await _addReplication();
                      }

                      if (id != null) {
                        _testReplication;
                        await _updateReplication(id);
                      }

                      String designName = _replicationNameController.text.isNotEmpty
                          ? _replicationNameController.text
                          : 'REPLICATION';

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TasksForm(designName: 'Replication $designName', designColor: Colors.lightGreen, button1color: Colors.lightGreen.shade100, button2color: Colors.lightGreen.shade200, tasks: const [],)),
                      );

                    },
                  ),

                  ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: Text(id == null ? 'SAVE' : 'UPDATE'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreen
                    ),
                    onPressed: () async {
                      // Save new replication
                      if (id == null) {
                        await _addReplication();
                      }

                      if (id != null) {
                        _testReplication;
                        await _updateReplication(id);
                      }

                      // Clear the text fields
                      _replicationNameController.text = '';
                      _replicationTypeController.text = '';
                      _replicationReferenceController.text = '';
                      _replicationAimController.text = '';
                      _replicationSerialNumberController.text = '';
                      _replicationActivityAreaController.text = '';
                      _replicationPurposeController.text = '';
                      _replicationWebPageController.text = '';
                      _replicationCommentController.text = '';

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

// Insert a new replication to the database
  Future<void> _addReplication() async {
    await SQLHelperReplication.createReplication(
        _replicationNameController.text, _replicationTypeController.text, _replicationReferenceController.text, _replicationAimController.text, _replicationSerialNumberController.text, _replicationActivityAreaController.text, _replicationPurposeController.text, _replicationWebPageController.text, _replicationCommentController.text, _replicationCompletedController.text);
    _refreshReplication();
  }

  // Update an existing replication
  Future<void> _updateReplication(id) async {
    await SQLHelperReplication.updateReplication(
        id, _replicationNameController.text, _replicationTypeController.text, _replicationReferenceController.text, _replicationAimController.text, _replicationSerialNumberController.text, _replicationActivityAreaController.text, _replicationPurposeController.text, _replicationWebPageController.text, _replicationCommentController.text, _replicationCompletedController.text);
    _refreshReplication();
  }

  // Delete an item
  void _deleteReplication(id, String replicationName) async {
    await SQLHelperReplication.deleteReplication(id);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('$replicationName deleted!'),
    ));
    _refreshReplication();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('N4O Workflow Tool: Replication Plan'),
        leading: const Icon(Icons.copy),
        backgroundColor: Colors.lightGreen,
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
                    builder: (context) => const HelpReplication()),
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
                    builder: (context) => const HelpReplication()),
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
                    builder: (context) => const HelpReplication()),
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
        itemCount: _replication.length,

        itemBuilder: (context, index) {
          if (index < _replication.length) {
            return Card(

              color: Colors.lightGreen[100],
              margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),

              child: CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,

                title: Text(_replication[index].replicationName),
                subtitle: Text(_replication[index].replicationType),

                value: _replication[index].replicationCompleted,

                onChanged: (bool? isChecked) {

                  setState(() {
                    _replication[index].replicationCompleted = isChecked ?? false;
                  });

                  // Update the database
                  SQLHelperReplication.updateReplication(
                    _replication[index].id,
                    _replication[index].replicationName,
                    _replication[index].replicationType,
                    _replication[index].replicationReference,
                    _replication[index].replicationAim,
                    _replication[index].replicationSerialNumber,
                    _replication[index].replicationActivityArea,
                    _replication[index].replicationPurpose,
                    _replication[index].replicationWebPage,
                    _replication[index].replicationComment,
                    _replication[index].replicationCompleted ? 'true' : 'false',
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
                              _showForm(_replication[index].id),
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
                              _deleteReplication(_replication[index].id,
                                  _replication[index].replicationName),
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
        backgroundColor: Colors.lightGreen,
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

        backgroundColor: Colors.lightGreen,
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

class Replication {
  int id;
  late String replicationName;
  late String replicationType;
  late String replicationReference;
  late String replicationAim;
  late String replicationSerialNumber;
  late String replicationActivityArea;
  late String replicationPurpose;
  late String replicationWebPage;
  late String replicationComment;
  bool replicationCompleted;

  Replication({required this.id, required this.replicationName, required this.replicationType,
    required this.replicationReference,
    required this.replicationAim,
    required this.replicationSerialNumber,
    required this.replicationActivityArea,
    required this.replicationPurpose,
    required this.replicationWebPage,
    required this.replicationComment,
    required this.replicationCompleted
  });

  factory Replication.fromMap(Map<String, dynamic> map) {
    return Replication(
      id: map['id'] as int,
      replicationName: map['replicationName'] as String,
      replicationType: map['replicationType'] as String,
      replicationReference: map['replicationReference'] as String,
      replicationAim: map['replicationAim'] as String,
      replicationSerialNumber: map['replicationSerialNumber'] as String,
      replicationActivityArea: map['replicationActivityArea'] as String,
      replicationPurpose: map['replicationPurpose'] as String,
      replicationWebPage: map['_replicationWebPage'] != null ? map['_replicationWebPage'] as String : '',
//      replicationWebPage: map['_replicationWebPage'] as String,
      replicationComment: map['replicationComment'] as String,
      replicationCompleted: map['replicationCompleted'] == 'true',
    );
  }
}
