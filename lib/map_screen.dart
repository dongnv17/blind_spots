import 'package:flutter/material.dart';
import 'package:location/location.dart' as _userLocal;
import 'package:flutter/services.dart';
import 'package:blind_spots/common/cal_bearing.dart';
import 'package:blind_spots/common/map_def.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:blind_spots/model/location_model.dart';
import 'package:blind_spots/model/location_model.dart' as locationModel;
import 'package:blind_spots/common/util.dart' as util;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => new _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  //private
  Map<String, double> _currentLocation;
  List<LocationArea> _lstLocationArea;
  double _bearing; // ignore: undefined_getter
  GoogleMapController _mapController;

  //public
  MapType _currentMapType = MapType.normal;
  LatLng _center;
  var staticMapProvider;
  var m_zoomLevel = 18.5;

//  MapView mapView;
  _userLocal.Location _location = new _userLocal.Location();
  bool _permission = false;
  String error;
  bool currentWidget = true;

//  List<Marker> lstMarkers;

  //Set-Get
  Map<String, double> get currentLocation => _currentLocation;

  @override
  void initState() {
    super.initState();
//    staticMapProvider = new StaticMapProvider(MapDef.api_key);
//    mapView = new MapView();
    initPlatformState();
    _location.onLocationChanged().listen((Map<String, double> result) {
      setState(() {
        if (_currentLocation != result) {
          if (_currentLocation != null) {
            _bearing = CalBearing.getBearing(
                _currentLocation["latitude"],
                _currentLocation["longitude"],
                result["latitude"],
                result["longitude"]);
            print("_bearing: $_bearing");
//            util.showToast("bearing: $_bearing");
            _mapController.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: _center,
                  zoom: m_zoomLevel,
                  bearing: _bearing,
                ),
              ),
            );
          }
          _currentLocation = result;
          _center = LatLng(result["latitude"], result["longitude"]);
          print("_currentLocation.length ==: $_currentLocation.length");
          print("initState _lstLocationArea: $_lstLocationArea.runtimeType");
          loadLocations();
        }
      });
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onAddMarker() {
    int m_lenght = _lstLocationArea.length;
    _mapController.clearMarkers();
    //Current location
    _mapController.addMarker(
      MarkerOptions(
        anchor: Offset(0.5, 0.5),
        position: LatLng(
          _currentLocation["latitude"],
          _currentLocation["longitude"],
        ),
        icon: BitmapDescriptor.fromAsset("assets/images/my_car.png"),
        rotation: _bearing,
      ),
    );
    // Area location
    for (int i = 1; i <= m_lenght; i++) {
      double userLat = _lstLocationArea[i - 1].lat;
      double useLon = _lstLocationArea[i - 1].lng;
      _mapController.addMarker(
        MarkerOptions(
          position: LatLng(
            userLat,
            useLon,
          ),
          icon: BitmapDescriptor.fromAsset("assets/images/car.png"),
          rotation: _bearing,
        ),
      );
    }
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
//          mapView.setMarkers(getMarker());
          _onAddMarker();
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
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: AppBar(
          title: Text("Blind Spots Maps"),
          backgroundColor: Colors.green[700],
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: _onMapCreated,
              options: GoogleMapOptions(
                trackCameraPosition: true,
                myLocationEnabled: true,
                cameraPosition: CameraPosition(
                  target: _center,
                  zoom: m_zoomLevel,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Column(
                  children: <Widget>[
                    FloatingActionButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      backgroundColor: Colors.green,
                      child: new Center(
                        child: Text(_currentLocation["speed"].toStringAsFixed(1) + "\nm/s", textAlign: TextAlign.center,),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
