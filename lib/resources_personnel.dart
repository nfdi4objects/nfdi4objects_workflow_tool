import 'package:flutter/material.dart';
import 'main.dart';
import 'sql_personnel.dart';
import 'help_personnel.dart';
import 'resources.dart';
//import 'camera.dart';
import 'package:flag/flag.dart';
//import 'dart:developer';

void main() {
  if ('institutionNameOut' != null) {
    runApp(const PersonForm(people: [], institutionNameOut: 'institutionNameOut'));
  } else {
    runApp(const PersonForm(people: [], institutionNameOut: ''));
  }
}

class PersonForm extends StatelessWidget {
  final List<Person> people;
  final String institutionNameOut;

  const PersonForm({super.key, required this.people, required this.institutionNameOut});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove the debug banner
        debugShowCheckedModeBanner: false,
        title: 'Person',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
        ),
        home:  PersonPage(people: const [], institutionNameOut: institutionNameOut,));
  }
}

class PersonPage extends StatefulWidget {
  final String institutionNameOut;
  final List<Person> people;
  const PersonPage({super.key, required this.people, required this.institutionNameOut});

  @override
  State<PersonPage> createState() => _PersonPageState(institutionNameOut: institutionNameOut);
}

class _PersonPageState extends State<PersonPage> {
  final String institutionNameOut;
  _PersonPageState({required this.institutionNameOut});

//  List<Person> person = [];

  // All persons
  List<Map<String, dynamic>> people = [];

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshPerson() async {
    final data = await SQLPerson.getPersons(institutionNameOut);
    setState(() {
      people = data;
      _isLoading = false;
    });
  }

  get index => null;

  @override
  void initState() {
    super.initState();
    _refreshPerson();
  }
  
  final _institutionNameOutController = TextEditingController();
  final _personNameController = TextEditingController();
  final _personPositionController = TextEditingController();
  final _personExperienceController = TextEditingController();
  final _personEmailController = TextEditingController();
  final _personActivityAreaController = TextEditingController();
  final _personFunctionController = TextEditingController();
  final _personCommentController = TextEditingController();

