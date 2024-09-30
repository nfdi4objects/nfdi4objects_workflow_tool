//import 'package:flutter/foundation.dart';
import '/diagram_editor/widget/editor.dart';
import 'help_tasks.dart';
import 'main.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'resources.dart';
import 'sql_substances.dart';
import 'sql_tasks.dart';
import 'task_to_flowchart.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(const TasksPage(tasks: [], designName: 'designName', designColor: Colors.amber, button1color: Colors.amber, button2color: Colors.amber));
//  runApp(const TasksPage(tasks: [], designName: 'designName', designColor: designColor));
}

class TasksPage extends StatelessWidget {
  final String designName;
  final Color designColor;
  final Color button1color;
  final Color button2color;
  final List<Task> tasks;

  const TasksPage({
    super.key,
    required this.designName,
    required this.designColor,
    required this.button1color,
    required this.button2color,
    required this.tasks,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'N4O Workflow Tool: Tasks List Builder',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: TasksForm(
        tasks: tasks,
        designName: designName,
        designColor: designColor,
        button1color: button1color,
        button2color: button2color,
      ),
    );
  }
}

class TasksForm extends StatefulWidget {
  final List<Task> tasks;
  final String designName;
  final Color designColor;
  final Color button1color;
  final Color button2color;

  const TasksForm({
    super.key,
    required this.tasks,
    required this.designName,
    required this.designColor,
    required this.button1color,
    required this.button2color,
  });

  @override
  TasksFormState createState() => TasksFormState();
}

class TasksFormState extends State<TasksForm> {
  late List<Task> _tasks;
  final TextEditingController _textFieldController = TextEditingController();
//  TaskFormState({required this.designName});

  late Future<Database> _database;

  List<DropdownMenuItem<String>> _dropdownItems = [];
  String? substanceBinomial;
//  String substanceBinomial = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeDatabase();

//    designName = widget.designName;
    _tasks = widget.tasks;
    _database = SQLHelperTasks.db();
    _populateDropdownItems();
    _loadTasks();
  }

  Future<void> _initializeDatabase() async {
    _database = SQLHelperTasks.db();
    setState(() {});
  }


  _populateDropdownItems() async {
    final objects = await SQLHelperSubstances.getSubstances();

    List<DropdownMenuItem<String>> items = objects.map((object) {
      return DropdownMenuItem<String>(
        value: object['substanceBinomial'],
        child: Text(object['substanceBinomial']),
      );
    }).toList();

    setState(() {
      _dropdownItems = items;
      substanceBinomial = _dropdownItems.first.value;
    });
  }

  final _newIndexController = TextEditingController();
  final _designNameController = TextEditingController();
  final _taskNameController = TextEditingController();
  final _substanceBinomialController = TextEditingController();
  final _taskTypeController = TextEditingController();
  final _taskActivityAreaController = TextEditingController();
  final _taskFunctionController = TextEditingController();
  final _taskCommentController = TextEditingController();
  final _idController = TextEditingController();

