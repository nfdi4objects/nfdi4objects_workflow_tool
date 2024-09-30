import 'package:flutter/material.dart';
import 'main.dart';
import 'sql_institution_copy.dart';
import 'help_institution.dart';
import 'resources.dart';
//import 'camera.dart';
import 'package:flag/flag.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

void main() {
  runApp(const InstitutionForm());
}

class InstitutionForm extends StatelessWidget {
  const InstitutionForm({super.key});

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

//  _InstitutionPageState(this._iExperimentation);
  // This function is used to fetch all data from the database
  void _refreshInstitution() async {
    final data = await SQLInstitution.getItems();
    setState(() {
      _institution = data;
      _isLoading = false;
//      _iExperimentation = false;
    });
  }

  void _onChanged(dynamic val) => debugPrint(val.toString());

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


  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int? id) async {
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
      _iExperimentationController.text = existingInstitution['iExperimentation'];
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
                  controller: _institutionNameController,
                  decoration: const InputDecoration(hintText: 'Institution NAME'),
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
                child: TextField(
                  controller: _institutionCountryController,
                  decoration: const InputDecoration(hintText: 'Institution COUNTRY'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _institutionWebPageController,
                  decoration: const InputDecoration(hintText: 'Institution WEB PAGE'),
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
                        selectedColor: Colors.red,
                        elevation: 5,
                        options: const [
                          FormBuilderChipOption(
                            value: 'iExperimentation',
//                            onSelected: (bool selected) {
//                              setState(() {
//                                _isSelected = selected;
//                              });
//                            },
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

                    onPressed: () async {
                      // Save new institution
                      if (id == null) {
                        await _addItem();
                      }

                      if (id != null) {
                        await _updateItem(id);
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
  Future<void> _addItem() async {
    await SQLInstitution.createItem(
        _institutionNameController.text, _institutionTypeController.text, _institutionStreetController.text, _institutionCityController.text, _institutionCountryController.text, _institutionPostalCodeController.text, _institutionWebPageController.text, _institutionCommentController.text, _iExperimentationController.text);
    _refreshInstitution();
  }

  // Update an existing institution
  Future<void> _updateItem(int id) async {
    await SQLInstitution.updateItem(
        id, _institutionNameController.text, _institutionTypeController.text, _institutionStreetController.text, _institutionCityController.text, _institutionCountryController.text, _institutionPostalCodeController.text, _institutionWebPageController.text, _institutionCommentController.text, _iExperimentationController.text);
    _refreshInstitution();
  }

  // Delete an item
  void _deleteItem(int id) async {
    await SQLInstitution.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Institution deleted!'),
    ));
    _refreshInstitution();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('N4O Workflow Tool: Institution'),
        leading: const Icon(Icons.build),

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
        itemCount: _institution.length,
        itemBuilder: (context, index) => Card(
          color: Colors.red[200],
          margin: const EdgeInsets.all(15),
          child: ListTile(
              title: Text(_institution[index]['institutionName']),
              subtitle: Text(_institution[index]['iExperimentation']),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showForm(_institution[index]['id']),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () =>
                          _deleteItem(_institution[index]['id']),
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