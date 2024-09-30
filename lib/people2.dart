import 'package:flutter/material.dart';
import 'main.dart';
import 'sql_personnel2.dart';
import 'help_personnel.dart';
import 'resources.dart';
//import 'camera.dart';
import 'package:flag/flag.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

void main() {
  runApp(const PersonForm(value: true,));
}

class PersonForm extends StatelessWidget {
  final bool value;
  const PersonForm({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove the debug banner
        debugShowCheckedModeBanner: false,
        title: 'Person',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
        ),
        home: const PersonPage());
  }
}

class PersonPage extends StatefulWidget {
  const PersonPage({super.key});

  @override
  State<PersonPage> createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  // All persons
  List<Map<String, dynamic>> _person = [];

  bool _isLoading = true;

  // This function is used to fetch all data from the database
  void _refreshPerson() async {
    final data = await SQLPerson.getItems();
    setState(() {
      _person = data;
      _isLoading = false;
    });
  }

//  void _onChanged(dynamic val) => debugPrint(val.toString());

  @override
  void initState() {
    super.initState();
    _refreshPerson(); // Loading the diary when the app starts
  }

  final TextEditingController _personNameController = TextEditingController();
  final TextEditingController _personPositionController = TextEditingController();
  final TextEditingController _personExperienceController = TextEditingController();
  final TextEditingController _personEmailController = TextEditingController();
  final TextEditingController _personFunctionController = TextEditingController();
  final TextEditingController _personActivityAreaController = TextEditingController();
//  final TextEditingController _personWebPageController = TextEditingController();
  final TextEditingController _personCommentController = TextEditingController();

  final TextEditingController _pExperimentationController = TextEditingController();
  final TextEditingController _pObservationController = TextEditingController();
  final TextEditingController _pMeasurementController = TextEditingController();
  final TextEditingController _pReplicationController = TextEditingController();
  final TextEditingController _pReconstructionController = TextEditingController();
  final TextEditingController _pReenactmentController = TextEditingController();
  final TextEditingController _pRecipeController = TextEditingController();

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

    List<String> initialValues = [];

    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingPerson =
      _person.firstWhere((element) => element['id'] == id);
      _personNameController.text = existingPerson['personName'];
      _personPositionController.text = existingPerson['personPosition'];
      _personExperienceController.text = existingPerson['personExperience'];
      _personEmailController.text = existingPerson['personEmail'];
      _personFunctionController.text = existingPerson['personFunction'];
      _personActivityAreaController.text = existingPerson['personActivityArea'];
//      _personWebPageController.text = existingPerson['personWebPage'];
      _personCommentController.text = existingPerson['personComment'];

      for (var option in options) {
        if (existingPerson[option] == 'true') {
          initialValues.add(option);
        }
      }
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
                  textCapitalization: TextCapitalization.words,
                  controller: _personNameController,
                  decoration: const InputDecoration(hintText: 'Person NAME'),
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

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  textCapitalization: TextCapitalization.words,
                  controller: _personEmailController,
                  decoration: const InputDecoration(hintText: 'Person E-MAIL'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  textCapitalization: TextCapitalization.words,
                  controller: _personExperienceController,
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

              Padding(
                  padding: const EdgeInsets.only(top:10, left:10, right:10),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      const Text("What does your person do?", style: TextStyle(
                          fontSize: 24
                      ),),

                      FormBuilderFilterChip<String>(
                        alignment: WrapAlignment.spaceEvenly,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        name: 'person_function',
                        labelStyle: const TextStyle(fontSize: 24),
                        backgroundColor: Colors.deepOrange[200],
                        selectedColor: Colors.deepOrange,
                        elevation: 5,
                        options: const [
                          FormBuilderChipOption(
                            value: 'pExperimentation',
                            avatar: CircleAvatar(child: Icon(Icons.science_outlined)),
                            child: Text('Experimentation'),
                          ),
                          FormBuilderChipOption(
                            value: 'pObservation',
                            avatar: CircleAvatar(child: Icon(Icons.biotech_outlined)),
                            child: Text('Observation'),
                          ),
                          FormBuilderChipOption(
                            value: 'pMeasurement',
                            avatar: CircleAvatar(child: Icon(Icons.bar_chart)),
                            child: Text('Measurement'),
                          ),
                          FormBuilderChipOption(
                            value: 'pReplication',
                            avatar: CircleAvatar(child: Icon(Icons.content_copy_outlined)),
                            child: Text('Replication'),
                          ),
                          FormBuilderChipOption(
                            value: 'pReconstruction',
                            avatar: CircleAvatar(child: Icon(Icons.foundation)),
                            child: Text('Reconstruction'),
                          ),
                          FormBuilderChipOption(
                            value: 'pReenactment',
                            avatar: CircleAvatar(child: Icon(Icons.theater_comedy_outlined)),
                            child: Text('Reenactment'),
                          ),
                          FormBuilderChipOption(
                            value: 'pRecipe',
                            avatar: CircleAvatar(child: Icon(Icons.restaurant_menu_outlined)),
                            child: Text('Recipe'),
                          ),
                        ],

                        initialValue: initialValues,
                        onChanged: (value) {
                          if (value != null) {
                            if (value.contains('pExperimentation')) {
                              _pExperimentationController.text = 'true';
                            } else {
                              _pExperimentationController.text = 'false';
                            }
                            if (value.contains('pObservation')) {
                              _pObservationController.text = 'true';
                            } else {
                              _pObservationController.text = 'false';
                            }
                            if (value.contains('pMeasurement')) {
                              _pMeasurementController.text = 'true';
                            } else {
                              _pMeasurementController.text = 'false';
                            }
                            if (value.contains('pReplication')) {
                              _pReplicationController.text = 'true';
                            } else {
                              _pReplicationController.text = 'false';
                            }
                            if (value.contains('pReconstruction')) {
                              _pReconstructionController.text = 'true';
                            } else {
                              _pReconstructionController.text = 'false';
                            }
                            if (value.contains('_pReenactment')) {
                              _pReenactmentController.text = 'true';
                            } else {
                              _pReenactmentController.text = 'false';
                            }
                            if (value.contains('pRecipe')) {
                              _pRecipeController.text = 'true';
                            } else {
                              _pRecipeController.text = 'false';
                            }
                          }
                        },

                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.minLength(1,
                            errorText: 'La edad debe ser numérica.',
                          ),
                        ]),
                      ),

                    ],)
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

