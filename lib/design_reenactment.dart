import 'package:flutter/material.dart';
import 'main.dart';
import 'sql_reenactment.dart';
import 'help_reenactment.dart';
import 'resources.dart';
import 'package:flag/flag.dart';
//import 'camera.dart';
import 'tasks.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';

void main() {
  runApp(const ReenactmentForm());
}

class ReenactmentForm extends StatelessWidget {
  const ReenactmentForm({super.key});

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
        title: 'Reenactment',
        theme: ThemeData(
          primarySwatch: Colors.lime,
        ),
        home: const ReenactmentPage());
  }
}

class ReenactmentPage extends StatefulWidget {
  const ReenactmentPage({super.key});

  @override
  State<ReenactmentPage> createState() => _ReenactmentPageState();
}

class _ReenactmentPageState extends State<ReenactmentPage> {
  List<Reenactment> _reenactment = [];

  bool _isLoading = true;

//  bool _isChecked = false;

  Future<void> _refreshReenactment() async {
    setState(() {
      _isLoading = true;
    });

    Future<void> loadReenactment() async {
      final reenactmentMaps = await SQLHelperReenactment.getReenactments();
      final reenactments = reenactmentMaps.map((map) => Reenactment.fromMap(map)).toList();
      setState(() {
        _reenactment = reenactments;

        _isLoading = false;
      });
    }

    final database = await SQLHelperReenactment.getReenactments();

    final List<Map<String, dynamic>> maps = database;

    await Future.delayed(const Duration(milliseconds: 100)); // Add a short delay

    setState(() {
      _reenactment = maps.map((map) => Reenactment.fromMap(map)).toList();

      _isLoading = false;

    });
  }

  void _testReenactment() {
    if (_reenactment.indexWhere((reenactment) => reenactment.reenactmentName == _reenactmentNameController.text) == -1) {
      setState(() {
        _reenactment.add({'reenactmentName': _reenactmentNameController.text} as Reenactment);

      });
    } else {
      const Text('Name already entered.');
    }
  }

  void _onChanged(dynamic val) => debugPrint(val.toString());

  @override
  void initState() {
    super.initState();

    _refreshReenactment();
  }