//  get designColor => designColor;
//
//  get button1color => button1color;
//  final _taskCompletedController = TextEditingController();

  void _loadTasks() async {
    final tasksFromDb = await SQLHelperTasks.getTasks(widget.designName);
    setState(() {
      _tasks = tasksFromDb.map((e) => Task(
        id: e['id'] ?? 0,
        index: e['index'] ?? _tasks.length,
        newIndex: e['newIndex'] ?? _tasks.length, //+1?
        designName: e['designName'] ?? '',
        taskName: e['taskName'] ?? '',
        substanceBinomial: e['substanceBinomial'] ?? '',
        taskType: e['taskType'] ?? '',
        taskActivityArea: e['taskActivityArea'] ?? '',
        taskFunction: e['taskFunction'] ?? '',
        taskComment: e['taskComment'] ?? '',
//        taskCompleted: e['taskCompleted'] ?? '0',
      )).toList();
      _isLoading = false;
    });
  }

  Future<void> _updateTaskItem(Task updatedTask) async {
    await SQLHelperTasks.updateTask(
      updatedTask.id,
      updatedTask.newIndex,
      updatedTask.designName,
      updatedTask.taskName,
      updatedTask.substanceBinomial,
      updatedTask.taskType,
      updatedTask.taskActivityArea,
      updatedTask.taskFunction,
      updatedTask.taskComment,
    );
  }

  Future<void> _addTaskItem(
      String taskName,
      String substanceBinomial,
      String taskType,
      String taskActivityArea,
      String taskFunction,
      String taskComment
      ) async {
    final newIndex = _tasks.length;

    Task newTask = Task(
      id: -1,
      index: newIndex,
      newIndex: newIndex,
      designName: widget.designName,
      taskName: taskName,
      substanceBinomial: substanceBinomial,
      taskType: taskType,
      taskActivityArea: taskActivityArea,
      taskFunction: taskFunction,
      taskComment: taskComment,
    );

    setState(() {
      _tasks.add(newTask);
    });

    final id = await SQLHelperTasks.createTask(
        newIndex,
        widget.designName,
        taskName,
        substanceBinomial,
        taskType,
        taskActivityArea,
        taskFunction,
        taskComment
    );




    setState(() {
      newTask.id = id;
    });

    _textFieldController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.designName} Tasks'),
        leading: const Icon(Icons.check_box_outlined),
        backgroundColor: widget.designColor,
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
                MaterialPageRoute(builder: (context) => const HelpTasks()),
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
                MaterialPageRoute(builder: (context) => const HelpTasks()),
              );
            },
          ),

          const SizedBox(width: 5),

          IconButton(
            icon: const Icon(Icons.help),
            iconSize: 40,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpTasks()),
              );
            },
          ),
        ],
      ),

      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ReorderableListView(
        onReorder: reorderData,
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 40),
        children: _tasks.map((Task task) {
          return TaskItem(
            key: ValueKey('${task.taskName}-${_tasks.indexOf(task)}'),
            task: task,
            onTaskChanged: _handleTaskChange,
            editTask: _handleTaskEdit,
            removeTask: _deleteTask,
            button1color: (widget.designColor is MaterialColor)
                ? (widget.designColor as MaterialColor).shade100
                : widget.button1color,

//            designColor: widget.button1color,
          );
        }).toList(),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: widget.designColor,
        onPressed: () => _showForm(null, designName: widget.designName),
        tooltip: 'Add a Task',
        child: const Icon(Icons.add),
      ),

      bottomNavigationBar: BottomNavigationBar(
        unselectedLabelStyle: const TextStyle(color: Colors.white),
        onTap: (compoundIndex) async {
          StepState.disabled.index;
          switch (compoundIndex) {
            case 0:
              {
                setState(() {
                  compoundIndex = 0;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AvailableResources()),
                );
              }

              break;

            case 1:
              {
                setState(() {
                  compoundIndex = 1;
                });
                final database = await _database;

                if (_database == null) {
                  debugPrint('Database is not initialized.');
                  return;
                }

//                Future<void> _fetchAndNavigate() async {
                final taskTranslator = TaskTranslator(database, widget.designName);
                final jsonData = await taskTranslator.generateAndSaveJson();  // Now returns jsonData

                if (!mounted) return;

                Navigator.pop(context);  // Close the modal bottom sheet

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FlowChartEditor(
                      designName: widget.designName,
                      designColor: widget.designColor, button1color: widget.button1color, button2color: widget.button2color,
                      jsonData: jsonData, designNameJ: '',  // Pass the generated JSON data to the new screen
                    ),
                  ),
                );
//                }




//                final taskTranslator = TaskTranslator(database, widget.designName);
//                final jsonData = await taskTranslator.fetchTasksAsJson();
//
//                if (!mounted) return;
//
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                      builder: (context) => FlowChartEditor(designName: widget.designName, jsonData: jsonData,),
//                ));
             }

              break;

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

        backgroundColor: widget.designColor,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_back,
                color: Colors.white),
            label: 'Resources',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schema_outlined,
                color: Colors.white),
            label: 'FLOW CHART',
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


