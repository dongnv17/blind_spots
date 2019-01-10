import 'package:flutter/material.dart';
import 'package:blind_spots/map_screen.dart';
import 'package:blind_spots/common/map_def.dart';
import 'package:blind_spots/pages/login_page.dart';
void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: new MapScreen(),
  ));
}