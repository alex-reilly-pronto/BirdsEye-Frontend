import 'package:birdseye/main.dart';
import 'package:birdseye/web.dart';
import 'package:birdseye/widgets/errorcontainer.dart';
import 'package:birdseye/widgets/shfitingfit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  List<MapEntry<String, dynamic>>? _events = [];
  static int season = DateTime.now().year;
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    reloadEvents();
  }

  void reloadEvents() {
    _events = [];
    tbaStock
        .get(SettingsState.season.toString())
        .then(
          (value) => setState(() {
            _events = value.entries.toList();
            var event = prefs.getString('event');
            _events!.sort(
              (a, b) => a.key == event
                  ? -1
                  : b.key == event
                      ? 1
                      : 0,
            );
          }),
        )
        .then(
      (_) {
        if (!prefs.containsKey("event") ||
            !_events!
                .any((element) => element.key == prefs.getString('event'))) {
          prefs.setString("event", _events![0].key);
        }
      },
    ).catchError((error) {
      if (mounted) {
        setState(() {
          _events = null;
        });
      } else {
        _events = null; // yeah whatever you deal with it
      }
    });
  }

  static InputDecoration inputDecoration(BuildContext context) =>
      InputDecoration(
          border: Theme.of(context).brightness == Brightness.light
              ? const UnderlineInputBorder()
              : InputBorder.none,
          counterText: '');

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.all(20),
      child: Row(children: [
        Expanded(
            child: Column(children: [
          ShiftingFit(
              Text(
                "Current Season",
                style: Theme.of(context).textTheme.labelSmall,
                textAlign: TextAlign.left,
              ),
              TextField(
                cursorColor: Colors.green[900],
                style: Theme.of(context).textTheme.bodySmall,
                maxLength: 4,
                textAlign: TextAlign.right,
                keyboardType: TextInputType
                    .text, // Not 'number' because apple number keyboard has no enter
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: inputDecoration(context),
                controller: TextEditingController(text: season.toString()),
                onSubmitted: (content) {
                  season = int.parse(content);
                },
              )),
          ShiftingFit(
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
              decoration: inputDecoration(context),
              controller: TextEditingController(
                  text: prefs.getString("name") ?? "null"),
              onSubmitted: (value) {
                prefs.setString("name", value).then((value) =>
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Set Name!"))));
              },
            ),
          ),
          const IPConfigField()
        ])),
        VerticalDivider(
          color: Theme.of(context).textTheme.labelSmall!.color,
          width: 24,
        ),
        Expanded(
            child: ShiftingFit(
          Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                "Current Event",
                style: Theme.of(context).textTheme.labelSmall,
                textAlign: TextAlign.left,
              )),
          _events == null
              ? const ErrorContainer("Error")
              : _events!.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      controller: _controller,
                      shrinkWrap: true,
                      children: [
                          for (int i = 0; i < _events!.length; i++)
                            ListTile(
                                key: ValueKey(_events![i].key),
                                onTap: () async {
                                  await prefs.setString(
                                      "event", _events![i].key);
                                  _controller.animateTo(0,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.easeOutCubic);
                                  var event = _events![i].key;
                                  setState(() {
                                    _events!.sort(
                                      (a, b) => a.key == event
                                          ? -1
                                          : b.key == event
                                              ? 1
                                              : 0,
                                    );
                                  });
                                },
                                title: Text(
                                  _events![i].value,
                                  overflow: TextOverflow.clip,
                                  maxLines: 1,
                                  textAlign: TextAlign.right,
                                  style: _events![i].key ==
                                          prefs.getString('event')
                                      ? Theme.of(context)
                                          .textTheme
                                          .displaySmall!
                                          .copyWith(fontWeight: FontWeight.w800)
                                      : Theme.of(context)
                                          .textTheme
                                          .displaySmall,
                                ),
                                trailing: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                      minWidth: 60, maxWidth: 60),
                                  child: Text(_events![i].key,
                                      textAlign: TextAlign.right,
                                      style: _events![i].key ==
                                              prefs.getString('event')
                                          ? Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                  fontWeight: FontWeight.w900)
                                          : Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                  fontWeight: FontWeight.w500)),
                                ))
                        ]),
          ignoreBasline: true,
        )),
      ]));
}

class IPConfigField extends StatefulWidget {
  const IPConfigField({super.key});

  @override
  State<StatefulWidget> createState() => IPConfigFieldState();
}

class IPConfigFieldState extends State<IPConfigField> {
  final _controller = TextEditingController(text: prefs.getString("ip"));
  bool _enabled = true;

  @override
  Widget build(BuildContext context) => ShiftingFit(
        Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Server IP",
              style: Theme.of(context).textTheme.labelSmall,
              textAlign: TextAlign.left,
            )),
        TextField(
          enabled: _enabled,
          cursorColor: Colors.green[900],
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.right,
          maxLines: 1,
          maxLength: 64,
          keyboardType: TextInputType.url,
          controller: _controller,
          textCapitalization: TextCapitalization.none,
          decoration: SettingsState.inputDecoration(context),
          onSubmitted: (content) {
            setState(() {
              _enabled = false;
            });
            getStatus(content).then((value) {
              if (value) {
                prefs.setString("ip", content);
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text("Set IP!")));
              } else {
                _controller.text = prefs.getString("ip")!;
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text("Invalid IP!")));
              }
              setState(() {
                _enabled = true;
              });
            });
          },
        ),
      );
}
