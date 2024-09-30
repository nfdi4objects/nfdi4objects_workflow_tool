import 'package:flutter/material.dart';
import 'main.dart';
import 'package:flag/flag.dart';
import 'help_temp.dart';

void main() => runApp(const Zotero());

class Zotero extends StatelessWidget {
  const Zotero({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ZoteroInfo(),
    );
  }
}

class ZoteroInfo extends StatelessWidget {
  const ZoteroInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove the debug banner
        debugShowCheckedModeBanner: false,
        title: 'N4O Workflow Tool: References',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        home: const ZoteroPage());
  }
}

class ZoteroPage extends StatefulWidget {
  const ZoteroPage({super.key});

  @override
  State<ZoteroPage> createState() => _ZoteroPageState();
}

class _ZoteroPageState extends State<ZoteroPage> {


  int zoteroPageIndex=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //   return const MaterialApp(
        //     title: _title,
        //     home: Scaffold(
        //       appBar: AppBar(
        title: const Text('N4O Workflow Tool: References'),
        leading: const Icon(Icons.menu_book),
        backgroundColor: Colors.blueGrey,

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
      body: const Center(child: Text('Temporary References Page\nWill link to Zotero and/or\nThe EXARC Experimental Archaeology Collection (https://exarc.net/bibliography)')),

      bottomNavigationBar: BottomNavigationBar(

        onTap: (compoundIndex) {
          StepState.disabled.index;
          switch (compoundIndex) {
            case 0:
              {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NFDIexperimentApp()),
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

        backgroundColor: Colors.blueGrey,
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