import 'package:flutter/material.dart';
import 'main.dart';
import 'sql_institution.dart';
import 'help_institution.dart';
import 'resources.dart';
import 'resources_personnel.dart';
import 'package:flag/flag.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';


void main() {
  runApp(const InstitutionForm(value: true,));
}

class InstitutionForm extends StatelessWidget {
  final bool value;
  const InstitutionForm({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove the debug banner
        debugShowCheckedModeBanner: false,
        title: 'Institution',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: const InstitutionPage());
  }
}

class InstitutionPage extends StatefulWidget {
  const InstitutionPage({super.key});

  @override
  State<InstitutionPage> createState() => _InstitutionPageState();
}

class _InstitutionPageState extends State<InstitutionPage> {
  // All institutions
  List<Map<String, dynamic>> _institution = [];

  bool _isLoading = true;

  // This function is used to fetch all data from the database
  void _refreshInstitution() async {
    final data = await SQLInstitution.getInstitutions();
    setState(() {
      _institution = data;
      _isLoading = false;
    });
  }

  Future<void> _addInstitution() async {
    await SQLInstitution.createInstitution(
      _institutionNameController.text,
      _institutionTypeController.text,
      _institutionStreetController.text,
      _institutionCityController.text,
      _institutionCountryController.text,
      _institutionPostalCodeController.text,
      _institutionWebPageController.text,
      _institutionCommentController.text,

      _iExperimentationController.text,
      _iObservationController.text,
      _iMeasurementController.text,
      _iReplicationController.text,
      _iReconstructionController.text,
      _iReenactmentController.text,
      _iRecipeController.text,
    );
    _refreshInstitution();
  }

//  void _onChanged(dynamic val) => debugPrint(val.toString());

  @override
  void initState() {
    super.initState();
    _refreshInstitution(); // Loading the diary when the app starts
  }

  final TextEditingController _institutionNameController = TextEditingController();
  final TextEditingController _institutionTypeController = TextEditingController();
  final TextEditingController _institutionStreetController = TextEditingController();
  final TextEditingController _institutionCityController = TextEditingController();
  final TextEditingController _institutionCountryController = TextEditingController();
  final TextEditingController _institutionPostalCodeController = TextEditingController();
  final TextEditingController _institutionWebPageController = TextEditingController();
  final TextEditingController _institutionCommentController = TextEditingController();