//          ElevatedButton.icon(
//            icon: const Icon(Icons.camera_alt),
//            label: const Text('PHOTO'),
//            onPressed: () {
//
//              Navigator.push(
//                context,
//                MaterialPageRoute(builder: (context) => PhotosVideo()),
//              );
//
//            },
//          ),

                  ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: Text(id == null ? 'SAVE' : 'UPDATE'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange[200],
                    ),
                    onPressed: () async {
                      // Save new person
                      if (id == null) {
                        await _addItem();
                      }

                      if (id != null) {
                        await _updateItem(id);
                      }

                      // Clear the text fields
                      _personNameController.text = '';
                      _personPositionController.text = '';
                      _personExperienceController.text = '';
                      _personEmailController.text = '';
                      _personFunctionController.text = '';
                      _personActivityAreaController.text = '';
//                      _personWebPageController.text = '';
                      _personCommentController.text = '';

                      _pExperimentationController.text = '';
                      _pObservationController.text = '';
                      _pMeasurementController.text = '';
                      _pReplicationController.text = '';
                      _pReconstructionController.text = '';
                      _pReenactmentController.text = '';
                      _pRecipeController.text = '';

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
  Future<void> _addItem() async {
    await SQLPerson.createItem(
        _personNameController.text, _personPositionController.text, _personExperienceController.text, _personEmailController.text, _personFunctionController.text, _personActivityAreaController.text, _personCommentController.text,
        _pExperimentationController.text, _pObservationController.text, _pMeasurementController.text, _pReplicationController.text, _pReconstructionController.text, _pReenactmentController.text, _pRecipeController.text);
    _refreshPerson();
  }

  // Update an existing person
  Future<void> _updateItem(int id) async {
    await SQLPerson.updateItem(
        id, _personNameController.text, _personPositionController.text, _personExperienceController.text, _personEmailController.text, _personFunctionController.text, _personActivityAreaController.text, _personCommentController.text,
        _pExperimentationController.text, _pObservationController.text, _pMeasurementController.text, _pReplicationController.text, _pReconstructionController.text, _pReenactmentController.text, _pRecipeController.text);
    _refreshPerson();
  }

  // Delete an item
  void _deleteItem(int id) async {
    await SQLPerson.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Person deleted!'),
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
        itemCount: _person.length,
        itemBuilder: (context, index) => Card(
          color: Colors.red[200],
          margin: const EdgeInsets.all(15),
          child: ListTile(
              title: Text(_person[index]['personName']),
              subtitle: Text(_person[index]['personPosition']),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showForm(_person[index]['id']),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () =>
                          _deleteItem(_person[index]['id']),
                    ),
                  ],
                ),
              )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
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
//                      builder: (_) => const PhotosVideo()),
//                );
//              }
//
//              break;

          }
        },

        backgroundColor: Colors.redAccent,
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