//  Color getColorFromString(String colorString) {
//    return colorString != null ? Colors[getColorString(colorString)] : Colors.white;
//  }
//
//  String getColorString(String colorString) {
//    return colorString.replaceAll('Colors.', '');
//  }


  void reorderData(int oldindex, int newindex) {
    setState(() {
      if (newindex > oldindex) {
        newindex -= 1;
      }
      final items = _tasks.removeAt(oldindex);
      _tasks.insert(newindex, items);
    });

    for (int i = 0; i < _tasks.length; i++) {
      SQLHelperTasks.updateTaskOrder(_tasks[i].id, i);
      _tasks[i].newIndex = i;
    }
  }

  void _handleTaskChange(Task task) async {

    await SQLHelperTasks.updateTask(
      task.id,
      task.newIndex,
      widget.designName,
      task.taskName,
      '',
      null, null, null, null,
//        task.completed ? '1' : '0'
    );
  }

  void _deleteTask(Task task) async {
    setState(() {
      _tasks.remove(task);
    });

    await SQLHelperTasks.deleteTask(task.id);
  }

  void _handleTaskEdit(Task? task, {String? designName}) {

    final existingTask = _tasks.firstWhere((element) => element.taskName == task?.taskName);

    // Pre-fill the controllers with the task's current values
    _taskNameController.text = existingTask.taskName;
    _substanceBinomialController.text = existingTask.substanceBinomial;
    _taskTypeController.text = existingTask.taskType;
    _taskActivityAreaController.text = existingTask.taskActivityArea;
    _taskFunctionController.text = existingTask.taskFunction;
    _taskCommentController.text = existingTask.taskComment;
    _idController.text = existingTask.id.toString();

    // Set design name
    _designNameController.text = designName ?? 'Default Design Name';

    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (context) => SingleChildScrollView(
        padding: EdgeInsets.only(
          top: 15,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 120,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _taskNameController,
                decoration: const InputDecoration(hintText: 'Task NAME'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Task OBJECT',
                  border: OutlineInputBorder(),
                ),
                value: _dropdownItems.isEmpty ? null : substanceBinomial,
                items: _dropdownItems.isEmpty
                    ? [const DropdownMenuItem<String>(value: null, child: Text('No items available'))]
                    : _dropdownItems,
                onChanged: (value) {
                  setState(() {
                    substanceBinomial = value!;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _taskTypeController,
                decoration: const InputDecoration(hintText: 'Task TYPE'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _taskActivityAreaController,
                decoration: const InputDecoration(hintText: 'Task ACTIVITY Area'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _taskFunctionController,
                decoration: const InputDecoration(hintText: 'Task FUNCTION (related verb)'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _taskCommentController,
                decoration: const InputDecoration(hintText: 'Task COMMENT'),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton.icon(
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('BACK'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.designColor,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                
                ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: Text(task == null ? 'SAVE' : 'UPDATE'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.button2color,
                  ),
                  onPressed: () async {
                    if (task == null) {
                      // Adding a new task
                      await _addTaskItem(
                        _taskNameController.text,
                        substanceBinomial!,
                        _taskTypeController.text,
                        _taskActivityAreaController.text,
                        _taskFunctionController.text,
                        _taskCommentController.text,
                      );
                    } else {
                      // Updating an existing task
                      final updatedTask = Task(
                        id: task.id,
                        index: task.index,
                        newIndex: int.tryParse(_newIndexController.text) ?? 0,
                        designName: _designNameController.text,
                        taskName: _taskNameController.text,
                        substanceBinomial: substanceBinomial!,
                        taskType: _taskTypeController.text,
                        taskActivityArea: _taskActivityAreaController.text,
                        taskFunction: _taskFunctionController.text,
                        taskComment: _taskCommentController.text,
                      );

                      await _updateTaskItem(updatedTask);

                      // Update the task in the local list
                      setState(() {
                        int taskIndex = _tasks.indexWhere((t) => t.id == task.id);
                        if (taskIndex != -1) {
                          _tasks[taskIndex] = updatedTask;
                          _taskNameController.clear();
                          _substanceBinomialController.clear();
                          _taskTypeController.clear();
                          _taskActivityAreaController.clear();
                          _taskFunctionController.clear();
                          _taskCommentController.clear();
                        }
                      });
                    }

                    if (!mounted) return;
                    Navigator.of(context).pop();
                  },
                ),

                ElevatedButton.icon(
                  icon: const Icon(Icons.schema_outlined),
                  label: const Text('FLOW CHART'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.button2color,
                  ),
                  onPressed: () async {
                    final database = await _database;
                      if (task == null) {
                        _addTaskItem(
                          _taskNameController.text,
                          substanceBinomial!,
                          _taskTypeController.text,
                          _taskActivityAreaController.text,
                          _taskFunctionController.text,
                          _taskCommentController.text,
                        );
                      } else {
                        final updatedTask = Task(
                          id: task.id,
                          index: task.index,
                          newIndex: int.tryParse(_newIndexController.text) ?? 0,
                          designName: _designNameController.text,
                          taskName: _taskNameController.text,
                          substanceBinomial: substanceBinomial!,
                          taskType: _taskTypeController.text,
                          taskActivityArea: _taskActivityAreaController.text,
                          taskFunction: _taskFunctionController.text,
                          taskComment: _taskCommentController.text,
                        );

                        _updateTaskItem(updatedTask);

                        setState(() {
                          int taskIndex = _tasks.indexWhere((t) => t.id == task.id);
                          if (taskIndex != -1) {
                            _tasks[taskIndex] = updatedTask;
                            _taskNameController.clear();
                            _substanceBinomialController.clear();
                            _taskTypeController.clear();
                            _taskActivityAreaController.clear();
                            _taskFunctionController.clear();
                            _taskCommentController.clear();
                          }
                        });
                      }

//    Future<void> _fetchAndNavigate() async {
      final taskTranslator = TaskTranslator(database, widget.designName);
      final jsonData = await taskTranslator.fetchTasksAsJson();

      if (!mounted) return;

                    Navigator.pop(context);

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              FlowChartEditor(
                                designName: widget.designName,
                                designColor: widget.designColor, button1color: widget.button1color, button2color: widget.button2color,
                                jsonData: jsonData, designNameJ: '',),
                        ));
//                      }

                      },
                ),

              ],
            ),


//            Row(
//              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('ADD'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.designColor,
                  ),
                  onPressed: () async {
                    if (task == null) {
                      // Adding a new task
                      await _addTaskItem(
                        _taskNameController.text,
                        substanceBinomial!,
                        _taskTypeController.text,
                        _taskActivityAreaController.text,
                        _taskFunctionController.text,
                        _taskCommentController.text,
                      );
                    } else {
                      // Updating an existing task
                      final updatedTask = Task(
                        id: task.id,
                        index: task.index,
                        newIndex: int.tryParse(_newIndexController.text) ?? 0,
                        designName: _designNameController.text,
                        taskName: _taskNameController.text,
                        substanceBinomial: substanceBinomial!,
                        taskType: _taskTypeController.text,
                        taskActivityArea: _taskActivityAreaController.text,
                        taskFunction: _taskFunctionController.text,
                        taskComment: _taskCommentController.text,
                      );

                      await _updateTaskItem(updatedTask);

                      // Update the task in the local list
                      setState(() {
                        int taskIndex = _tasks.indexWhere((t) => t.id == task.id);
                        if (taskIndex != -1) {
                          _tasks[taskIndex] = updatedTask;
                          _taskNameController.clear();
                          _substanceBinomialController.clear();
                          _taskTypeController.clear();
                          _taskActivityAreaController.clear();
                          _taskFunctionController.clear();
                          _taskCommentController.clear();
                        }
                      });
                    }

                    if (!mounted) return;

                    await _showForm(null, designName: widget.designName);

//                    Navigator.pushReplacement(
//                      context,
//                      MaterialPageRoute(
//                        builder: (context) => FutureBuilder<void>(
//                          future: _showForm(null, designName: widget.designName),
//                          builder: (context, snapshot) {
//                            // Loading state
//                            if (snapshot.connectionState == ConnectionState.waiting) {
//                              return Center(child: CircularProgressIndicator());
//                            }
//                            // Error state
//                            else if (snapshot.hasError) {
//                              return Center(child: Text('Error: ${snapshot.error}'));
//                            }
//                            // Completed state
//                            else {
////                              Navigator.of(context).pop();
//                              return _showForm(null, designName: widget.designName); // Show your next form or widget
//                            }
//                          },
//                        ),
//                      ),
//                    );





//                    Navigator.pushReplacement(
//                      context,
//                      MaterialPageRoute(
//                        builder: (context) => _showForm(null, designName: widget.designName),
//                      ),
//                    );
                  },
                ),
//              ],
//            )

          ],
        ),

      ),


//          ],
        );
