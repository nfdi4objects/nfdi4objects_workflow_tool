import 'package:flutter/material.dart';
import 'main.dart';
import 'sql_observation.dart';
import 'help_observation.dart';
import 'resources.dart';
import 'package:flag/flag.dart';
//import 'camera.dart';
import 'tasks.dart';

void main() {
  runApp(const ObservationForm());
}

class ObservationForm extends StatelessWidget {
  const ObservationForm({super.key});

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
        title: 'Observation',
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: const ObservationPage());
  }
}

class ObservationPage extends StatefulWidget {
  const ObservationPage({super.key});

  @override
  State<ObservationPage> createState() => _ObservationPageState();
}

class _ObservationPageState extends State<ObservationPage> {
  List<Observation> _observation = [];

  bool _isLoading = true;

//  bool _isChecked = false;

  Future<void> _refreshObservation() async {
    setState(() {
      _isLoading = true;
    });

    Future<void> loadObservation() async {
      final observationMaps = await SQLHelperObservation.getObservations();
      final observations = observationMaps.map((map) => Observation.fromMap(map)).toList();
      setState(() {
        _observation = observations;

        _isLoading = false;
      });
    }

    final database = await SQLHelperObservation.getObservations();

    final List<Map<String, dynamic>> maps = database;

    await Future.delayed(const Duration(milliseconds: 100)); // Add a short delay

    setState(() {
      _observation = maps.map((map) => Observation.fromMap(map)).toList();

      _isLoading = false;

    });
  }

  void _testObservation() {
    if (_observation.indexWhere((observation) => observation.observationName == _observationNameController.text) == -1) {
      setState(() {
        _observation.add({'observationName': _observationNameController.text} as Observation);

      });
    } else {
      const Text('Name already entered.');
    }
  }

  void _onChanged(dynamic val) => debugPrint(val.toString());

  @override
  void initState() {
    super.initState();

    _refreshObservation();
  }

