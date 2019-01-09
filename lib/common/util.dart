import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

showToast(String inpuText)
{
  Fluttertoast.showToast(
      msg: "$inpuText",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white
  );
}
String setUrlServer(int distance, double lat, double lon)
{
  String urlServer = "https://tony-map-api.herokuapp.com/distance/$distance/lat/$lat/lon/$lon";
  print("setUrlServer: $urlServer");
  return urlServer;
}
