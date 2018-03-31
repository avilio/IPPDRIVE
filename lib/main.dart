import 'package:flutter/material.dart';

import './Pages/home_page.dart';

void main() => runApp(new IppDriveApp());

class IppDriveApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Ipp Drive",
      theme: new ThemeData(
        accentColor: Colors.yellowAccent,
        brightness: Brightness.dark
      ),
      home: new HomePage(),
          );
        }
}