  final _observationNameController = TextEditingController();
  final _observationTypeController = TextEditingController();
  final _observationReferenceController = TextEditingController();
  final _observationAimController = TextEditingController();
  final _observationSerialNumberController = TextEditingController();
  final _observationActivityAreaController = TextEditingController();
  final _observationPurposeController = TextEditingController();
  final _observationWebPageController = TextEditingController();
  final _observationCommentController = TextEditingController();
  final _observationCompletedController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int? id) async {

//    List<String> initialValues = [];

    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingObservation =
      _observation.firstWhere((element) => element.id == id);
      _observationNameController.text = existingObservation.observationName;
      _observationTypeController.text = existingObservation.observationType;
      _observationReferenceController.text = existingObservation.observationReference;
      _observationAimController.text = existingObservation.observationAim;
      _observationSerialNumberController.text = existingObservation.observationSerialNumber;
      _observationActivityAreaController.text = existingObservation.observationActivityArea;
      _observationPurposeController.text = existingObservation.observationPurpose;
      _observationWebPageController.text = existingObservation.observationWebPage;
      _observationCommentController.text = existingObservation.observationComment;
      _observationCompletedController.text = existingObservation.observationCompleted ? 'true' : 'false';

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
                'Plan a OBSERVATION:',
                style: TextStyle(
                    fontSize: 24),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextFormField(
                  controller: _observationNameController,
                  decoration: const InputDecoration(hintText: 'Observation NAME'),

                  autovalidateMode: AutovalidateMode.always,
                  validator: (value) {
                    if (_observation.indexWhere((observation) => observation.observationName == value) != -1) {
                      return 'Must be unique.';
                    }
                    return null;
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _observationTypeController,
                  decoration: const InputDecoration(hintText: 'Observation TYPE'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _observationSerialNumberController,
                  decoration: const InputDecoration(hintText: 'Observation SERIAL NUMBER (other identifier)'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _observationReferenceController,
                  decoration: const InputDecoration(hintText: 'WHAT do you want to observe?'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _observationAimController,
                  decoration: const InputDecoration(hintText: 'WHY do you want to observe this?'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _observationActivityAreaController,
                  decoration: const InputDecoration(hintText: 'Observation ACTIVITY Area'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _observationPurposeController,
                  decoration: const InputDecoration(hintText: 'Observation PURPOSE'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _observationWebPageController,
                  decoration: const InputDecoration(hintText: 'Observation WEB PAGE'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _observationCommentController,
                  decoration: const InputDecoration(hintText: 'Observation COMMENT'),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('BACK'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[200]
                    ),
                    onPressed: () {

                      Navigator.of(context).pop();
                    },
                  ),

                  ElevatedButton.icon(
                    icon: const Icon(Icons.check_box_outlined),
                    label: const Text('TASKS'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange
                    ),

                    onPressed: () async {
                      // Save new observation
                      if (id == null) {
                        await _addObservation();
                      }

                      if (id != null) {
                        _testObservation;
                        await _updateObservation(id);
                      }

                      String designName = _observationNameController.text.isNotEmpty
                          ? _observationNameController.text
                          : 'OBSERVATION';

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TasksForm(designName: 'Observation $designName', designColor: Colors.orange, button1color: Colors.orange.shade100, button2color: Colors.orange.shade200, tasks: const [],)),
                      );

                    },
                  ),

                  ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: Text(id == null ? 'SAVE' : 'UPDATE'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange
                    ),
                    onPressed: () async {
                      // Save new observation
                      if (id == null) {
                        await _addObservation();
                      }

                      if (id != null) {
                        _testObservation;
                        await _updateObservation(id);
                      }

                      // Clear the text fields
                      _observationNameController.text = '';
                      _observationTypeController.text = '';
                      _observationReferenceController.text = '';
                      _observationAimController.text = '';
                      _observationSerialNumberController.text = '';
                      _observationActivityAreaController.text = '';
                      _observationPurposeController.text = '';
                      _observationWebPageController.text = '';
                      _observationCommentController.text = '';

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

// Insert a new observation to the database
  Future<void> _addObservation() async {
    await SQLHelperObservation.createObservation(
        _observationNameController.text, _observationTypeController.text, _observationReferenceController.text, _observationAimController.text, _observationSerialNumberController.text, _observationActivityAreaController.text, _observationPurposeController.text, _observationWebPageController.text, _observationCommentController.text, _observationCompletedController.text);
    _refreshObservation();
  }

  // Update an existing observation
  Future<void> _updateObservation(id) async {
    await SQLHelperObservation.updateObservation(
        id, _observationNameController.text, _observationTypeController.text, _observationReferenceController.text, _observationAimController.text, _observationSerialNumberController.text, _observationActivityAreaController.text, _observationPurposeController.text, _observationWebPageController.text, _observationCommentController.text, _observationCompletedController.text);
    _refreshObservation();
  }

  // Delete an item
  void _deleteObservation(id, String observationName) async {
    await SQLHelperObservation.deleteObservation(id);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('$observationName deleted!'),
    ));
    _refreshObservation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('N4O Workflow Tool: Observation Plan'),
        leading: const Icon(Icons.biotech),
        backgroundColor: Colors.orange,
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
                    builder: (context) => const HelpObservation()),
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
                    builder: (context) => const HelpObservation()),
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
                    builder: (context) => const HelpObservation()),
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
        itemCount: _observation.length,

        itemBuilder: (context, index) {
          if (index < _observation.length) {
            return Card(

              color: Colors.orange[100],
              margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),

              child: CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,

                title: Text(_observation[index].observationName),
                subtitle: Text(_observation[index].observationType),

                value: _observation[index].observationCompleted,

                onChanged: (bool? isChecked) {

                  setState(() {
                    _observation[index].observationCompleted = isChecked ?? false;
                  });

                  // Update the database
                  SQLHelperObservation.updateObservation(
                    _observation[index].id,
                    _observation[index].observationName,
                    _observation[index].observationType,
                    _observation[index].observationReference,
                    _observation[index].observationAim,
                    _observation[index].observationSerialNumber,
                    _observation[index].observationActivityArea,
                    _observation[index].observationPurpose,
                    _observation[index].observationWebPage,
                    _observation[index].observationComment,
                    _observation[index].observationCompleted ? 'true' : 'false',
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
                              _showForm(_observation[index].id),
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
                              _deleteObservation(_observation[index].id,
                                  _observation[index].observationName),
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
        backgroundColor: Colors.orange,
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

        backgroundColor: Colors.orange,
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

class Observation {
  int id;
  late String observationName;
  late String observationType;
  late String observationReference;
  late String observationAim;
  late String observationSerialNumber;
  late String observationActivityArea;
  late String observationPurpose;
  late String observationWebPage;
  late String observationComment;
  bool observationCompleted;

  Observation({required this.id, required this.observationName, required this.observationType,
    required this.observationReference,
    required this.observationAim,
    required this.observationSerialNumber,
    required this.observationActivityArea,
    required this.observationPurpose,
    required this.observationWebPage,
    required this.observationComment,
    required this.observationCompleted
  });

  factory Observation.fromMap(Map<String, dynamic> map) {
    return Observation(
      id: map['id'] as int,
      observationName: map['observationName'] as String,
      observationType: map['observationType'] as String,
      observationReference: map['observationReference'] as String,
      observationAim: map['observationAim'] as String,
      observationSerialNumber: map['observationSerialNumber'] as String,
      observationActivityArea: map['observationActivityArea'] as String,
      observationPurpose: map['observationPurpose'] as String,
      observationWebPage: map['_observationWebPage'] != null ? map['_observationWebPage'] as String : '',
//      observationWebPage: map['_observationWebPage'] as String,
      observationComment: map['observationComment'] as String,
      observationCompleted: map['observationCompleted'] == 'true',
    );
  }
}
