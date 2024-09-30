import 'package:flutter/material.dart';
import 'main.dart';
import 'sql_experiment.dart';
import 'help_experiment.dart';
import 'resources.dart';
import 'package:flag/flag.dart';
//import 'camera.dart';
import 'tasks.dart';

void main() {
  runApp(const ExperimentForm());
}

class ExperimentForm extends StatelessWidget {
  const ExperimentForm({super.key});

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
        title: 'Experiment',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
        ),
        home: const ExperimentPage());
  }
}

class ExperimentPage extends StatefulWidget {
  const ExperimentPage({super.key});

  @override
  State<ExperimentPage> createState() => _ExperimentPageState();
}

class _ExperimentPageState extends State<ExperimentPage> {
  List<Experiment> _experiment = [];

  bool _isLoading = true;

//  bool _isChecked = false;

  Future<void> _refreshExperiment() async {
    setState(() {
      _isLoading = true;
    });

    Future<void> loadExperiment() async {
      final experimentMaps = await SQLHelperExperiment.getExperiments();
      final experiments = experimentMaps.map((map) => Experiment.fromMap(map)).toList();
      setState(() {
        _experiment = experiments;

        _isLoading = false;
      });
    }

    final database = await SQLHelperExperiment.getExperiments();

    final List<Map<String, dynamic>> maps = database;

    await Future.delayed(const Duration(milliseconds: 100)); // Add a short delay

    setState(() {
      _experiment = maps.map((map) => Experiment.fromMap(map)).toList();

      _isLoading = false;

    });
  }

  void _testExperiment() {
    if (_experiment.indexWhere((experiment) => experiment.experimentName == _experimentNameController.text) == -1) {
      setState(() {
        _experiment.add({'experimentName': _experimentNameController.text} as Experiment);

      });
    } else {
      const Text('Name already entered.');
    }
  }

  void _onChanged(dynamic val) => debugPrint(val.toString());

  @override
  void initState() {
    super.initState();

    _refreshExperiment();
  }

