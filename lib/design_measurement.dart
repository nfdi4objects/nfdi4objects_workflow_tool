import 'package:flutter/material.dart';
import 'main.dart';
import 'sql_measurement.dart';
import 'help_measurement.dart';
import 'resources.dart';
import 'package:flag/flag.dart';
//import 'camera.dart';
import 'tasks.dart';

void main() {
  runApp(const MeasurementForm());
}

class MeasurementForm extends StatelessWidget {
  const MeasurementForm({super.key});

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
        title: 'Measurement',
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        home: const MeasurementPage());
  }
}

class MeasurementPage extends StatefulWidget {
  const MeasurementPage({super.key});

  @override
  State<MeasurementPage> createState() => _MeasurementPageState();
}

class _MeasurementPageState extends State<MeasurementPage> {
  List<Measurement> _measurement = [];

  bool _isLoading = true;

//  bool _isChecked = false;

  Future<void> _refreshMeasurement() async {
    setState(() {
      _isLoading = true;
    });

    Future<void> loadMeasurement() async {
      final measurementMaps = await SQLHelperMeasurement.getMeasurements();
      final measurements = measurementMaps.map((map) => Measurement.fromMap(map)).toList();
      setState(() {
        _measurement = measurements;

        _isLoading = false;
      });
    }

    final database = await SQLHelperMeasurement.getMeasurements();

    final List<Map<String, dynamic>> maps = database;

    await Future.delayed(const Duration(milliseconds: 100)); // Add a short delay

    setState(() {
      _measurement = maps.map((map) => Measurement.fromMap(map)).toList();

      _isLoading = false;

    });
  }

  void _testMeasurement() {
    if (_measurement.indexWhere((measurement) => measurement.measurementName == _measurementNameController.text) == -1) {
      setState(() {
        _measurement.add({'measurementName': _measurementNameController.text} as Measurement);

      });
    } else {
      const Text('Name already entered.');
    }
  }

  void _onChanged(dynamic val) => debugPrint(val.toString());

  @override
  void initState() {
    super.initState();

    _refreshMeasurement();
  }

