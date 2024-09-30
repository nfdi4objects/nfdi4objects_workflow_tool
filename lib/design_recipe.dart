import 'package:flutter/material.dart';
import 'main.dart';
import 'sql_recipe.dart';
import 'help_recipe.dart';
import 'resources.dart';
import 'package:flag/flag.dart';
//import 'camera.dart';
import 'tasks.dart';
//import 'chat4.dart';

void main() {
  runApp(const RecipeForm());
}

class RecipeForm extends StatelessWidget {
  const RecipeForm({super.key});

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
        title: 'Recipe',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: const RecipePage());
  }
}

class RecipePage extends StatefulWidget {
  const RecipePage({super.key});

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  List<Recipe> _recipe = [];

  bool _isLoading = true;

//  bool _isChecked = false;

  Future<void> _refreshRecipe() async {
    setState(() {
      _isLoading = true;
    });

    Future<void> loadRecipe() async {
      final recipeMaps = await SQLHelperRecipe.getRecipes();
      final recipes = recipeMaps.map((map) => Recipe.fromMap(map)).toList();
      setState(() {
        _recipe = recipes;

        _isLoading = false;
      });
    }

    final database = await SQLHelperRecipe.getRecipes();

    final List<Map<String, dynamic>> maps = database;

    await Future.delayed(const Duration(milliseconds: 100)); // Add a short delay

    setState(() {
      _recipe = maps.map((map) => Recipe.fromMap(map)).toList();

      _isLoading = false;

    });
  }

  void _testRecipe() {
    if (_recipe.indexWhere((recipe) => recipe.recipeName == _recipeNameController.text) == -1) {
      setState(() {
        _recipe.add({'recipeName': _recipeNameController.text} as Recipe);

      });
    } else {
      const Text('Name already entered.');
    }
  }

  void _onChanged(dynamic val) => debugPrint(val.toString());

  @override
  void initState() {
    super.initState();

    _refreshRecipe();
  }