  final _experimentNameController = TextEditingController();
  final _experimentTypeController = TextEditingController();
  final _experimentReferenceController = TextEditingController();
  final _experimentAimController = TextEditingController();
  final _experimentSerialNumberController = TextEditingController();
  final _experimentActivityAreaController = TextEditingController();
  final _experimentPurposeController = TextEditingController();
  final _experimentWebPageController = TextEditingController();
  final _experimentCommentController = TextEditingController();
  final _experimentCompletedController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int? id) async {

//    List<String> initialValues = [];

    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingExperiment =
      _experiment.firstWhere((element) => element.id == id);
      _experimentNameController.text = existingExperiment.experimentName;
      _experimentTypeController.text = existingExperiment.experimentType;
      _experimentReferenceController.text = existingExperiment.experimentReference;
      _experimentAimController.text = existingExperiment.experimentAim;
      _experimentSerialNumberController.text = existingExperiment.experimentSerialNumber;
      _experimentActivityAreaController.text = existingExperiment.experimentActivityArea;
      _experimentPurposeController.text = existingExperiment.experimentPurpose;
      _experimentWebPageController.text = existingExperiment.experimentWebPage;
      _experimentCommentController.text = existingExperiment.experimentComment;
      _experimentCompletedController.text = existingExperiment.experimentCompleted ? 'true' : 'false';

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
                'Plan a EXPERIMENT:',
                style: TextStyle(
                    fontSize: 24),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextFormField(
                  controller: _experimentNameController,
                  decoration: const InputDecoration(hintText: 'Experiment NAME'),

                  autovalidateMode: AutovalidateMode.always,
                  validator: (value) {
                    if (_experiment.indexWhere((experiment) => experiment.experimentName == value) != -1) {
                      return 'Must be unique.';
                    }
                    return null;
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _experimentTypeController,
                  decoration: const InputDecoration(hintText: 'Experiment TYPE'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _experimentSerialNumberController,
                  decoration: const InputDecoration(hintText: 'Experiment SERIAL NUMBER (other identifier)'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _experimentReferenceController,
                  decoration: const InputDecoration(hintText: 'WHAT do you want to test?'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _experimentAimController,
                  decoration: const InputDecoration(hintText: 'WHY do you want to test this?'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _experimentActivityAreaController,
                  decoration: const InputDecoration(hintText: 'Experiment ACTIVITY Area'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _experimentPurposeController,
                  decoration: const InputDecoration(hintText: 'Experiment PURPOSE'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _experimentWebPageController,
                  decoration: const InputDecoration(hintText: 'Experiment WEB PAGE'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _experimentCommentController,
                  decoration: const InputDecoration(hintText: 'Experiment COMMENT'),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('BACK'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange[200]
                    ),
                    onPressed: () {

                      Navigator.of(context).pop();
                    },
                  ),

                  ElevatedButton.icon(
                    icon: const Icon(Icons.check_box_outlined),
                    label: const Text('TASKS'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange
                    ),

                    onPressed: () async {
                      // Save new experiment
                      if (id == null) {
                        await _addExperiment();
                      }

                      if (id != null) {
                        _testExperiment;
                        await _updateExperiment(id);
                      }

                      String designName = _experimentNameController.text.isNotEmpty
                          ? _experimentNameController.text
                          : 'EXPERIMENT';

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TasksForm(designName: 'Experiment $designName', designColor: Colors.deepOrange, button1color: Colors.deepOrange.shade100, button2color: Colors.deepOrange.shade200, tasks: const [],)),
                      );

                    },
                  ),

                  ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: Text(id == null ? 'SAVE' : 'UPDATE'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange
                    ),
                    onPressed: () async {
                      // Save new experiment
                      if (id == null) {
                        await _addExperiment();
                      }

                      if (id != null) {
                        _testExperiment;
                        await _updateExperiment(id);
                      }

                      // Clear the text fields
                      _experimentNameController.text = '';
                      _experimentTypeController.text = '';
                      _experimentReferenceController.text = '';
                      _experimentAimController.text = '';
                      _experimentSerialNumberController.text = '';
                      _experimentActivityAreaController.text = '';
                      _experimentPurposeController.text = '';
                      _experimentWebPageController.text = '';
                      _experimentCommentController.text = '';

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

// Insert a new experiment to the database
  Future<void> _addExperiment() async {
    await SQLHelperExperiment.createExperiment(
        _experimentNameController.text, _experimentTypeController.text, _experimentReferenceController.text, _experimentAimController.text, _experimentSerialNumberController.text, _experimentActivityAreaController.text, _experimentPurposeController.text, _experimentWebPageController.text, _experimentCommentController.text, _experimentCompletedController.text);
    _refreshExperiment();
  }

  // Update an existing experiment
  Future<void> _updateExperiment(id) async {
    await SQLHelperExperiment.updateExperiment(
        id, _experimentNameController.text, _experimentTypeController.text, _experimentReferenceController.text, _experimentAimController.text, _experimentSerialNumberController.text, _experimentActivityAreaController.text, _experimentPurposeController.text, _experimentWebPageController.text, _experimentCommentController.text, _experimentCompletedController.text);
    _refreshExperiment();
  }

  // Delete an item
  void _deleteExperiment(id, String experimentName) async {
    await SQLHelperExperiment.deleteExperiment(id);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('$experimentName deleted!'),
    ));
    _refreshExperiment();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('N4O Workflow Tool: Experiment Plan'),
        leading: const Icon(Icons.science_outlined),
        backgroundColor: Colors.deepOrange,
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
                    builder: (context) => const HelpExperiment()),
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
                    builder: (context) => const HelpExperiment()),
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
                    builder: (context) => const HelpExperiment()),
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
        itemCount: _experiment.length,

        itemBuilder: (context, index) {
          if (index < _experiment.length) {
            return Card(

              color: Colors.deepOrange[100],
              margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),

              child: CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,

                title: Text(_experiment[index].experimentName),
                subtitle: Text(_experiment[index].experimentType),

                value: _experiment[index].experimentCompleted,

                onChanged: (bool? isChecked) {

                  setState(() {
                    _experiment[index].experimentCompleted = isChecked ?? false;
                  });

                  // Update the database
                  SQLHelperExperiment.updateExperiment(
                    _experiment[index].id,
                    _experiment[index].experimentName,
                    _experiment[index].experimentType,
                    _experiment[index].experimentReference,
                    _experiment[index].experimentAim,
                    _experiment[index].experimentSerialNumber,
                    _experiment[index].experimentActivityArea,
                    _experiment[index].experimentPurpose,
                    _experiment[index].experimentWebPage,
                    _experiment[index].experimentComment,
                    _experiment[index].experimentCompleted ? 'true' : 'false',
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
                              _showForm(_experiment[index].id),
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
                              _deleteExperiment(_experiment[index].id,
                                  _experiment[index].experimentName),
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
        backgroundColor: Colors.deepOrange,
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

        backgroundColor: Colors.deepOrange,
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

class Experiment {
  int id;
  late String experimentName;
  late String experimentType;
  late String experimentReference;
  late String experimentAim;
  late String experimentSerialNumber;
  late String experimentActivityArea;
  late String experimentPurpose;
  late String experimentWebPage;
  late String experimentComment;
  bool experimentCompleted;

  Experiment({required this.id, required this.experimentName, required this.experimentType,
    required this.experimentReference,
    required this.experimentAim,
    required this.experimentSerialNumber,
    required this.experimentActivityArea,
    required this.experimentPurpose,
    required this.experimentWebPage,
    required this.experimentComment,
    required this.experimentCompleted
  });

  factory Experiment.fromMap(Map<String, dynamic> map) {
    return Experiment(
      id: map['id'] as int,
      experimentName: map['experimentName'] as String,
      experimentType: map['experimentType'] as String,
      experimentReference: map['experimentReference'] as String,
      experimentAim: map['experimentAim'] as String,
      experimentSerialNumber: map['experimentSerialNumber'] as String,
      experimentActivityArea: map['experimentActivityArea'] as String,
      experimentPurpose: map['experimentPurpose'] as String,
      experimentWebPage: map['_experimentWebPage'] != null ? map['_experimentWebPage'] as String : '',
//      experimentWebPage: map['_experimentWebPage'] as String,
      experimentComment: map['experimentComment'] as String,
      experimentCompleted: map['experimentCompleted'] == 'true',
    );
  }
}
