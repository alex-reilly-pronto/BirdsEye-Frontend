import 'package:flutter/material.dart';

import 'matchscout.dart';
import 'pitscout.dart';
import 'web.dart';

void main() => runApp(const BirdsEye());
const version = "0.0.1";
String userid = "6658";
// TODO: These all need to be settable
num teamNumber = 4159;
num season = 2023;
String event = "casf2023";
String name = "Max";
//

class BirdsEye extends StatelessWidget {
  const BirdsEye({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Bird's Eye",
      home: const MainScreen(),
      theme: ThemeData(
          brightness:
              Brightness.dark), // TODO: We need to use themes to customize
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bird's Eye"),
      ),
      drawer: Drawer(
          // TODO: Nested Navigation https://docs.flutter.dev/cookbook/effects/nested-nav
          child: ListView(
        children: [
          ListTile(
            title: const Text("Match Scouting"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MatchScout()));
            },
          ),
          ListTile(
            title: const Text("Pit Scouting"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const PitScout()));
            },
          ),
          const AboutListTile(
            icon: Icon(Icons.info_outline_rounded),
            applicationVersion: version,
          )
        ],
      )),
      body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Current Season",
                        textAlign: TextAlign.left,
                      )),
                  TextField(
                    maxLength: 4,
                    textAlign: TextAlign.right,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        border: InputBorder.none, counterText: ''),
                    controller: TextEditingController(
                        text: DateTime.now().year.toString()),
                    onSubmitted: (value) {
                      season = int.parse(value);
                    },
                  )
                ],
              )
            ],
          )),
      floatingActionButton: IconButton(
        icon: const Icon(Icons.refresh_rounded),
        tooltip: "Refresh Cache",
        onPressed: cacheSoT.deleteAll,
      ),
    );
  }
}

const double buttonBaseline = 30;
