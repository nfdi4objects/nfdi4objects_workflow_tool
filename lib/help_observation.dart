import 'package:flutter/material.dart';
import 'main.dart';
import 'design_observation.dart';
import 'package:flag/flag.dart';
import 'help_temp.dart';

void main() => runApp(const HelpObservation());

class HelpObservation extends StatelessWidget {
  const HelpObservation({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ObservationHelp(),
    );
  }
}

class ObservationHelp extends StatelessWidget {
  const ObservationHelp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove the debug banner
        debugShowCheckedModeBanner: false,
        title: 'N4O Workflow Tool: Observation Help',
        theme: ThemeData(
          primarySwatch: Colors.orange,
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
        title: const Text('N4O Workflow Tool: Observation Help'),
        leading: const Icon(Icons.biotech),
        backgroundColor: Colors.orange,
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
      body: const Center(child: Text('Observations are routine measurements, observations, documentation.'
          '\nObservations do not require hypothesis testing.'
          '\nPhoto: photos of the set-up.'
          '\nWeb Page: in case the observation process will be published online.')),

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
                      builder: (context) => const ObservationForm()),
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

        backgroundColor: Colors.orange,
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