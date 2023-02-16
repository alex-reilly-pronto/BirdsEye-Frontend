import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'matchscout.dart';
import 'pitscout.dart';
import 'web.dart';

void main() async {
  prefs = await SharedPreferences.getInstance();
  runApp(MaterialApp(
      title: "Bird's Eye",
      initialRoute: "/",
      routes: {
        "/matchscout": (BuildContext context) => const MatchScout(),
        "/pitscout": (BuildContext context) => const PitScout(),
        "/": (BuildContext context) => const MainScreen()
      },
      theme: ThemeData(
        colorScheme: ColorScheme.dark(
            primary: Colors.blue[600]!,
            surface: const Color(0xffcf2e2e),
            background: Colors.black),
        scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(1),
            trackVisibility: MaterialStateProperty.all(true)),
        inputDecorationTheme:
            const InputDecorationTheme(border: OutlineInputBorder()),
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          closeIconColor: Colors.black,
          elevation: 3,
          contentTextStyle: TextStyle(
              fontFamily: "OpenSans",
              fontSize: 18,
              fontWeight: FontWeight.normal,
              color: Colors.black),
        ),
        appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(
                // AppBar Title
                fontFamily: "Verdana",
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 28)),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
            color: Color(0xffcf2e2e), refreshBackgroundColor: Colors.black45),
        dividerTheme: const DividerThemeData(thickness: 4, indent: 0),
        textTheme: TextTheme(
            displayLarge: const TextStyle(
              // Match Scout Section Titles
              fontFamily: "VarelaRound",
              fontSize: 36,
              letterSpacing: 5,
              fontWeight: FontWeight.w900,
            ),
            displaySmall: TextStyle(
                // Settings Option List
                fontFamily: "OpenSans",
                fontSize: 16,
                fontWeight: FontWeight.w200,
                color: Colors.green[700]),
            labelMedium: const TextStyle(
              // Drawer Items
              fontFamily: "Verdana",
              fontSize: 20,
            ),
            labelSmall: TextStyle(
                // Settings Title
                fontFamily: "RobotoMono",
                fontWeight: FontWeight.w900,
                fontSize: 16,
                letterSpacing: 2,
                color: Colors.green[700]),
            bodyMedium: const TextStyle(
                // Form Field Titles & Hover Tooltips
                fontFamily: "OpenSans",
                fontSize: 26,
                fontWeight: FontWeight.w500,
                color: Colors.white70),
            bodySmall: TextStyle(
                // Settings Input
                fontFamily: "Calibri",
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Colors.green[700])),
        scaffoldBackgroundColor: Colors.black,
      )));
}

SharedPreferences? prefs;
String serverIP = "localhost:5000";