  final _measurementNameController = TextEditingController();
  final _measurementTypeController = TextEditingController();
  final _measurementReferenceController = TextEditingController();
  final _measurementAimController = TextEditingController();
  final _measurementSerialNumberController = TextEditingController();
  final _measurementActivityAreaController = TextEditingController();
  final _measurementPurposeController = TextEditingController();
  final _measurementWebPageController = TextEditingController();
  final _measurementCommentController = TextEditingController();
  final _measurementCompletedController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int? id) async {

//    List<String> initialValues = [];

    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingMeasurement =
      _measurement.firstWhere((element) => element.id == id);
      _measurementNameController.text = existingMeasurement.measurementName;
      _measurementTypeController.text = existingMeasurement.measurementType;
      _measurementReferenceController.text = existingMeasurement.measurementReference;
      _measurementAimController.text = existingMeasurement.measurementAim;
      _measurementSerialNumberController.text = existingMeasurement.measurementSerialNumber;
      _measurementActivityAreaController.text = existingMeasurement.measurementActivityArea;
      _measurementPurposeController.text = existingMeasurement.measurementPurpose;
      _measurementWebPageController.text = existingMeasurement.measurementWebPage;
      _measurementCommentController.text = existingMeasurement.measurementComment;
      _measurementCompletedController.text = existingMeasurement.measurementCompleted ? 'true' : 'false';

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
                'Plan a MEASUREMENT:',
                style: TextStyle(
                    fontSize: 24),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextFormField(
                  controller: _measurementNameController,
                  decoration: const InputDecoration(hintText: 'Measurement NAME'),

                  autovalidateMode: AutovalidateMode.always,
                  validator: (value) {
                    if (_measurement.indexWhere((measurement) => measurement.measurementName == value) != -1) {
                      return 'Must be unique.';
                    }
                    return null;
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _measurementTypeController,
                  decoration: const InputDecoration(hintText: 'Measurement TYPE'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _measurementSerialNumberController,
                  decoration: const InputDecoration(hintText: 'Measurement SERIAL NUMBER (other identifier)'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _measurementReferenceController,
                  decoration: const InputDecoration(hintText: 'WHAT do you want to measure?'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _measurementAimController,
                  decoration: const InputDecoration(hintText: 'WHY do you want to measure this?'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _measurementActivityAreaController,
                  decoration: const InputDecoration(hintText: 'Measurement ACTIVITY Area'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _measurementPurposeController,
                  decoration: const InputDecoration(hintText: 'Measurement PURPOSE'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _measurementWebPageController,
                  decoration: const InputDecoration(hintText: 'Measurement WEB PAGE'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _measurementCommentController,
                  decoration: const InputDecoration(hintText: 'Measurement COMMENT'),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('BACK'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber[200]
                    ),
                    onPressed: () {

                      Navigator.of(context).pop();
                    },
                  ),

                  ElevatedButton.icon(
                    icon: const Icon(Icons.check_box_outlined),
                    label: const Text('TASKS'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber
                    ),

                    onPressed: () async {
                      // Save new measurement
                      if (id == null) {
                        await _addMeasurement();
                      }

                      if (id != null) {
                        _testMeasurement;
                        await _updateMeasurement(id);
                      }

                      String designName = _measurementNameController.text.isNotEmpty
                          ? _measurementNameController.text
                          : 'MEASUREMENT';

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TasksForm(designName: 'Measurement $designName', designColor: Colors.amber, button1color: Colors.amber.shade100, button2color: Colors.amber.shade200, tasks: const [],)),
                      );

                    },
                  ),

                  ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: Text(id == null ? 'SAVE' : 'UPDATE'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber
                    ),
                    onPressed: () async {
                      // Save new measurement
                      if (id == null) {
                        await _addMeasurement();
                      }

                      if (id != null) {
                        _testMeasurement;
                        await _updateMeasurement(id);
                      }

                      // Clear the text fields
                      _measurementNameController.text = '';
                      _measurementTypeController.text = '';
                      _measurementReferenceController.text = '';
                      _measurementAimController.text = '';
                      _measurementSerialNumberController.text = '';
                      _measurementActivityAreaController.text = '';
                      _measurementPurposeController.text = '';
                      _measurementWebPageController.text = '';
                      _measurementCommentController.text = '';

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

// Insert a new measurement to the database
  Future<void> _addMeasurement() async {
    await SQLHelperMeasurement.createMeasurement(
        _measurementNameController.text, _measurementTypeController.text, _measurementReferenceController.text, _measurementAimController.text, _measurementSerialNumberController.text, _measurementActivityAreaController.text, _measurementPurposeController.text, _measurementWebPageController.text, _measurementCommentController.text, _measurementCompletedController.text);
    _refreshMeasurement();
  }

  // Update an existing measurement
  Future<void> _updateMeasurement(id) async {
    await SQLHelperMeasurement.updateMeasurement(
        id, _measurementNameController.text, _measurementTypeController.text, _measurementReferenceController.text, _measurementAimController.text, _measurementSerialNumberController.text, _measurementActivityAreaController.text, _measurementPurposeController.text, _measurementWebPageController.text, _measurementCommentController.text, _measurementCompletedController.text);
    _refreshMeasurement();
  }

  // Delete an item
  void _deleteMeasurement(id, String measurementName) async {
    await SQLHelperMeasurement.deleteMeasurement(id);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('$measurementName deleted!'),
    ));
    _refreshMeasurement();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('N4O Workflow Tool: Measurement Plan'),
        leading: const Icon(Icons.bar_chart),
        backgroundColor: Colors.amber,
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
                    builder: (context) => const HelpMeasurement()),
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
                    builder: (context) => const HelpMeasurement()),
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
                    builder: (context) => const HelpMeasurement()),
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
        itemCount: _measurement.length,

        itemBuilder: (context, index) {
          if (index < _measurement.length) {
            return Card(

              color: Colors.amber[100],
              margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),

              child: CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,

                title: Text(_measurement[index].measurementName),
                subtitle: Text(_measurement[index].measurementType),

                value: _measurement[index].measurementCompleted,

                onChanged: (bool? isChecked) {

                  setState(() {
                    _measurement[index].measurementCompleted = isChecked ?? false;
                  });

                  // Update the database
                  SQLHelperMeasurement.updateMeasurement(
                    _measurement[index].id,
                    _measurement[index].measurementName,
                    _measurement[index].measurementType,
                    _measurement[index].measurementReference,
                    _measurement[index].measurementAim,
                    _measurement[index].measurementSerialNumber,
                    _measurement[index].measurementActivityArea,
                    _measurement[index].measurementPurpose,
                    _measurement[index].measurementWebPage,
                    _measurement[index].measurementComment,
                    _measurement[index].measurementCompleted ? 'true' : 'false',
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
                              _showForm(_measurement[index].id),
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
                              _deleteMeasurement(_measurement[index].id,
                                  _measurement[index].measurementName),
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
        backgroundColor: Colors.amber,
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

        backgroundColor: Colors.amber,
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

class Measurement {
  int id;
  late String measurementName;
  late String measurementType;
  late String measurementReference;
  late String measurementAim;
  late String measurementSerialNumber;
  late String measurementActivityArea;
  late String measurementPurpose;
  late String measurementWebPage;
  late String measurementComment;
  bool measurementCompleted;

  Measurement({required this.id, required this.measurementName, required this.measurementType,
    required this.measurementReference,
    required this.measurementAim,
    required this.measurementSerialNumber,
    required this.measurementActivityArea,
    required this.measurementPurpose,
    required this.measurementWebPage,
    required this.measurementComment,
    required this.measurementCompleted
  });

  factory Measurement.fromMap(Map<String, dynamic> map) {
    return Measurement(
      id: map['id'] as int,
      measurementName: map['measurementName'] as String,
      measurementType: map['measurementType'] as String,
      measurementReference: map['measurementReference'] as String,
      measurementAim: map['measurementAim'] as String,
      measurementSerialNumber: map['measurementSerialNumber'] as String,
      measurementActivityArea: map['measurementActivityArea'] as String,
      measurementPurpose: map['measurementPurpose'] as String,
      measurementWebPage: map['_measurementWebPage'] != null ? map['_measurementWebPage'] as String : '',
//      measurementWebPage: map['_measurementWebPage'] as String,
      measurementComment: map['measurementComment'] as String,
      measurementCompleted: map['measurementCompleted'] == 'true',
    );
  }
}
