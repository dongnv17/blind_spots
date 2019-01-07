import 'package:flutter/material.dart';
import 'package:location/location.dart' as _userLocal;
import 'package:flutter/services.dart';
import 'package:map_view/map_view.dart';
import 'dart:async';
import 'package:blind_spots/common/map_def.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:blind_spots/model/location_model.dart';
import 'package:blind_spots/services/location_services.dart' as locationService;
import 'package:blind_spots/test/product_services.dart';
import 'package:blind_spots/model/location_model.dart' as locationModel;
import 'package:blind_spots/common/util.dart' as util;

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => new _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  //private
  Map<String, double> _currentLocation;
  Map<String, double> _startLocation;
  List<LocationArea> _lstLocationArea;

  //public
  var staticMapProvider;
  var m_zoomLevel = 18.5;
  MapView mapView;
  _userLocal.Location _location = new _userLocal.Location();
  bool _permission = false;
  String error;
  bool currentWidget = true;
  List<Marker> lstMarkers;

  //Set-Get
  Map<String, double> get startLocation => _startLocation;

  Map<String, double> get currentLocation => _currentLocation;

  @override
  void initState() {
    super.initState();
    staticMapProvider = new StaticMapProvider(MapDef.api_key);
    mapView = new MapView();
    initPlatformState();
    _location.onLocationChanged().listen((Map<String, double> result) {
      setState(() {
        if (_currentLocation != result) {
          _currentLocation = result;
          print("initState _lstLocationArea: $_lstLocationArea.runtimeType");
          loadLocations();
        }
      });
    });
  }

  List<Marker> getMarker() {
    double cuLat = _currentLocation["latitude"];
    util.showToast("getMarker--: $cuLat");
    List<Marker> markers = <Marker>[
      new Marker(
        "1",
        "The Lalit",
        _currentLocation["latitude"],
        _currentLocation["longitude"],
        color: Colors.amber,
        markerIcon: new MarkerIcon(
          "assets/images/car.png",
          width: 88.0,
          height: 103.0,
        ),
        draggable: true,
      ),
      new Marker(
        "2",
        "Tech mahindra",
        21.0169795,
        105.7824433,
        color: Colors.red,
        draggable: true,
      ),
      new Marker(
        "3",
        "Infosys",
        21.0169895,
        105.7824433,
        color: Colors.green,
        draggable: true,
      ),
    ];
    return markers;
  }

  //load from server
  loadLocations() async {
    print('load locations');
    try {
      final response = await http.get(util.setUrlServer(
          100, _currentLocation["latitude"], _currentLocation["longitude"]));
      if (response.statusCode == 200) {
        print('load locations success');
        final jsonBody = json.decode(response.body);
        print("loadLocations async jsonBody: $jsonBody");
        setState(() {
          locationModel.Locations objLocations =
              new locationModel.Locations.fromJson(jsonBody);
          _lstLocationArea = objLocations.lstLocationArea as List<LocationArea>;
          print("loadLocations _lstLocationArea");
          print(_lstLocationArea[0].user);
          double cuLat = _currentLocation["latitude"];
          print("loadLocations $cuLat");
//          mapView.clearAnnotations();
          mapView.setMarkers(getMarker());
        });
      }
    } on Exception catch (e) {
      print("Error get URL");
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
        error =
            'Permission denied - please ask the user to enable it from the app settings';
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: showMap(),
      ),
    );
  }

  showListCar() {}

  showMap() {
    mapView.show(new MapOptions(
        mapViewType: MapViewType.normal,
        initialCameraPosition: new CameraPosition(
            new Location(
                _currentLocation["latitude"], _currentLocation["longitude"]),
            m_zoomLevel),
        showUserLocation: true,
        title: "Recent Location"));
  }
}
