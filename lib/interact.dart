import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    title: 'Navigation Basics',
    home: FirstRoute(),
  ));
}

class FirstRoute extends StatelessWidget {
  const FirstRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First Route'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Open route'),
          onPressed: () async {
            String designName = 'RECIPE';
            debugPrint(designName);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SecondRoute(designName: 'designName',)),
            );
          },
        ),
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  final String designName;

  const SecondRoute({super.key, required this.designName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Route: $designName'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back! Idiot! $designName'),
        ),
      ),
    );
  }
}