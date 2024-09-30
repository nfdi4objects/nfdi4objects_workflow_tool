import 'package:flutter/material.dart';
import 'resources_personnel.dart';
import 'resources_instruments.dart';
import 'resources_substances.dart';
import 'resources_compounds.dart';
import 'resources_tools.dart';
import 'help_temp.dart';
import 'main.dart';
import 'zotero.dart';
import 'package:flag/flag.dart';

void main()  => runApp(const AvailableResources());

class AvailableResources extends StatelessWidget {
  const AvailableResources({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Available Resources',
      // Set Raleway as the default app font.
      theme: ThemeData(fontFamily: 'Raleway'),
      home: const ResourcesPage(),
    );
  }
}

class ResourcesPage extends StatefulWidget {
  const ResourcesPage({super.key});

  @override
  State<ResourcesPage> createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage> {

  int resourcesIndex=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: const Text('N4O Workflow Tool: Resources'),
        leading: const Icon(Icons.shopping_cart),
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
          MaterialPageRoute(builder: (context) => const HelpTemp()),
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
                MaterialPageRoute(builder: (context) => const HelpTemp()),
              );

            },
          ),

          IconButton(
            icon: const Icon(Icons.help),
            iconSize: 40,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpTemp()),
              );

            },
          ),
        ],
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: <Widget>[

            const Text(
              'Enter or edit information about your Personnel:',
              style: TextStyle(
                  fontSize: 20),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(width: 16),

                FloatingActionButton.extended(
                  heroTag: "btnMi",
                  backgroundColor: Colors.deepOrange,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PersonForm(institutionNameOut: '', people: [],)),
                    );
                  },
                  label: const Text('Personnel'),
                  icon: const Icon(Icons.person),
                ),
              ],
            ),

            const Text(
              'Enter or edit Instrument or Tools:',
              style: TextStyle(
                  fontSize: 20),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
//                const Text('Input Instrument or Tools'),
                const SizedBox(width: 16),

                FloatingActionButton.extended(
                  heroTag: "btnRInstrument",
                  backgroundColor: Colors.blue,
                  onPressed: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const InstrumentForm()),
                    );

                  },
                  label: const Text('Instrument'),
                  icon: const Icon(Icons.build),
                ),

                FloatingActionButton.extended(
                  heroTag: "btnRTools",
                  backgroundColor: Colors.lightBlue,
                  onPressed: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ToolsForm()),
                    );

                  },
                  label: const Text('Tools'),
                  icon: const Icon(Icons.build_outlined),
                ),


              ],
            ),

            const Text(
              'Enter or edit Compounds or Substances:',
              style: TextStyle(
                  fontSize: 20),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
//                const Text('Input Materials'),
                const SizedBox(width: 16),

                FloatingActionButton.extended(
                  heroTag: "btnRCompounds",
                  backgroundColor: Colors.purple,
                  onPressed: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CompoundsForm()),
                    );

                  },
                  label: const Text('Compounds'),
                  icon: const Icon(Icons.shopping_cart),
                ),

                FloatingActionButton.extended(
                  heroTag: "btnRSubstances",
                  backgroundColor: Colors.purpleAccent,
                  onPressed: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SubstancesForm()),
                    );

                  },
                  label: const Text('Substances'),
                  icon: const Icon(Icons.shopping_cart_outlined),
                ),

              ],
            ),


            const Text(
              'Enter or edit References (publications or samples):',
              style: TextStyle(
                  fontSize: 20),
            ),

    Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
//                const Text('Input Materials'),
    const SizedBox(width: 16),

            FloatingActionButton.extended(
              heroTag: "btnReferences",
              backgroundColor: Colors.blueGrey,
              onPressed: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Zotero()),
                );

              },
              label: const Text('References'),
              icon: const Icon(Icons.menu_book),
            ),


          ],
        ),

//            Row(
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
//                const Text('Input Actions'),
//                const SizedBox(width: 16),
//
//                FloatingActionButton.extended(
//                  heroTag: "btnMAction",
//                  backgroundColor: Colors.teal,
//                  onPressed: () {
//
////                    Navigator.push(
////                      context,
////                      MaterialPageRoute(builder: (context) => const ActionTemp()),
////                    );
//
//                  },
//                  label: const Text('Action'),
//                  icon: const Icon(Icons.directions_run),
//                ),
//              ],
//            ),
  //        ],

//      Row(
//        mainAxisAlignment: MainAxisAlignment.center,
//        children: <Widget>[
//          const Text('Input References'),
//          const SizedBox(width: 16),

//          FloatingActionButton.extended(
//            heroTag: "btnR7",
//            backgroundColor: Colors.purpleAccent,
//            onPressed: () {
//
//              Navigator.push(
//                context,
//                MaterialPageRoute(builder: (context) => const NFDIexperimentReference()),
//              );
//
//            },
//            label: const Text('References'),
//            icon: const Icon(Icons.menu_book),
//          ),
//
//          FloatingActionButton.extended(
//            heroTag: "btnR8",
//            backgroundColor: Colors.purple[100],
//            onPressed: () {
//
//              Navigator.push(
//                context,
//                MaterialPageRoute(builder: (context) => Zotero()),
//              );
//
//            },
//            label: const Text('Zotero'),
//            icon: const Icon(Icons.menu_book),
//          ),
//
//        ],
//      ),

      ],
        ),

     ),

      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle: const TextStyle(color: Colors.white),
        unselectedLabelStyle: const TextStyle(color: Colors.white),
        onTap: (resourcesIndex) {
          StepState.disabled.index;
          switch (resourcesIndex) {
            case 0:
              {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NFDIexperimentApp()),
                );
                setState(() {
                  resourcesIndex = 0;
                });
              }

              break;

            case 1:
              {
                setState(() {
                  resourcesIndex = 1;
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
//                  resourcesIndex = 2;
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

        backgroundColor: Colors.cyanAccent,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_back,
                color: Colors.white),
            label: 'Back',
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