  final _pExperimentationController = TextEditingController();
  final _pObservationController = TextEditingController();
  final _pMeasurementController = TextEditingController();
  final _pReplicationController = TextEditingController();
  final _pReconstructionController = TextEditingController();
  final _pReenactmentController = TextEditingController();
  final _pRecipeController = TextEditingController();
  
  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int? id) async {
    List<String> options = [
      'pExperimentation',
      'pObservation',
      'pMeasurement',
      'pReplication',
      'pReconstruction',
      'pReenactment',
      'pRecipe',
    ];
    
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingPerson =
      people.firstWhere((element) => element['id'] == id);
      _personNameController.text = existingPerson['personName'];
      _personPositionController.text = existingPerson['personPosition'];
      _personExperienceController.text = existingPerson['personExperience'];
      _personEmailController.text = existingPerson['personEmail'];
      _personActivityAreaController.text = existingPerson['personActivityArea']; 
      _personFunctionController.text = existingPerson['personFunction'];
      _personCommentController.text = existingPerson['personComment'];
      _institutionNameOutController.text = institutionNameOut;
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
                child: TextFormField(
                  textCapitalization: TextCapitalization.words,
                  controller: _personNameController,
                  decoration: const InputDecoration(hintText: 'Person NAME'),

                  validator: (value) {
                    if (people.indexWhere((people) => people['personName'] == value) != -1) {
                      return 'Must be unique.';
                    }
                    return null;
                  },

                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _personPositionController,
                  decoration: const InputDecoration(hintText: 'Person POSITION'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _personExperienceController,
                  decoration: const InputDecoration(hintText: 'Person EXPERIENCE'),
                ),
              ),

              //              Padding(
//                  padding: const EdgeInsets.only(top:10, left:10, right:10),
//
//                  child: Column(
//                    crossAxisAlignment: CrossAxisAlignment.center,
//                    children: [
//
////                    const Text("What is your level of experience?", style: TextStyle(
////                        fontSize: 24
////                    ),),
//
//                    FormBuilderFilterChip<String>(
//                        alignment: WrapAlignment.spaceEvenly,
//                        autovalidateMode: AutovalidateMode.onUserInteraction,
//                        decoration: const InputDecoration(
//                            labelText: 'What is your level of experience?'),
//                        name: 'person_experience',
//                        labelStyle: const TextStyle(fontSize: 24),
//                        selectedColor: Colors.red,
//                        elevation: 5,
//                        options: const [
//
//                          FormBuilderChipOption(
//                            value: 'None',
//                            avatar: CircleAvatar(child: Text('1')),
//                          ),
//                          FormBuilderChipOption(
//                            value: 'Beginner',
//                            avatar: CircleAvatar(child: Text('2')),
//                          ),
//                          FormBuilderChipOption(
//                            value: 'Experienced',
//                            avatar: CircleAvatar(child: Text('3')),
//                          ),
//                          FormBuilderChipOption(
//                            value: 'Expert',
//                            avatar: CircleAvatar(child: Text('4')),
////                            onChanged: _onChanged,
////                           validator: FormBuilderValidators.compose([
////                             FormBuilderValidators.minLength(1),
////                             FormBuilderValidators.maxLength(3),
////                           ]),
//                          ),
//                        ],
//                    ),
//                ],
//                  ),
//              ),
              
              
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _personEmailController,
                  decoration: const InputDecoration(hintText: 'Person E-MAIL'),
//                  onChanged: (value) {
//                    if (Validate.isEmail(value)) {
//                      log("Valid e-mail");
//                    } else {
//                      return("Email not valid");
//                    }
//                    },
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _personFunctionController,
                  decoration: const InputDecoration(hintText: 'Person FUNCTION'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _personActivityAreaController,
                  decoration: const InputDecoration(hintText: 'Person ACTIVITY Area'),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _personCommentController,
                  decoration: const InputDecoration(hintText: 'Person COMMENT'),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('BACK'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange[200],
                    ),
                    onPressed: () {

                      Navigator.of(context).pop();
                    },
                  ),

//                  ElevatedButton.icon(
//                    icon: const Icon(Icons.camera_alt),
//                    label: const Text('PHOTO'),
//                    style: ElevatedButton.styleFrom(
//                      backgroundColor: Colors.deepOrange[200],
//                    ),
//                    onPressed: () async {
//                      // Save new person
//                      if (id == null) {
//                        await _addPerson();
//                      }
//
//                      if (id != null) {
//                        await _updatePerson(id);
//                      }
//
//                      String personName = _personNameController.text.isNotEmpty
//                          ? _personNameController.text
//                          : 'PERSON';
//
//                      String personPosition = _personPositionController.text.isNotEmpty
//                          ? _personPositionController.text
//                          : '';
//
//                      String resourceNameMessage = '$personPosition $personName';
//
////                      await availableCameras().then((value) => Navigator.push(context,
////                          MaterialPageRoute(builder: (_) => CameraApp(cameras: value, resourceName: resourceNameMessage, resourceType: 'person'))));
//
//                    },
//                  ),

                  ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: Text(id == null ? 'SAVE' : 'UPDATE'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange[200],
                    ),
                    onPressed: () async {
                      // Save new person
                      if (id == null) {
                        await _addPerson();
                      }

                      if (id != null) {
                        await _updatePerson(id);
                      }

                      // Clear the text fields
                      _personNameController.text = '';
                      _personPositionController.text = '';
                      _personExperienceController.text = '';
                      _personEmailController.text = '';
                      _personActivityAreaController.text = '';
                      _personFunctionController.text = '';
                      _personCommentController.text = '';

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

// Insert a new person to the database
  Future<void> _addPerson() async {
    await SQLPerson.createPerson(
        _institutionNameOutController.text,
        _personNameController.text, _personPositionController.text, _personExperienceController.text, _personEmailController.text, _personFunctionController.text, _personActivityAreaController.text, _personCommentController.text,
        _pExperimentationController.text, _pObservationController.text, _pMeasurementController.text, _pReplicationController.text, _pReconstructionController.text, _pReenactmentController.text, _pRecipeController.text);
    _refreshPerson();
  }

  // Update an existing person
  Future<void> _updatePerson(int id) async {
    await SQLPerson.updatePerson(
        id, _institutionNameOutController.text,
        _personNameController.text, _personPositionController.text, _personExperienceController.text, _personEmailController.text, _personFunctionController.text, _personActivityAreaController.text, _personCommentController.text,
        _pExperimentationController.text, _pObservationController.text, _pMeasurementController.text, _pReplicationController.text, _pReconstructionController.text, _pReenactmentController.text, _pRecipeController.text);
    _refreshPerson();
  }

  // Delete an item
  void _deletePerson(int id, String personName) async {
    await SQLPerson.deletePerson(id);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('$personName deleted!'),
    ));
    _refreshPerson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('N4O Workflow Tool: Person'),
        leading: const Icon(Icons.person),
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
                MaterialPageRoute(builder: (context) => const HelpPersonnel()),
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
                MaterialPageRoute(builder: (context) => const HelpPersonnel()),
              );

            },
          ),

          IconButton(
            icon: const Icon(Icons.help),
            iconSize: 40,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpPersonnel()),
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
        itemCount: people.length,
        itemBuilder: (context, index) => Card(
          color: Colors.deepOrange[200],
          margin: const EdgeInsets.all(15),
          child: ListTile(
              title: Text(people[index]['personName']),
              subtitle: Text(people[index]['personPosition']),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                      iconSize: 30,
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showForm(people[index]['id']),
                    ),
                    const SizedBox(
                      width: 30.0,
                    ),
                    IconButton(
                      iconSize: 30,
                      icon: const Icon(Icons.delete),
                      onPressed: () =>
                          _deletePerson(people[index]['id'], people[index]['personName']),
                    ),
                  ],
                ),
              )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrangeAccent,
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

//            case 1:
//              {
//                setState(() {
//                  compoundIndex = 1;
//                });
//                Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                      builder: (_) => ImportPerson(storage: PersonImport()),
//                    ));
//              }
//
//              break;

            case 2:
              {
                setState(() {
                  compoundIndex = 2;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NFDIexperimentApp()),
                );
              }

              break;

          }
        },

        backgroundColor: Colors.deepOrangeAccent,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_back,
                color: Colors.white),
            label: 'Resources',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.import_contacts,
                color: Colors.white),
            label: 'Import',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home,
                color: Colors.white),
            label: 'Home',
          ),

        ],
      ),

    );
  }
}

class Person {
  Person ({required this.institutionNameOut, required this.personName, required this.personPosition, required this.personExperience, required this.personEmail, required this.personFunction, required this.personActivityArea, required this.personComment,
    required this.pExperimentation, required this.pObservation, required this.pMeasurement, required this.pReplication, required this.pReconstruction, required this.pReenactment, required this.pRecipe});
  String institutionNameOut;
  String personName;
  String? personPosition;
  String? personExperience;
  String? personEmail;
  String? personFunction;
  String? personActivityArea;
  String? personComment;

  String? pExperimentation;
  String? pObservation;
  String? pMeasurement;
  String? pReplication;
  String? pReconstruction;
  String? pReenactment;
  String? pRecipe;
}