  final _reenactmentNameController = TextEditingController();
  final _reenactmentTypeController = TextEditingController();
  final _reenactmentReferenceController = TextEditingController();
  final _reenactmentAimController = TextEditingController();
  final _reenactmentSerialNumberController = TextEditingController();
  final _reenactmentActivityAreaController = TextEditingController();
  final _reenactmentPurposeController = TextEditingController();
  final _reenactmentWebPageController = TextEditingController();
  final _reenactmentCommentController = TextEditingController();
  final _reenactmentCompletedController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int? id) async {

//    List<String> initialValues = [];

    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingReenactment =
      _reenactment.firstWhere((element) => element.id == id);
      _reenactmentNameController.text = existingReenactment.reenactmentName;
      _reenactmentTypeController.text = existingReenactment.reenactmentType;
      _reenactmentReferenceController.text = existingReenactment.reenactmentReference;
      _reenactmentAimController.text = existingReenactment.reenactmentAim;
      _reenactmentSerialNumberController.text = existingReenactment.reenactmentSerialNumber;
      _reenactmentActivityAreaController.text = existingReenactment.reenactmentActivityArea;
      _reenactmentPurposeController.text = existingReenactment.reenactmentPurpose;
      _reenactmentWebPageController.text = existingReenactment.reenactmentWebPage;
      _reenactmentCommentController.text = existingReenactment.reenactmentComment;
      _reenactmentCompletedController.text = existingReenactment.reenactmentCompleted ? 'true' : 'false';

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
                'Plan a REENACTMENT:',
                style: TextStyle(
                    fontSize: 24),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextFormField(
                  controller: _reenactmentNameController,
                  decoration: const InputDecoration(hintText: 'Reenactment NAME'),

                  autovalidateMode: AutovalidateMode.always,
                  validator: (value) {
                    if (_reenactment.indexWhere((reenactment) => reenactment.reenactmentName == value) != -1) {
                      return 'Must be unique.';
                    }
                    return null;
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _reenactmentTypeController,
                  decoration: const InputDecoration(hintText: 'Reenactment TYPE'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _reenactmentSerialNumberController,
                  decoration: const InputDecoration(hintText: 'Reenactment SERIAL NUMBER (other identifier)'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _reenactmentReferenceController,
                  decoration: const InputDecoration(hintText: 'WHAT do you want to reenact?'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _reenactmentAimController,
                  decoration: const InputDecoration(hintText: 'WHY do you want to reenact this?'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _reenactmentActivityAreaController,
                  decoration: const InputDecoration(hintText: 'Reenactment ACTIVITY Area'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _reenactmentPurposeController,
                  decoration: const InputDecoration(hintText: 'Reenactment PURPOSE'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _reenactmentWebPageController,
                  decoration: const InputDecoration(hintText: 'Reenactment WEB PAGE'),
                ),
              ),

              SizedBox(
                height: 350,

//              Padding(
//                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      //        Flexible(
      //            fit: FlexFit.loose,
                  child: DateRangePickerWidget(
//                  maximumDateRangeLength: 10,
//                  minimumDateRangeLength: 3,
                  disabledDates: [DateTime.now().subtract(const Duration(days:1))],
 //                   disabledDates: [DateTime.now().subtract(Duration(days:1))],
    //                disabledDates: (DateTime date) => date.isBefore(DateTime.now().subtract(Duration(days:1))),
                  initialDisplayedDate: DateTime.now(),
                  onDateRangeChanged: print,

                    theme: const CalendarTheme(
                      selectedColor: Colors.blue,
                      dayNameTextStyle: TextStyle(color: Colors.black45, fontSize: 10),
                      inRangeColor: Color(0xFFD9EDFA),
                      inRangeTextStyle: TextStyle(color: Colors.blue),
                      selectedTextStyle: TextStyle(color: Colors.white),
                      todayTextStyle: TextStyle(fontWeight: FontWeight.bold),
                      defaultTextStyle: TextStyle(color: Colors.black, fontSize: 12),
                      radius: 10,
                      tileSize: 40,
                      disabledTextStyle: TextStyle(color: Colors.grey),
                    ),



                  ),
                ),
//              ),



//            Padding(
//              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
//              child: DateRangePickerWidget(
//                doubleMonth: doubleMonth,
//                maximumDateRangeLength: 10,
//                minimumDateRangeLength: 3,
//                initialDateRange: selectedDateRange,
//                disabledDates: [DateTime(2023, 11, 20)],
//                initialDisplayedDate:
//                selectedDateRange?.start ?? DateTime.now(),
//                onDateRangeChanged: onDateRangeChanged,
//              );
//            ),

//           DateRangePickerWidget(
//             doubleMonth: doubleMonth,
//             maximumDateRangeLength: 10,
//             minimumDateRangeLength: 3,
//             initialDateRange: selectedDateRange,
//             disabledDates: [DateTime(2023, 11, 20)],
//             initialDisplayedDate:
//             selectedDateRange?.start ?? DateTime.now(),
//             onDateRangeChanged: onDateRangeChanged,
//           );



//              FormBuilderDateTimePicker(
//                name: 'date',
//                initialEntryMode: DatePickerEntryMode.calendar,
//                initialValue: DateTime.now(),
//                inputType: InputType.date,
//                decoration: InputDecoration(
//                  labelText: 'Planned reenactment DATE',
//                  suffixIcon: IconButton(
//                    icon: const Icon(Icons.close),
//                    onPressed: () {
////                        _formKey.currentState!.fields['date']?.didChange(null);
//                    },
//                  ),
//                ),
////                  initialTime: const TimeOfDay(hour: 8, minute: 0),
//                // locale: const Locale.fromSubtags(languageCode: 'fr'),
//              ),

//                FormBuilderDateRangePicker(
//                  name: 'date_range',
//                  firstDate: DateTime(2024),
//          //        initialValue: DateTimeRange?,
//                  lastDate: DateTime(2050),
//                  format: DateFormat('yyyy-MM-dd'),
//                  onChanged: _onChanged,
//                  decoration: InputDecoration(
//                    labelText: 'Date Range',
//                    helperText: 'Helper text',
//                    hintText: 'Hint text',
//                    suffixIcon: IconButton(
//                      icon: const Icon(Icons.close),
//                      onPressed: () {
//                        _formKey.currentState!.fields['date_range']
//                            ?.didChange(null);
//                      },
//                    ),
//                  ),
//                ),



              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _reenactmentCommentController,
                  decoration: const InputDecoration(hintText: 'Reenactment COMMENT'),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('BACK'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lime[200]
                    ),
                    onPressed: () {

                      Navigator.of(context).pop();
                    },
                  ),

                  ElevatedButton.icon(
                    icon: const Icon(Icons.check_box_outlined),
                    label: const Text('TASKS'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lime
                    ),

                    onPressed: () async {
                      // Save new reenactment
                      if (id == null) {
                        await _addReenactment();
                      }

                      if (id != null) {
                        _testReenactment;
                        await _updateReenactment(id);
                      }

                      String designName = _reenactmentNameController.text.isNotEmpty
                          ? _reenactmentNameController.text
                          : 'REENACTMENT';

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TasksForm(designName: 'Reenactment $designName', designColor: Colors.lime, button1color: Colors.lime.shade100, button2color: Colors.lime.shade200, tasks: const [],)),
                      );

                    },
                  ),

                  ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: Text(id == null ? 'SAVE' : 'UPDATE'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lime
                    ),
                    onPressed: () async {
                      // Save new reenactment
                      if (id == null) {
                        await _addReenactment();
                      }

                      if (id != null) {
                        _testReenactment;
                        await _updateReenactment(id);
                      }

                      // Clear the text fields
                      _reenactmentNameController.text = '';
                      _reenactmentTypeController.text = '';
                      _reenactmentReferenceController.text = '';
                      _reenactmentAimController.text = '';
                      _reenactmentSerialNumberController.text = '';
                      _reenactmentActivityAreaController.text = '';
                      _reenactmentPurposeController.text = '';
                      _reenactmentWebPageController.text = '';
                      _reenactmentCommentController.text = '';

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

// Insert a new reenactment to the database
  Future<void> _addReenactment() async {
    await SQLHelperReenactment.createReenactment(
        _reenactmentNameController.text, _reenactmentTypeController.text, _reenactmentReferenceController.text, _reenactmentAimController.text, _reenactmentSerialNumberController.text, _reenactmentActivityAreaController.text, _reenactmentPurposeController.text, _reenactmentWebPageController.text, _reenactmentCommentController.text, _reenactmentCompletedController.text);
    _refreshReenactment();
  }

  // Update an existing reenactment
  Future<void> _updateReenactment(id) async {
    await SQLHelperReenactment.updateReenactment(
        id, _reenactmentNameController.text, _reenactmentTypeController.text, _reenactmentReferenceController.text, _reenactmentAimController.text, _reenactmentSerialNumberController.text, _reenactmentActivityAreaController.text, _reenactmentPurposeController.text, _reenactmentWebPageController.text, _reenactmentCommentController.text, _reenactmentCompletedController.text);
    _refreshReenactment();
  }

  // Delete an item
  void _deleteReenactment(id, String reenactmentName) async {
    await SQLHelperReenactment.deleteReenactment(id);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('$reenactmentName deleted!'),
    ));
    _refreshReenactment();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('N4O Workflow Tool: Reenactment Plan'),
        leading: const Icon(Icons.theater_comedy_outlined),
        backgroundColor: Colors.lime,
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
                    builder: (context) => const HelpReenactment()),
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
                    builder: (context) => const HelpReenactment()),
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
                    builder: (context) => const HelpReenactment()),
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
        itemCount: _reenactment.length,

        itemBuilder: (context, index) {
          if (index < _reenactment.length) {
            return Card(

              color: Colors.lime[100],
              margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),

              child: CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,

                title: Text(_reenactment[index].reenactmentName),
                subtitle: Text(_reenactment[index].reenactmentType),

                value: _reenactment[index].reenactmentCompleted,

                onChanged: (bool? isChecked) {

                  setState(() {
                    _reenactment[index].reenactmentCompleted = isChecked ?? false;
                  });

                  // Update the database
                  SQLHelperReenactment.updateReenactment(
                    _reenactment[index].id,
                    _reenactment[index].reenactmentName,
                    _reenactment[index].reenactmentType,
                    _reenactment[index].reenactmentReference,
                    _reenactment[index].reenactmentAim,
                    _reenactment[index].reenactmentSerialNumber,
                    _reenactment[index].reenactmentActivityArea,
                    _reenactment[index].reenactmentPurpose,
                    _reenactment[index].reenactmentWebPage,
                    _reenactment[index].reenactmentComment,
                    _reenactment[index].reenactmentCompleted ? 'true' : 'false',
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
                              _showForm(_reenactment[index].id),
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
                              _deleteReenactment(_reenactment[index].id,
                                  _reenactment[index].reenactmentName),
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
        backgroundColor: Colors.lime,
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

        backgroundColor: Colors.lime,
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

  Widget datePickerBuilder(
      BuildContext context, dynamic Function(DateRange?) onDateRangeChanged,
      [bool doubleMonth = true]) =>
      DateRangePickerWidget(
        doubleMonth: doubleMonth,
        maximumDateRangeLength: 10,
        quickDateRanges: [
          QuickDateRange(dateRange: null, label: "Remove date range"),
        ],
        minimumDateRangeLength: 3,
//        initialDateRange: selectedDateRange,
        disabledDates: [DateTime(2023, 11, 20)],
//        initialDisplayedDate:
//        selectedDateRange?.start ?? DateTime(2023, 11, 20),
        onDateRangeChanged: onDateRangeChanged,
        height: 350,
        theme: const CalendarTheme(
          selectedColor: Colors.blue,
          dayNameTextStyle: TextStyle(color: Colors.black45, fontSize: 10),
          inRangeColor: Color(0xFFD9EDFA),
          inRangeTextStyle: TextStyle(color: Colors.blue),
          selectedTextStyle: TextStyle(color: Colors.white),
          todayTextStyle: TextStyle(fontWeight: FontWeight.bold),
          defaultTextStyle: TextStyle(color: Colors.black, fontSize: 12),
          radius: 10,
          tileSize: 40,
          disabledTextStyle: TextStyle(color: Colors.grey),
          quickDateRangeBackgroundColor: Color(0xFFFFF9F9),
          selectedQuickDateRangeColor: Colors.blue,
        ),
      );
}

class Reenactment {
  int id;
  late String reenactmentName;
  late String reenactmentType;
  late String reenactmentReference;
  late String reenactmentAim;
  late String reenactmentSerialNumber;
  late String reenactmentActivityArea;
  late String reenactmentPurpose;
  late String reenactmentWebPage;
  late String reenactmentComment;
  bool reenactmentCompleted;

  Reenactment({required this.id, required this.reenactmentName, required this.reenactmentType,
    required this.reenactmentReference,
    required this.reenactmentAim,
    required this.reenactmentSerialNumber,
    required this.reenactmentActivityArea,
    required this.reenactmentPurpose,
    required this.reenactmentWebPage,
    required this.reenactmentComment,
    required this.reenactmentCompleted
  });

  factory Reenactment.fromMap(Map<String, dynamic> map) {
    return Reenactment(
      id: map['id'] as int,
      reenactmentName: map['reenactmentName'] as String,
      reenactmentType: map['reenactmentType'] as String,
      reenactmentReference: map['reenactmentReference'] as String,
      reenactmentAim: map['reenactmentAim'] as String,
      reenactmentSerialNumber: map['reenactmentSerialNumber'] as String,
      reenactmentActivityArea: map['reenactmentActivityArea'] as String,
      reenactmentPurpose: map['reenactmentPurpose'] as String,
      reenactmentWebPage: map['_reenactmentWebPage'] != null ? map['_reenactmentWebPage'] as String : '',
//      reenactmentWebPage: map['_reenactmentWebPage'] as String,
      reenactmentComment: map['reenactmentComment'] as String,
      reenactmentCompleted: map['reenactmentCompleted'] == 'true',
    );
  }
}
