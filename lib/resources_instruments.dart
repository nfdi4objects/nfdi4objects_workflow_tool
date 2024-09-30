import 'package:flutter/material.dart';
import 'main.dart';
import 'sql_instruments.dart';
import 'help_instrument.dart';
import 'resources.dart';
import 'package:camera/camera.dart' show availableCameras;
import 'camera.dart';
import 'import_instrument.dart';
import 'package:flag/flag.dart';

void main() {
  runApp(const InstrumentForm());
}

class InstrumentForm extends StatelessWidget {
  const InstrumentForm({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove the debug banner
        debugShowCheckedModeBanner: false,
        title: 'Instrument',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const InstrumentPage());
  }
}

class InstrumentPage extends StatefulWidget {
  const InstrumentPage({super.key});

  @override
  State<InstrumentPage> createState() => _InstrumentPageState();
}

class _InstrumentPageState extends State<InstrumentPage> {
  // All instruments
  List<Map<String, dynamic>> _instrument = [];

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshInstrument() async {
    final data = await SQLInstrument.getInstruments();
    setState(() {
      _instrument = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshInstrument();
  }

  final _instrumentNameController = TextEditingController();
  final _instrumentTypeController = TextEditingController();
  final _instrumentManufacturerController = TextEditingController();
  final _instrumentModelController = TextEditingController();
  final _instrumentSerialNumberController = TextEditingController();
  final _instrumentActivityAreaController = TextEditingController();
  final _instrumentFunctionController = TextEditingController();
  final _instrumentCommentController = TextEditingController();
  final _instrumentBinomialController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingInstrument =
      _instrument.firstWhere((element) => element['id'] == id);
      _instrumentNameController.text = existingInstrument['instrumentName'];
      _instrumentTypeController.text = existingInstrument['instrumentType'];
      _instrumentManufacturerController.text = existingInstrument['instrumentManufacturer'];
      _instrumentModelController.text = existingInstrument['instrumentModel'];
      _instrumentSerialNumberController.text = existingInstrument['instrumentSerialNumber'];
      _instrumentActivityAreaController.text = existingInstrument['instrumentActivityArea'];
      _instrumentFunctionController.text = existingInstrument['instrumentFunction'];
      _instrumentCommentController.text = existingInstrument['instrumentComment'];
      _instrumentBinomialController.text = existingInstrument['instrumentBinomial'];
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
                controller: _instrumentNameController,
                decoration: const InputDecoration(hintText: 'Instrument NAME'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _instrumentTypeController,
                decoration: const InputDecoration(hintText: 'Instrument TYPE'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _instrumentManufacturerController,
                decoration: const InputDecoration(hintText: 'Instrument MANUFACTURER'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _instrumentModelController,
                decoration: const InputDecoration(hintText: 'Instrument MODEL'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _instrumentSerialNumberController,
                decoration: const InputDecoration(hintText: 'Instrument SERIAL NUMBER'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _instrumentActivityAreaController,
                decoration: const InputDecoration(hintText: 'Instrument ACTIVITY Area'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _instrumentFunctionController,
                decoration: const InputDecoration(hintText: 'Instrument FUNCTION'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextField(
                controller: _instrumentCommentController,
                decoration: const InputDecoration(hintText: 'Instrument COMMENT'),
              ),
            ),

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ElevatedButton.icon(
            icon: const Icon(Icons.arrow_back),
            label: const Text('BACK'),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[200],
            ),
            onPressed: () {

              Navigator.of(context).pop();
            },
          ),

          ElevatedButton.icon(
            icon: const Icon(Icons.camera_alt),
            label: const Text('PHOTO'),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[200],
            ),
            onPressed: () async {
              String instrumentBinomial = (_instrumentTypeController.text.isNotEmpty ? '${_instrumentTypeController.text} ' : '') + _instrumentNameController.text;

              // Save new instrument
              if (id == null) {
                await _addInstrument(_instrumentNameController.text,
                  _instrumentTypeController.text,
                  _instrumentManufacturerController.text,
                  _instrumentModelController.text,
                  _instrumentSerialNumberController.text,
                  _instrumentActivityAreaController.text,
                  _instrumentFunctionController.text,
                  _instrumentCommentController.text,
                  instrumentBinomial,
                );
              }

              if (id != null) {
                await _updateInstrument(id, _instrumentNameController.text,
                  _instrumentTypeController.text,
                  _instrumentManufacturerController.text,
                  _instrumentModelController.text,
                  _instrumentSerialNumberController.text,
                  _instrumentActivityAreaController.text,
                  _instrumentFunctionController.text,
                  _instrumentCommentController.text,
                  instrumentBinomial,
                );
              }

              String instrumentName = _instrumentNameController.text.isNotEmpty
                  ? _instrumentNameController.text
                  : 'INSTRUMENT';

              String instrumentType = _instrumentTypeController.text.isNotEmpty
                  ? _instrumentTypeController.text
                  : '';

              String resourceNameMessage = '$instrumentType $instrumentName';

              await availableCameras().then((value) => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => CameraApp(cameras: value, resourceName: resourceNameMessage, resourceType: 'instrument'))));

            },
          ),

          ElevatedButton.icon(
            icon: const Icon(Icons.save),
            label: Text(id == null ? 'SAVE' : 'UPDATE'),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[200],
            ),
            onPressed: () async {
              String instrumentBinomial = (_instrumentTypeController.text.isNotEmpty ? '${_instrumentTypeController.text} ' : '') + _instrumentNameController.text;
              debugPrint(instrumentBinomial);
              // Save new instrument
                if (id == null) {
                  await _addInstrument(_instrumentNameController.text,
                    _instrumentTypeController.text,
                    _instrumentManufacturerController.text,
                    _instrumentModelController.text,
                    _instrumentSerialNumberController.text,
                    _instrumentActivityAreaController.text,
                    _instrumentFunctionController.text,
                    _instrumentCommentController.text,
                    instrumentBinomial,
                  );
                }

                if (id != null) {
                  await _updateInstrument(id, _instrumentNameController.text,
                    _instrumentTypeController.text,
                    _instrumentManufacturerController.text,
                    _instrumentModelController.text,
                    _instrumentSerialNumberController.text,
                    _instrumentActivityAreaController.text,
                    _instrumentFunctionController.text,
                    _instrumentCommentController.text,
                    instrumentBinomial,
                  );
                }

                // Clear the text fields
                _instrumentNameController.text = '';
                _instrumentTypeController.text = '';
                _instrumentManufacturerController.text = '';
                _instrumentModelController.text = '';
                _instrumentSerialNumberController.text = '';
                _instrumentActivityAreaController.text = '';
                _instrumentFunctionController.text = '';
                _instrumentCommentController.text = '';
                _instrumentBinomialController.text = '';
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
                backgroundColor: Colors.blue[200],
              ),
    onPressed: () async {
                String instrumentBinomial = (_instrumentTypeController.text.isNotEmpty ? '${_instrumentTypeController.text} ' : '') + _instrumentNameController.text;
                if (id == null) {

                await _addInstrument(_instrumentNameController.text,
                      _instrumentTypeController.text,
                      _instrumentManufacturerController.text,
                      _instrumentModelController.text,
                      _instrumentSerialNumberController.text,
                      _instrumentActivityAreaController.text,
                      _instrumentFunctionController.text,
                      _instrumentCommentController.text,
                      instrumentBinomial);

              } else {
                await _updateInstrument(id, _instrumentNameController.text,
                  _instrumentTypeController.text,
                      _instrumentManufacturerController.text,
                      _instrumentModelController.text,
                      _instrumentSerialNumberController.text,
                      _instrumentActivityAreaController.text,
                      _instrumentFunctionController.text,
                      _instrumentCommentController.text,
                      instrumentBinomial,
                  );

                      _instrumentNameController.text = '';
                      _instrumentTypeController.text = '';
                      _instrumentManufacturerController.text = '';
                      _instrumentModelController.text = '';
                      _instrumentSerialNumberController.text = '';
                      _instrumentActivityAreaController.text = '';
                      _instrumentFunctionController.text = '';
                      _instrumentCommentController.text = '';
                      _instrumentBinomialController.text = '';
    }

    if (!mounted) return;

  },
  ),




          ],
        ),
      ));
  }