  final TextEditingController _iExperimentationController = TextEditingController();
  final TextEditingController _iObservationController = TextEditingController();
  final TextEditingController _iMeasurementController = TextEditingController();
  final TextEditingController _iReplicationController = TextEditingController();
  final TextEditingController _iReconstructionController = TextEditingController();
  final TextEditingController _iReenactmentController = TextEditingController();
  final TextEditingController _iRecipeController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int? id) async {
    List<String> options = [
      'iExperimentation',
      'iObservation',
      'iMeasurement',
      'iReplication',
      'iReconstruction',
      'iReenactment',
      'iRecipe',
    ];

    List<String> initialValues = [];

    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingInstitution =
      _institution.firstWhere((element) => element['id'] == id);
      _institutionNameController.text = existingInstitution['institutionName'];
      _institutionTypeController.text = existingInstitution['institutionType'];
      _institutionStreetController.text = existingInstitution['institutionStreet'];
      _institutionCityController.text = existingInstitution['institutionCity'];
      _institutionCountryController.text = existingInstitution['institutionCountry'];
      _institutionPostalCodeController.text = existingInstitution['institutionPostalCode'];
      _institutionWebPageController.text = existingInstitution['institutionWebPage'];
      _institutionCommentController.text = existingInstitution['institutionComment'];

      for (var option in options) {
        if (existingInstitution[option] == 'true') {
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
                child: TextFormField(
                  textCapitalization: TextCapitalization.words,
                  controller: _institutionNameController,
                  decoration: const InputDecoration(hintText: 'Institution NAME'),


                  validator: (value) {
                    if (_institution.indexWhere((institution) => institution['institutionName'] == value) != -1) {
                      return 'Must be unique.';
                    }
                    return null;
                  },
                  
     //             autovalidateMode: AutovalidateMode.always,
     //             validator: FormBuilderValidators.compose([
     //               FormBuilderValidators.unique(
     //                 'institutionName' as List<String>,
     //               errorText: 'Must be unique.',
     //               ),
     //             ]),

                ),

              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _institutionTypeController,
                  decoration: const InputDecoration(hintText: 'Institution TYPE'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  textCapitalization: TextCapitalization.words,
                  controller: _institutionStreetController,
                  decoration: const InputDecoration(hintText: 'Institution STREET Address'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  textCapitalization: TextCapitalization.words,
                  controller: _institutionCityController,
                  decoration: const InputDecoration(hintText: 'Institution CITY or TOWN'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _institutionPostalCodeController,
                  decoration: const InputDecoration(hintText: 'Institution POSTAL CODE'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextFormField(
                  controller: _institutionCountryController,
                  decoration: const InputDecoration(hintText: 'Institution COUNTRY'),

                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.country(
                      errorText: 'Enter a country.',
                    ),
                  ]),

                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextFormField(
                  controller: _institutionWebPageController,
                  decoration: const InputDecoration(hintText: 'Institution WEB PAGE'),

                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.url(
                      errorText: 'Enter a URL.',
                    ),
                  ]),

                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _institutionCommentController,
                  decoration: const InputDecoration(hintText: 'Institution COMMENT'),
                ),
              ),

              Padding(
                  padding: const EdgeInsets.only(top:10, left:10, right:10),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      const Text("What does your institution do?", style: TextStyle(
                          fontSize: 24
                      ),),

                      FormBuilderFilterChip<String>(
                        alignment: WrapAlignment.spaceEvenly,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        name: 'institution_function',
                        labelStyle: const TextStyle(fontSize: 24),
                        backgroundColor: Colors.red[200],
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
                          FormBuilderChipOption(
                            value: 'iRecipe',
                            avatar: CircleAvatar(child: Icon(Icons.restaurant_menu_outlined)),
                            child: Text('Recipe'),
                          ),
                        ],

                        initialValue: initialValues,
                        onChanged: (value) {
                          if (value != null) {
                            if (value.contains('iExperimentation')) {
                              _iExperimentationController.text = 'true';
                            } else {
                              _iExperimentationController.text = 'false';
                            }
                            if (value.contains('iObservation')) {
                              _iObservationController.text = 'true';
                            } else {
                              _iObservationController.text = 'false';
                            }
                            if (value.contains('iMeasurement')) {
                              _iMeasurementController.text = 'true';
                            } else {
                              _iMeasurementController.text = 'false';
                            }
                            if (value.contains('iReplication')) {
                              _iReplicationController.text = 'true';
                            } else {
                              _iReplicationController.text = 'false';
                            }
                            if (value.contains('iReconstruction')) {
                              _iReconstructionController.text = 'true';
                            } else {
                              _iReconstructionController.text = 'false';
                            }
                            if (value.contains('_iReenactment')) {
                              _iReenactmentController.text = 'true';
                            } else {
                              _iReenactmentController.text = 'false';
                            }
                            if (value.contains('iRecipe')) {
                              _iRecipeController.text = 'true';
                            } else {
                              _iRecipeController.text = 'false';
                            }
                          }
                        },

                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.minLength(1,
                            errorText: 'Choose at least one.',
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
                      backgroundColor: Colors.red[200],
                    ),
                    onPressed: () {

                      Navigator.of(context).pop();
                    },
                  ),

                  ElevatedButton.icon(
                    icon: const Icon(Icons.person),
                    label: const Text('PERSONNEL'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[200],
                    ),

                    onPressed: () async {
                      // Save new institution
                      if (id == null) {
                        await _addInstitution();
                      }

                      if (id != null) {
                        _testInstitution;
                        await _updateInstitution(id);
                      }

                      String institutionNameOut = _institutionNameController.text.isNotEmpty
                          ? _institutionNameController.text
                          : 'PERSONNEL';

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PersonForm(institutionNameOut: institutionNameOut, people: const [],)),

                      );

                    },
                  ),
                  
                  ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: Text(id == null ? 'SAVE' : 'UPDATE'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[200],
                    ),
                    onPressed: () async {
                      // Save new institution
                      if (id == null) {
                        await _addInstitution();
                      }

                      if (id != null) {
                        _testInstitution;
                        await _updateInstitution(id);
                      }

                      // Clear the text fields
                      _institutionNameController.text = '';
                      _institutionTypeController.text = '';
                      _institutionStreetController.text = '';
                      _institutionCityController.text = '';
                      _institutionCountryController.text = '';
                      _institutionPostalCodeController.text = '';
                      _institutionWebPageController.text = '';
                      _institutionCommentController.text = '';

                      _iExperimentationController.text = '';
                      _iObservationController.text = '';
                      _iMeasurementController.text = '';
                      _iReplicationController.text = '';
                      _iReconstructionController.text = '';
                      _iReenactmentController.text = '';
                      _iRecipeController.text = '';

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

// Insert a new institution to the database
  Future<void> _testInstitution() async {
    await SQLInstitution.createInstitution(
        _institutionNameController.text, _institutionTypeController.text, _institutionStreetController.text, _institutionCityController.text, _institutionCountryController.text, _institutionPostalCodeController.text, _institutionWebPageController.text, _institutionCommentController.text,
        _iExperimentationController.text, _iObservationController.text, _iMeasurementController.text, _iReplicationController.text, _iReconstructionController.text, _iReenactmentController.text, _iRecipeController.text);
    _refreshInstitution();
  }

  // Update an existing institution
  Future<void> _updateInstitution(int id) async {
    await SQLInstitution.updateInstitution(
        id, _institutionNameController.text, _institutionTypeController.text, _institutionStreetController.text, _institutionCityController.text, _institutionCountryController.text, _institutionPostalCodeController.text, _institutionWebPageController.text, _institutionCommentController.text,
        _iExperimentationController.text, _iObservationController.text, _iMeasurementController.text, _iReplicationController.text, _iReconstructionController.text, _iReenactmentController.text, _iRecipeController.text);
    _refreshInstitution();
  }

  // Delete an item
  void _deleteInstitution(int id, String institutionName) async {
    await SQLInstitution.deleteInstitution(id);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('$institutionName deleted!'),
    ));
    _refreshInstitution();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('N4O Workflow Tool: Institution'),
        leading: const Icon(Icons.account_balance),
        backgroundColor: Colors.red,
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
                MaterialPageRoute(builder: (context) => const HelpInstitution()),
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
                MaterialPageRoute(builder: (context) => const HelpInstitution()),
              );

            },
          ),

          IconButton(
            icon: const Icon(Icons.help),
            iconSize: 40,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpInstitution()),
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
        itemCount: _institution.length,
        itemBuilder: (context, index) => Card(
          color: Colors.red[200],
          margin: const EdgeInsets.all(15),
          child: ListTile(
              title: Text(_institution[index]['institutionName']),
              subtitle: Text(_institution[index]['institutionType']),
              trailing: SizedBox(
                width: 150,
                child: Row(
                  children: [
                    IconButton(
                      iconSize: 30,
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showForm(_institution[index]['id']),
                    ),
                    const SizedBox(
                      width: 30.0,
                    ),
                    IconButton(
                      iconSize: 30,
                      icon: const Icon(Icons.delete),
                      onPressed: () =>
                          _deleteInstitution(_institution[index]['id'], _institution[index]['institutionName']),
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