  final _recipeNameController = TextEditingController();
  final _recipeTypeController = TextEditingController();
  final _recipeReferenceController = TextEditingController();
  final _recipeAimController = TextEditingController();
  final _recipeSerialNumberController = TextEditingController();
  final _recipeActivityAreaController = TextEditingController();
  final _recipePurposeController = TextEditingController();
  final _recipeWebPageController = TextEditingController();
  final _recipeCommentController = TextEditingController();
  final _recipeCompletedController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int? id) async {

//    List<String> initialValues = [];

    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingRecipe =
      _recipe.firstWhere((element) => element.id == id);
      _recipeNameController.text = existingRecipe.recipeName;
      _recipeTypeController.text = existingRecipe.recipeType;
      _recipeReferenceController.text = existingRecipe.recipeReference;
      _recipeAimController.text = existingRecipe.recipeAim;
      _recipeSerialNumberController.text = existingRecipe.recipeSerialNumber;
      _recipeActivityAreaController.text = existingRecipe.recipeActivityArea;
      _recipePurposeController.text = existingRecipe.recipePurpose;
      _recipeWebPageController.text = existingRecipe.recipeWebPage;
      _recipeCommentController.text = existingRecipe.recipeComment;
      _recipeCompletedController.text = existingRecipe.recipeCompleted ? 'true' : 'false';

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
                'Plan a RECIPE:',
                style: TextStyle(
                    fontSize: 24),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextFormField(
                  controller: _recipeNameController,
                  decoration: const InputDecoration(hintText: 'Recipe NAME'),

                  autovalidateMode: AutovalidateMode.always,
                  validator: (value) {
                    if (_recipe.indexWhere((recipe) => recipe.recipeName == value) != -1) {
                      return 'Must be unique.';
                    }
                    return null;
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _recipeTypeController,
                  decoration: const InputDecoration(hintText: 'Recipe TYPE'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _recipeSerialNumberController,
                  decoration: const InputDecoration(hintText: 'Recipe SERIAL NUMBER (other identifier)'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _recipeReferenceController,
                  decoration: const InputDecoration(hintText: 'WHAT do you want to cook?'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _recipeAimController,
                  decoration: const InputDecoration(hintText: 'WHY do you want to cook this?'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _recipeActivityAreaController,
                  decoration: const InputDecoration(hintText: 'Recipe ACTIVITY Area'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _recipePurposeController,
                  decoration: const InputDecoration(hintText: 'Recipe PURPOSE'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _recipeWebPageController,
                  decoration: const InputDecoration(hintText: 'Recipe WEB PAGE'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextField(
                  controller: _recipeCommentController,
                  decoration: const InputDecoration(hintText: 'Recipe COMMENT'),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('BACK'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[200]
                    ),
                    onPressed: () {

                      Navigator.of(context).pop();
                    },
                  ),

                  ElevatedButton.icon(
                    icon: const Icon(Icons.check_box_outlined),
                    label: const Text('TASKS'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal
                    ),

                    onPressed: () async {
                      // Save new recipe
                      if (id == null) {
                        await _addRecipe();
                      }

                      if (id != null) {
                        _testRecipe;
                        await _updateRecipe(id);
                      }

                      String designName = _recipeNameController.text.isNotEmpty
                          ? _recipeNameController.text
                          : 'RECIPE';

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TasksForm(designName: 'Recipe $designName', designColor: Colors.teal, button1color: Colors.teal.shade100, button2color: Colors.teal.shade200, tasks: const [],)),
                      );

                    },
                  ),

                  ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: Text(id == null ? 'SAVE' : 'UPDATE'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal
                    ),
                    onPressed: () async {
                      // Save new recipe
                      if (id == null) {
                        await _addRecipe();
                      }

                      if (id != null) {
                        _testRecipe;
                        await _updateRecipe(id);
                      }

                      // Clear the text fields
                      _recipeNameController.text = '';
                      _recipeTypeController.text = '';
                      _recipeReferenceController.text = '';
                      _recipeAimController.text = '';
                      _recipeSerialNumberController.text = '';
                      _recipeActivityAreaController.text = '';
                      _recipePurposeController.text = '';
                      _recipeWebPageController.text = '';
                      _recipeCommentController.text = '';

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

// Insert a new recipe to the database
  Future<void> _addRecipe() async {
    await SQLHelperRecipe.createRecipe(
        _recipeNameController.text, _recipeTypeController.text, _recipeReferenceController.text, _recipeAimController.text, _recipeSerialNumberController.text, _recipeActivityAreaController.text, _recipePurposeController.text, _recipeWebPageController.text, _recipeCommentController.text, _recipeCompletedController.text);
    _refreshRecipe();
  }

  // Update an existing recipe
  Future<void> _updateRecipe(id) async {
    await SQLHelperRecipe.updateRecipe(
        id, _recipeNameController.text, _recipeTypeController.text, _recipeReferenceController.text, _recipeAimController.text, _recipeSerialNumberController.text, _recipeActivityAreaController.text, _recipePurposeController.text, _recipeWebPageController.text, _recipeCommentController.text, _recipeCompletedController.text);
    _refreshRecipe();
  }

  // Delete an item
  void _deleteRecipe(id, String recipeName) async {
    await SQLHelperRecipe.deleteRecipe(id);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('$recipeName deleted!'),
    ));
    _refreshRecipe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('N4O Workflow Tool: Recipe Plan'),
        leading: const Icon(Icons.restaurant_menu_outlined),
        backgroundColor: Colors.teal,
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
                    builder: (context) => const HelpRecipe()),
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
                    builder: (context) => const HelpRecipe()),
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
                    builder: (context) => const HelpRecipe()),
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
        itemCount: _recipe.length,

        itemBuilder: (context, index) {
          if (index < _recipe.length) {
            return Card(

              color: Colors.teal[100],
              margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              elevation: 5,
              child: CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,

                title: Text(_recipe[index].recipeName),
                subtitle: Text(_recipe[index].recipeType),

                value: _recipe[index].recipeCompleted,

                onChanged: (bool? isChecked) {

                  setState(() {
                    _recipe[index].recipeCompleted = isChecked ?? false;
                  });

      //            leading: Checkbox(
      //              checkColor: Colors.black,
      //              activeColor: Colors.red,
      //              value: task.completed,
      //              onChanged: (value) {
      //                onTaskChanged(task);
      //              },
      //            ),



                  // Update the database
                  SQLHelperRecipe.updateRecipe(
                    _recipe[index].id,
                    _recipe[index].recipeName,
                    _recipe[index].recipeType,
                    _recipe[index].recipeReference,
                    _recipe[index].recipeAim,
                    _recipe[index].recipeSerialNumber,
                    _recipe[index].recipeActivityArea,
                    _recipe[index].recipePurpose,
                    _recipe[index].recipeWebPage,
                    _recipe[index].recipeComment,
                    _recipe[index].recipeCompleted ? 'true' : 'false',
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
                              _showForm(_recipe[index].id),
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
                              _deleteRecipe(_recipe[index].id,
                                  _recipe[index].recipeName),
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
        backgroundColor: Colors.teal,
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

        backgroundColor: Colors.teal,
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

class Recipe {
  int id;
  late String recipeName;
  late String recipeType;
  late String recipeReference;
  late String recipeAim;
  late String recipeSerialNumber;
  late String recipeActivityArea;
  late String recipePurpose;
  late String recipeWebPage;
  late String recipeComment;
  bool recipeCompleted;

  Recipe({required this.id, required this.recipeName, required this.recipeType,
    required this.recipeReference,
    required this.recipeAim,
    required this.recipeSerialNumber,
    required this.recipeActivityArea,
    required this.recipePurpose,
    required this.recipeWebPage,
    required this.recipeComment,
    required this.recipeCompleted
  });

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'] as int,
      recipeName: map['recipeName'] as String,
      recipeType: map['recipeType'] as String,
      recipeReference: map['recipeReference'] as String,
      recipeAim: map['recipeAim'] as String,
      recipeSerialNumber: map['recipeSerialNumber'] as String,
      recipeActivityArea: map['recipeActivityArea'] as String,
      recipePurpose: map['recipePurpose'] as String,
      recipeWebPage: map['_recipeWebPage'] != null ? map['_recipeWebPage'] as String : '',
//      recipeWebPage: map['_recipeWebPage'] as String,
      recipeComment: map['recipeComment'] as String,
      recipeCompleted: map['recipeCompleted'] == 'true',
    );
  }
}
