import 'package:flutter/material.dart';
import 'package:location/location.dart' as _userLocal;
import 'package:flutter/services.dart';
import 'package:map_view/map_view.dart';
import 'dart:async';
import 'package:blind_spots/common/map_def.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:blind_spots/model/location_model.dart';
import 'package:blind_spots/services/location_services.dart';
import 'package:blind_spots/test/product_services.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => new _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  var staticMapProvider;
  Map<String, double> _startLocation;
  var m_zoomLevel = 18.5;
//  CameraPosition cameraPosition;
  Map<String, double> get startLocation => _startLocation;
  Map<String, double> _currentLocation;
  Map<String, double> get currentLocation => _currentLocation;
  MapView mapView;

  _userLocal.Location _location = new _userLocal.Location();
  bool _permission = false;
  String error;

  bool currentWidget = true;

  Image image1;

  @override
  void initState() {
    super.initState();
    staticMapProvider = new StaticMapProvider(MapDef.api_key);
    mapView = new MapView();
    initPlatformState();
    _location.onLocationChanged().listen((Map<String,double> result) {
      setState(() {
        _currentLocation = result;
      });
    });
    loadLocations();
    fetchGet();
    loadProduct();
//    cameraPosition = new CameraPosition(new Location(_startLocation["latitude"], _startLocation["longitude"]), m_zoomLevel);
  }

  fetchGet() async{
    print("fetchGet async");
    final response =
    await http.get(MapDef.urlServer);
    if (response.statusCode == 200) {
      print("async response: $response.statusCode");
      Map  jsonBody = json.decode(response.body);
      int _status = jsonBody['status'];
      print("fetchGet async jsonBody: $jsonBody");
      print('fetchGet async jsonBody.status: $_status');
      print("fetchGet async jsonBody.curLat: $jsonBody['curLat']");
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    Map<String, double> location;
    // Platform messages may fail, so we use a try/catch PlatformException.

    try {
      _permission = await _location.hasPermission();
      location = await _location.getLocation();


      error = null;
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'Permission denied - please ask the user to enable it from the app settings';
      }

      location = null;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    //if (!mounted) return;

    setState(() {
      _startLocation = location;
    });

  }
  showMap() {

    mapView.show(new MapOptions(
        mapViewType: MapViewType.normal,
        initialCameraPosition: new CameraPosition(new Location(_currentLocation["latitude"], _currentLocation["longitude"]), m_zoomLevel),
        showUserLocation: false,
        title: "Recent Location"));
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: showMap(),
      ),
    );
  }
}
