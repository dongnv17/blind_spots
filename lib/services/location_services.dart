import 'dart:convert';
import 'dart:async';
import 'package:blind_spots/model/location_model.dart';
import 'package:blind_spots/common/map_def.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

Future<String> _loadLocationsAsset() async {
  return await rootBundle.loadString('assets/locations.json');
}

//load from local test
//loadLocations() async{
//  String jsonLocations = await _loadLocationsAsset();
//  final jsonResponse = json.decode(jsonLocations);
//  print("loadLocations jsonResponse $jsonResponse");
//  Locations locations = new Locations.fromJson(jsonResponse);
//  print(locations.lstLocationArea[0].user);
//}
//load from server
loadLocations() async {
  print('load locations');
  final response = await http.get(MapDef.urlServer);
  if (response.statusCode == 200) {
    print('load locations success');
    final  jsonBody = json.decode(response.body);
    print("loadLocations async jsonBody: $jsonBody");
    Locations locations = new Locations.fromJson(jsonBody);
    print('load locations final');
    print(locations.lstLocationArea[0].user);
  }
}
