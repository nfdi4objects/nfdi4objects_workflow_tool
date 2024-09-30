import 'package:flutter/material.dart';
import 'main.dart';
import 'sql_substances.dart';
import 'help_substances.dart';
import 'resources.dart';
import 'package:camera/camera.dart' show availableCameras;
import 'camera.dart';
import 'package:flag/flag.dart';

void main() {
  runApp(const SubstancesForm());
}

class SubstancesForm extends StatelessWidget {
  const SubstancesForm({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove the debug banner
        debugShowCheckedModeBanner: false,
        title: 'Substances',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: const SubstancesPage());
  }
}

class SubstancesPage extends StatefulWidget {
  const SubstancesPage({super.key});

  @override
  State<SubstancesPage> createState() => _SubstancesPageState();
}

class _SubstancesPageState extends State<SubstancesPage> {
  // All substances
  List<Map<String, dynamic>> _substances = [];

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshSubstances() async {
    final data = await SQLHelperSubstances.getSubstances();
    setState(() {
      _substances = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshSubstances();
  }

  final _substanceNameController = TextEditingController();
  final _substanceTypeController = TextEditingController();
  final _substanceCommentController = TextEditingController();
  final _substanceBinomialController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingSubstance =
      _substances.firstWhere((element) => element['id'] == id);
      _substanceNameController.text = existingSubstance['substanceName'];
      _substanceTypeController.text = existingSubstance['substanceType'];
      _substanceCommentController.text = existingSubstance['substanceComment'];
      _substanceBinomialController.text = existingSubstance['substanceBinomial'];
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
                controller: _substanceNameController,
                decoration: const InputDecoration(hintText: 'Substance NAME'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _substanceTypeController,
                  decoration: const InputDecoration(hintText: 'Substance TYPE'),
                ),
              ),

//              Padding(
//                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
//                child: TextField(
//                  controller: _substanceActivityAreaController,
//                  decoration: const InputDecoration(hintText: 'Substance ACTIVITY Area'),
//                ),
//              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _substanceCommentController,
                  decoration: const InputDecoration(hintText: 'Substance COMMENT'),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton.icon(
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('BACK'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple[200],
                      ),
                      onPressed: () {

                        Navigator.of(context).pop();
                      },
                    ),

                    ElevatedButton.icon(
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('PHOTO'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple[200],
                      ),

                      onPressed: () async {
                        String substanceBinomial = (_substanceTypeController.text.isNotEmpty ? '${_substanceTypeController.text} ' : '') + _substanceNameController.text;

                        if (id == null) {
                          await _addSubstance(_substanceNameController.text, _substanceTypeController.text, _substanceCommentController.text, substanceBinomial);
                        }
                        if (id != null) {
                          await _updateSubstance(id, _substanceNameController.text, _substanceTypeController.text, _substanceCommentController.text, substanceBinomial);
                        }

                        String substanceName = _substanceNameController.text.isNotEmpty
                            ? _substanceNameController.text
                            : 'SUBSTANCE';

                        String substanceType = _substanceTypeController.text.isNotEmpty
                            ? _substanceTypeController.text
                            : '';

                        String resourceNameMessage = '$substanceType $substanceName';

                        await availableCameras().then((value) => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => CameraApp(cameras: value, resourceName: resourceNameMessage, resourceType: 'substance'))));

                      },
                    ),

                    ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: Text(id == null ? 'SAVE' : 'UPDATE'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple[200],
                      ),

                      onPressed: () async {
                        String substanceBinomial = (_substanceTypeController.text.isNotEmpty ? '${_substanceTypeController.text} ' : '') + _substanceNameController.text;

                        if (id == null) {
                          await _addSubstance(_substanceNameController.text, _substanceTypeController.text, _substanceCommentController.text, substanceBinomial);
                        }
                        if (id != null) {
                          await _updateSubstance(id, _substanceNameController.text, _substanceTypeController.text, _substanceCommentController.text, substanceBinomial);
                        }
                        // Clear the text fields
                        _substanceNameController.text = '';
                        _substanceTypeController.text = '';
                        _substanceCommentController.text = '';
                        _substanceBinomialController.text = '';
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
                  backgroundColor: Colors.purple[200],
                ),
                onPressed: () async {
                  String substanceBinomial = (_substanceTypeController.text.isNotEmpty ? '${_substanceTypeController.text} ' : '') + _substanceNameController.text;
                  if (id == null) {

                    await _addSubstance(_substanceNameController.text,
                        _substanceTypeController.text,
                        _substanceCommentController.text,
                        substanceBinomial);

                  } else {

                    await _updateSubstance(id,
                        _substanceNameController.text,
                        _substanceTypeController.text,
                        _substanceCommentController.text,
                        substanceBinomial);
                  }

                  if (!mounted) return;

                },
              ),

            ],
          ),
        ));
  }

  Future<void> _addSubstance(String substanceName, String? substanceType, String? substanceComment, String substanceBinomial) async {
    await SQLHelperSubstances.createSubstance(substanceName, substanceType, substanceComment, substanceBinomial);
    _refreshSubstances();
  }

  Future<void> _updateSubstance(int id, String substanceName, String? substanceType, String? substanceComment, String substanceBinomial) async {
    await SQLHelperSubstances.updateSubstance(id, substanceName, substanceType, substanceComment, substanceBinomial);
    _refreshSubstances();
  }

  // Delete an item
  void _deleteSubstance(int id) async {
    await SQLHelperSubstances.deleteSubstance(id);

//    String deletionMessage = '_substances[index]';

//    _substances[index]['substanceName']
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Substance deleted!'),
    ));
    _refreshSubstances();
  }

//  void _onReorder(int oldIndex, int newIndex) {
//    setState(() {
//      if (newIndex > oldIndex) {
//        newIndex -= 1;
//      }
//      final Map<String, dynamic> item = _substances.removeAt(oldIndex);
//      _substances.insert(newIndex, item);
//    });
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('N4O Workflow Tool: Substances'),
        leading: const Icon(Icons.shopping_cart_outlined),
        backgroundColor: Colors.purple,
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
                MaterialPageRoute(builder: (context) => const HelpSubstances()),
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

//            icon: const Icon(Icons.save),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpSubstances()),
              );

            },
          ),

          IconButton(
            icon: const Icon(Icons.help),
            iconSize: 40,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpSubstances()),
              );
            },
          ),
        ],
      ),

      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ReorderableListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 40),
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final task = _substances.removeAt(oldIndex);
            _substances.insert(newIndex, task);
          });
        },
        itemCount: _substances.length,
        itemBuilder: (context, index) {
          return Card(
            key: Key('$index'),
            color: Colors.purple[200],
            margin: const EdgeInsets.all(15),
            child: ListTile(
              title: Text(_substances[index]['substanceName']),
              subtitle: Text(_substances[index]['substanceType']),
              trailing: SizedBox(
                width: 150,
                child: Row(
                  children: [
                    IconButton(
                      iconSize: 30,
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showForm(_substances[index]['id']),
                    ),
                    const SizedBox(
                      width: 30.0,
                    ),
                    IconButton(
                      iconSize: 30,
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteSubstance(_substances[index]['id']),
                    ),
                  ],
                ),
              ),
            ),
          );
          },
//        onReorder: (int oldIndex, int newIndex) {
//          setState(() {
//            if (oldIndex < newIndex) {
//              newIndex -= 1;
//            }
//            final Map<String, dynamic> id = _substances.removeAt(oldIndex);
//            _substances.insert(newIndex, id);
//          });
//          },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purpleAccent,
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

        backgroundColor: Colors.purpleAccent,
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