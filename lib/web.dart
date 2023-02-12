import 'dart:convert';

import 'package:birdseye/main.dart';
import 'package:http/http.dart' as http;
import 'package:stock/stock.dart';

enum WebDataTypes { pitScout, matchScout, currentEvents }

CachedSourceOfTruth<WebDataTypes, Map<String, dynamic>> cacheSoT =
    CachedSourceOfTruth();
final stock = Stock<WebDataTypes, Map<String, dynamic>>(
  fetcher:
      Fetcher.ofFuture<WebDataTypes, Map<String, dynamic>>((dataType) async {
    switch (dataType) {
      case WebDataTypes.pitScout:
        return json.decode((await http.get(
                Uri.http(serverIP, "/api/${SettingsState.season}/pitschema/")))
            .body);
      case WebDataTypes.matchScout:
        return json.decode((await http.get(Uri.http(
                serverIP, "/api/${SettingsState.season}/matchschema/")))
            .body);
      case WebDataTypes.currentEvents: // trust the process
        return json.decode((await http
                .get(Uri.http(serverIP, "/api/bluealliance/getCurrentEvents/")))
            .body);
    }
  }),
  sourceOfTruth: cacheSoT,
);

Future<http.Response> postResponse(
    WebDataTypes dataType, Map<String, dynamic> body) {
  switch (dataType) {
    case WebDataTypes.pitScout:
      return http.post(
          Uri.http(serverIP,
              "/api/${SettingsState.season}/${SettingsState.event}/pit/"),
          body: json.encode(body));
    case WebDataTypes.matchScout:
      return http.post(
          Uri.http(serverIP,
              "/api/${SettingsState.season}${SettingsState.event}/match"),
          body: json.encode(body),
          headers: {"Content-Type": "application/json"});
    default:
      return Future.error(
          Exception("Unsupported Post-Response WebDataType $dataType"));
  }
}
