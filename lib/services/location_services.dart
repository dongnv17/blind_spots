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
loadLocations() async{
  String jsonLocations = await _loadLocationsAsset();
  final jsonResponse = json.decode(jsonLocations);
  print("loadLocations jsonResponse $jsonResponse");
  Locations locations = new Locations.fromJson(jsonResponse);
  print(locations.lstLocationArea[0].user);
}