// Insert a new instrument to the database
  Future<void> _addInstrument(String instrumentName,
      String? instrumentType,
      String? instrumentManufacturer,
      String? instrumentModel,
      String? instrumentSerialNumber,
      String? instrumentActivityArea,
      String? instrumentFunction,
      String? instrumentComment,
      String instrumentBinomial) async {
    await SQLInstrument.createInstrument(
        instrumentName, instrumentType, instrumentManufacturer, instrumentModel, instrumentSerialNumber, instrumentActivityArea, instrumentFunction, instrumentComment, instrumentBinomial,
    );
    _refreshInstrument();
  }

  // Update an existing instrument
  Future<void> _updateInstrument(int id, instrumentName,
      String? instrumentType,
      String? instrumentManufacturer,
      String? instrumentModel,
      String? instrumentSerialNumber,
      String? instrumentActivityArea,
      String? instrumentFunction,
      String? instrumentComment,
      String instrumentBinomial) async {
    await SQLInstrument.updateInstrument(
        id, instrumentName, instrumentType, instrumentManufacturer, instrumentModel, instrumentSerialNumber, instrumentActivityArea, instrumentFunction, instrumentComment, instrumentBinomial,
    );
    _refreshInstrument();
  }

  // Delete an item
  void _deleteInstrument(id, String instrumentName) async {
    await SQLInstrument.deleteInstrument(id);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('$instrumentName deleted!'),
    ));
    _refreshInstrument();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('N4O Workflow Tool: Instrument'),
        leading: const Icon(Icons.build),
        backgroundColor: Colors.blue,
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
                MaterialPageRoute(builder: (context) => const HelpInstrument()),
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
                MaterialPageRoute(builder: (context) => const HelpInstrument()),
              );

            },
          ),

          IconButton(
            icon: const Icon(Icons.help),
            iconSize: 40,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpInstrument()),
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
        itemCount: _instrument.length,
        itemBuilder: (context, index) => Card(
          color: Colors.blue[200],
          margin: const EdgeInsets.all(15),
          child: ListTile(
              title: Text(_instrument[index]['instrumentName']),
              subtitle: Text(_instrument[index]['instrumentType']),
              trailing: SizedBox(
                width: 150,
                child: Row(
                  children: [
                    IconButton(
                      iconSize: 30,
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showForm(_instrument[index]['id']),
                    ),
                    const SizedBox(
                      width: 30.0,
                    ),
                    IconButton(
                      iconSize: 30,
                      icon: const Icon(Icons.delete),
                      onPressed: () =>
                          _deleteInstrument(_instrument[index]['id'], _instrument[index]['instrumentName']),
                    ),
                  ],
                ),
              )),
        ),
      ),
      
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
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
                      builder: (_) => ImportInstrument(storage: InstrumentImport()),
                  ));
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

        backgroundColor: Colors.blueAccent,
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