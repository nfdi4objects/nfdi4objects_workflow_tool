import 'package:flutter/material.dart';
import 'main.dart';
import 'design_recipe.dart';
import 'package:flag/flag.dart';
import 'help_temp.dart';

void main() => runApp(const HelpRecipe());

class HelpRecipe extends StatelessWidget {
  const HelpRecipe({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HelpInfo(),
    );
  }
}

class HelpInfo extends StatelessWidget {
  const HelpInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove the debug banner
        debugShowCheckedModeBanner: false,
        title: 'N4O Workflow Tool: Help',
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
        title: const Text('N4O Workflow Tool: Recipe Help'),
        leading: const Icon(Icons.restaurant_menu_outlined),
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
      body: const Center(child: Text('Temporary Recipe Help Page. Recipe of artifacts for use in reenactment, experiments, etc.'
          '\nPhoto: photos of the recipe set-up.'
          '\nWeb Page: in case the recipe process will be published online.')),

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
                      builder: (context) => const RecipeForm()),
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