getDrawer(context) => Drawer(
        child: ListView(
      children: [
        ListTile(
          title: Text(
            "Home",
            style: Theme.of(context).textTheme.labelMedium,
          ),
          onTap: () {
            Navigator.of(context)
                .pushReplacement(_createRoute(const MainScreen()));
          },
        ),
        ListTile(
          title: Text(
            "Match Scouting",
            style: Theme.of(context).textTheme.labelMedium,
          ),
          onTap: () {
            Navigator.of(context)
                .pushReplacement(_createRoute(const MatchScout()));
          },
        ),
        ListTile(
          title: Text(
            "Pit Scouting",
            style: Theme.of(context).textTheme.labelMedium,
          ),
          onTap: () {
            Navigator.of(context)
                .pushReplacement(_createRoute(const PitScout()));
          },
        ),
      ],
    ));

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: const Text("Bird's Eye"),
        ),
        drawer: getDrawer(context),
        body: const Settings(),
        floatingActionButton: IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: "Refresh Cache",
            onPressed: cacheSoT.deleteAll),
      );
}

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<StatefulWidget> createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  List<MapEntry<String, dynamic>>? _events;
  static num season = DateTime.now().year;
  static String event = "casf";

  @override
  void initState() {
    super.initState();
    stock.get(WebDataTypes.currentEvents).then(
          (value) => setState(() {
            _events = value.entries.toList();
            _events!.sort(
              (a, b) => a.key == event
                  ? -1
                  : b.key == event
                      ? 1
                      : 0,
            );
          }),
        );
  }

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.all(20),
      child: Row(children: [
        Expanded(
            child: Column(children: [
          Stack(
            alignment: Alignment.center,
            fit: StackFit.passthrough,
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Current Season",
                    style: Theme.of(context).textTheme.labelSmall,
                    textAlign: TextAlign.left,
                  )),
              TextField(
                cursorColor: Colors.green[900],
                style: Theme.of(context).textTheme.bodySmall,
                maxLength: 4,
                textAlign: TextAlign.right,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                    border: InputBorder.none, counterText: ''),
                controller: TextEditingController(text: season.toString()),
                onSubmitted: (content) {
                  season = int.parse(content);
                },
              )
            ],
          ),
          Stack(
            alignment: Alignment.center,
            fit: StackFit.passthrough,
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Your Name",
                    style: Theme.of(context).textTheme.labelSmall,
                    textAlign: TextAlign.left,
                  )),
              TextField(
                cursorColor: Colors.green[900],
                style: Theme.of(context).textTheme.bodySmall,
                maxLength: 64,
                textAlign: TextAlign.right,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                    border: InputBorder.none, counterText: ''),
                controller: TextEditingController(
                    text: prefs!.getString("name") ?? "NoName"),
                onSubmitted: (value) {
                  prefs!.setString("name", value).then((value) =>
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Set Name!"))));
                },
              )
            ],
          ),
          Stack(
            alignment: Alignment.center,
            fit: StackFit.passthrough,
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Server IP",
                    style: Theme.of(context).textTheme.labelSmall,
                    textAlign: TextAlign.left,
                  )),
              TextField(
                cursorColor: Colors.green[900],
                style: Theme.of(context).textTheme.bodySmall,
                maxLength: 24,
                textAlign: TextAlign.right,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                    border: InputBorder.none, counterText: ''),
                controller: TextEditingController(text: serverIP),
                onSubmitted: (content) => getStatus(content).then((value) {
                  if (value) {
                    serverIP = content;
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text("Set IP!")));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Invalid IP!")));
                  }
                }),
              )
            ],
          )
        ])),
        VerticalDivider(
          color: Theme.of(context).textTheme.labelSmall!.color,
          width: 32,
        ),
        Expanded(
            child: Stack(children: [
          Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              alignment: Alignment.topLeft,
              child: Text(
                "Current Event",
                style: Theme.of(context).textTheme.labelSmall,
                textAlign: TextAlign.left,
              )),
          Builder(builder: (context) {
            if (_events == null) {
              return const Center(child: CircularProgressIndicator());
            }
            return ReorderableListView(
                shrinkWrap: true,
                buildDefaultDragHandles: false,
                onReorder: (int oldIndex, int newIndex) {
                  setState(() {
                    if (oldIndex < newIndex) {
                      newIndex--;
                    }
                    final item = _events!.removeAt(oldIndex);
                    _events!.insert(newIndex, item);
                    if (newIndex == 0) event = item.key;
                  });
                },
                children: [
                  for (int i = 0; i < _events!.length; i++)
                    ReorderableDragStartListener(
                        key: ValueKey(_events![i].key),
                        index: i,
                        child: ListTile(
                          onTap: () {
                            setState(() {
                              event = _events![i].key;
                            });
                          },
                          title: Text(
                            _events![i].value,
                            textAlign: TextAlign.right,
                            style: _events![i].key == event
                                ? Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(fontWeight: FontWeight.w800)
                                : Theme.of(context).textTheme.displaySmall,
                          ),
                          trailing: ConstrainedBox(
                              constraints: const BoxConstraints(
                                  minWidth: 60, maxWidth: 60),
                              child: Text(_events![i].key,
                                  textAlign: TextAlign.right,
                                  style: _events![i].key == event
                                      ? Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(fontWeight: FontWeight.w900)
                                      : Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                              fontWeight: FontWeight.w600))),
                        ))
                ]);
          })
        ]))
      ]));
}

Route _createRoute(Widget widget) => PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => widget,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var tween = Tween(begin: const Offset(1, 0), end: Offset.zero)
          .chain(CurveTween(curve: Curves.easeOut));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    });
