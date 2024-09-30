import 'package:flutter/material.dart';
import 'main.dart';
import 'sql_compounds.dart';
import 'help_compounds.dart';
import 'resources.dart';
import 'package:camera/camera.dart' show availableCameras;
import 'camera.dart';
import 'package:flag/flag.dart';

void main() {
  runApp(const CompoundsForm());
}

class CompoundsForm extends StatelessWidget {
  const CompoundsForm({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove the debug banner
        debugShowCheckedModeBanner: false,
        title: 'Compounds',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: const CompoundsPage());
  }
}

class CompoundsPage extends StatefulWidget {
  const CompoundsPage({super.key});

  @override
  State<CompoundsPage> createState() => _CompoundsPageState();
}

class _CompoundsPageState extends State<CompoundsPage> {
  // All compounds
  List<Map<String, dynamic>> _compounds = [];

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshCompounds() async {
    final data = await SQLHelperCompounds.getItems();
    setState(() {
      _compounds = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshCompounds();
  }

  final _compoundNameController = TextEditingController();
  final _compoundTypeController = TextEditingController();
  final _compoundManufacturerController = TextEditingController();
  final _compoundCommentController = TextEditingController();
  final _compoundBinomialController = TextEditingController();


  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingCompound =
      _compounds.firstWhere((element) => element['id'] == id);
      _compoundNameController.text = existingCompound['compoundName'];
      _compoundTypeController.text = existingCompound['compoundType'];
      _compoundManufacturerController.text = existingCompound['compoundManufacturer'];
      _compoundCommentController.text = existingCompound['compoundComment'];
      _compoundBinomialController.text = existingCompound['compoundBinomial'];
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
                  controller: _compoundNameController,
                  decoration: const InputDecoration(hintText: 'Compound NAME'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _compoundTypeController,
                  decoration: const InputDecoration(hintText: 'Compound TYPE'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _compoundManufacturerController,
                  decoration: const InputDecoration(hintText: 'Compound MANUFACTURER'),
                ),
              ),

//              Padding(
//                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
//                child: TextField(
//                  controller: _compoundActivityAreaController,
//                  decoration: const InputDecoration(hintText: 'Compound ACTIVITY Area'),
//                ),
//              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _compoundCommentController,
                  decoration: const InputDecoration(hintText: 'Compound COMMENT'),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('BACK'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent[100],
                    ),
                    onPressed: () {

                      Navigator.of(context).pop();
                    },
                  ),

                  ElevatedButton.icon(
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('PHOTO'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent[100],
                    ),
                    onPressed: () async {
                      String compoundBinomial = (_compoundTypeController.text.isNotEmpty ? '${_compoundTypeController.text} ' : '') + _compoundNameController.text;
                      //save new compound
                      if (id == null) {
                        await _addItem(_compoundNameController.text, _compoundTypeController.text, _compoundBinomialController.text, _compoundCommentController.text, compoundBinomial);
                      }
                      if (id != null) {
                        await _updateItem(id, _compoundNameController.text, _compoundTypeController.text, _compoundBinomialController.text, _compoundCommentController.text, compoundBinomial);
                      }

                      String compoundName = _compoundNameController.text.isNotEmpty
                          ? _compoundNameController.text
                          : 'COMPOUND';

                      String compoundType = _compoundTypeController.text.isNotEmpty
                          ? _compoundTypeController.text
                          : '';

                      String resourceNameMessage = '$compoundType $compoundName';

                      await availableCameras().then((value) => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => CameraApp(cameras: value, resourceName: resourceNameMessage, resourceType: 'compound'))));

                    },
                  ),

                  ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: Text(id == null ? 'SAVE' : 'UPDATE'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent[100],
                    ),
                    onPressed: () async {
                      String compoundBinomial = (_compoundTypeController.text.isNotEmpty ? '${_compoundTypeController.text} ' : '') + _compoundNameController.text;
                      //save new compound
                      if (id == null) {
                        await _addItem(_compoundNameController.text, _compoundTypeController.text, _compoundBinomialController.text, _compoundCommentController.text, compoundBinomial);
                      }
                      if (id != null) {
                        await _updateItem(id, _compoundNameController.text, _compoundTypeController.text, _compoundBinomialController.text, _compoundCommentController.text, compoundBinomial);
                      }
                      
                      // Clear the text fields
                      _compoundNameController.text = '';
                      _compoundTypeController.text = '';
                      _compoundManufacturerController.text = '';
                      _compoundCommentController.text = '';
                      _compoundBinomialController.text = '';
                      // Close the bottom sheet
                      if (!mounted) return;
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),



              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('ADD'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent[100],
                ),
                onPressed: () async {
                  String compoundBinomial = (_compoundTypeController.text.isNotEmpty ? '${_compoundTypeController.text} ' : '') + _compoundNameController.text;
                  if (id == null) {
                    await _addItem(_compoundNameController.text, _compoundTypeController.text, _compoundBinomialController.text, _compoundCommentController.text, compoundBinomial);
                  } else {
                    // Updating an existing task
                    await _updateItem(id, _compoundNameController.text, _compoundTypeController.text, _compoundBinomialController.text, _compoundCommentController.text, compoundBinomial);

                    // Clear the text fields
                    _compoundNameController.text = '';
                    _compoundTypeController.text = '';
                    _compoundManufacturerController.text = '';
                    _compoundCommentController.text = '';
                    _compoundBinomialController.text = '';
                  }

                  if (!mounted) return;

                },
              ),




            ],
          ),
        ));
  }

  Future<void> _addItem(String compoundName, String? compoundType, String? compoundManufacturer, String? compoundComment, String compoundBinomial) async {
    await SQLHelperCompounds.createItem(compoundName, compoundType, compoundManufacturer, compoundComment, compoundBinomial);
    _refreshCompounds();
  }

  Future<void> _updateItem(int id, String compoundName, String? compoundType, String? compoundManufacturer, String? compoundComment, String compoundBinomial) async {
    await SQLHelperCompounds.updateItem(id, compoundName, compoundType, compoundManufacturer, compoundComment, compoundBinomial);
    _refreshCompounds();
  }

  void _deleteItem(int id) async {
    await SQLHelperCompounds.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Compound deleted!'),
    ));
    _refreshCompounds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('N4O Workflow Tool: Compounds'),
        leading: const Icon(Icons.shopping_cart),
        backgroundColor: Colors.deepPurple,
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
                MaterialPageRoute(builder: (context) => const HelpCompounds()),
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
                MaterialPageRoute(builder: (context) => const HelpCompounds()),
              );

            },
          ),

          IconButton(
            icon: const Icon(Icons.help),
            iconSize: 40,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpCompounds()),
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
        itemCount: _compounds.length,
        itemBuilder: (context, index) => Card(
          color: Colors.deepPurpleAccent[100],
          margin: const EdgeInsets.all(15),
          child: ListTile(
              title: Text(_compounds[index]['compoundName']),
              subtitle: Text(_compounds[index]['compoundType']),
              trailing: SizedBox(
                width: 150,
                child: Row(
                  children: [
                    IconButton(
                      iconSize: 30,
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showForm(_compounds[index]['id']),
                    ),
                    const SizedBox(
                      width: 30.0,
                    ),
                    IconButton(
                      iconSize: 30,
                      icon: const Icon(Icons.delete),
                      onPressed: () =>
                          _deleteItem(_compounds[index]['id']),
                    ),
                  ],
                ),
              )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurpleAccent,
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
//                      builder: (context) => const PhotosVideo()),
//                );
//              }
//
//              break;
          }
        },

        backgroundColor: Colors.deepPurpleAccent,
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