//      ),
//    );
  }

  Future<void> _showForm(Task? task, {String? designName}) async {
    if (task != null) {
      final existingTask =
      _tasks.firstWhere((element) => element.taskName == task.taskName);
      _newIndexController.text = existingTask.newIndex.toString();
//      _newIndexController.text = existingTask.newIndex;
      _designNameController.text = existingTask.designName;
      _taskNameController.text = existingTask.taskName;
      _substanceBinomialController.text = existingTask.substanceBinomial;
      _taskTypeController.text = existingTask.taskType;
      _taskActivityAreaController.text = existingTask.taskActivityArea;
      _taskFunctionController.text = existingTask.taskFunction;
      _taskCommentController.text = existingTask.taskComment;
      _idController.text = existingTask.id.toString();
//      _taskCompletedController.text = existingTask.taskCompleted.toString();
    } else {
      if (designName != null) {
        _designNameController.text = designName;
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
          bottom: MediaQuery.of(context).viewInsets.bottom + 120,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _taskNameController,
                decoration: const InputDecoration(hintText: 'Task NAME'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Task OBJECT',
                  border: OutlineInputBorder(),
                ),

                value: _dropdownItems.isEmpty ? null : substanceBinomial,
                items: _dropdownItems.isEmpty
                    ? [const DropdownMenuItem<String>(value: null, child: Text('No items available'))]
                    : _dropdownItems,

                onChanged: (value) {
                  setState(() {
                    substanceBinomial = value!;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _taskTypeController,
                decoration: const InputDecoration(hintText: 'Task TYPE'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _taskActivityAreaController,
                decoration: const InputDecoration(hintText: 'Task ACTIVITY Area'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _taskFunctionController,
                decoration: const InputDecoration(hintText: 'Task FUNCTION (related verb)'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _taskCommentController,
                decoration: const InputDecoration(hintText: 'Task COMMENT'),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton.icon(
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('BACK'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.button2color,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: Text(task == null ? 'SAVE' : 'UPDATE'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.button2color,
                  ),
                  onPressed: () async {
                    if (task == null) {
                      await _addTaskItem(
                        _taskNameController.text,
                        substanceBinomial!,
                        _taskTypeController.text,
                        _taskActivityAreaController.text,
                        _taskFunctionController.text,
                        _taskCommentController.text,
//                        '0',
                      );
                    }

                    _taskNameController.clear();
                    _substanceBinomialController.clear();
                    _taskTypeController.clear();
                    _taskActivityAreaController.clear();
                    _taskFunctionController.clear();
                    _taskCommentController.clear();
                    if (!mounted) return;
                    Navigator.of(context).pop();
                  },
                ),

                ElevatedButton.icon(
                  icon: const Icon(Icons.schema_outlined),
                  label: const Text('FLOW CHART'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.button2color,
                  ),
                  onPressed: () async {
                    final database = await _database;
                    if (task == null) {
                      await _addTaskItem(
                        _taskNameController.text,
                        substanceBinomial!,
                        _taskTypeController.text,
                        _taskActivityAreaController.text,
                        _taskFunctionController.text,
                        _taskCommentController.text,
//                        '0',
                      );
                    }

                    _taskNameController.clear();
                    _substanceBinomialController.clear();
                    _taskTypeController.clear();
                    _taskActivityAreaController.clear();
                    _taskFunctionController.clear();
                    _taskCommentController.clear();

//                    Future<void> _fetchAndNavigate() async {
                      final taskTranslator = TaskTranslator(
                          database, widget.designName);
                      final jsonData = await taskTranslator.fetchTasksAsJson();

                      if (!mounted) return;

                      Navigator.pop(context);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FlowChartEditor(
                              designName: widget.designName,
                              designColor: widget.designColor, button1color: widget.button1color, button2color: widget.button2color,
                              jsonData: jsonData, designNameJ: '',),
                          )
                      );
//                    }
                  }
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}

class TaskItem extends StatelessWidget {
  const TaskItem({
    required this.task,
    required this.onTaskChanged,
    required this.editTask,
    required this.removeTask,
    required this.button1color,
    required Key key,
  }) : super(key: key);

  final Task task;
  final Function(Task) onTaskChanged;
  final Function(Task) editTask;
  final Function(Task) removeTask;
  final Color button1color;  // Use Color instead of MaterialColor

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: ListTile(
        tileColor: button1color,
//        leading: Checkbox(
//          checkColor: Colors.black,
//          activeColor: Colors.red,
////          value: task.completed,
//          onChanged: (value) {
//            onTaskChanged(task);
//          },
//        ),
//        title: Text(task.taskName, style: _getTextStyle(task.completed)),
        title: Text(task.taskName),
        subtitle: Text(task.substanceBinomial), // Modify as needed
        trailing: Wrap(
          spacing: 10,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.lightGreen),
              onPressed: () {
                editTask(task);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                removeTask(task);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Task {
  int id;
  int index;
  int newIndex;
  String designName;
  String taskName;
  String substanceBinomial;
  String taskType;
  String taskActivityArea;
  String taskFunction;
  String taskComment;
//  String taskCompleted;

  Task({
    required this.id,
    required this.index,
    required this.newIndex,
    required this.designName,
    required this.taskName,
    required this.substanceBinomial,
    required this.taskType,
    required this.taskActivityArea,
    required this.taskFunction,
    required this.taskComment,
//    required this.taskCompleted,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'index': index,
      'newIndex': newIndex,
      'designName': designName,
      'taskName': taskName,
      'substanceBinomial': substanceBinomial,
      'taskType': taskType,
      'taskActivityArea': taskActivityArea,
      'taskFunction': taskFunction,
      'taskComment': taskComment,
    };
  }

//  bool get completed => taskCompleted == '1';

//  set completed(bool value) {
//    taskCompleted = value ? '1' : '0';
//  }
}