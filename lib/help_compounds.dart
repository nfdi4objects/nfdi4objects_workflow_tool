import 'package:flutter/material.dart';
import 'main.dart';
import 'resources_compounds.dart';
import 'package:flag/flag.dart';
import 'help_temp.dart';

void main() => runApp(const HelpCompounds());

class HelpCompounds extends StatelessWidget {
  const HelpCompounds({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CompoundsHelp(),
    );
  }
}

class CompoundsHelp extends StatelessWidget {
  const CompoundsHelp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove the debug banner
        debugShowCheckedModeBanner: false,
        title: 'N4O Workflow Tool: Help',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: const HelpPage());
  }
}

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {


  int helpPageIndex=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //   return const MaterialApp(
        //     title: _title,
        //     home: Scaffold(
        //       appBar: AppBar(
        title: const Text('N4O Workflow Tool'),
        leading: const Icon(Icons.help),
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
      body: const Center(child: Text('Compounds are more complex counterparts to \'substances.\'\nSubstances like \'water\' or \'glue\' require no information other than name and an optional type (\'tap\' or \'distilled\' water, for example.\nCompounds may consist of numerous substances, but may also require more information: \'manufacturer,\' \'batch number,\' etc.')),


      bottomNavigationBar: BottomNavigationBar(

        onTap: (compoundIndex) {
          StepState.disabled.index;
          switch (compoundIndex) {
            case 0:
              {
//                Navigator.of(context).pop();
                setState(() {
                  compoundIndex = 0;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CompoundsForm()),
                );
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
            icon: Icon(Icons.arrow_back),
            label: 'Back',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
//          BottomNavigationBarItem(
//            icon: Icon(Icons.camera_alt),
//            label: 'Photo',
//          ),
        ],
      ),

    );
  }
}