import 'package:flutter/material.dart';
import 'package:ippdrive/Pages/list_folder.dart';

import './Pages/home_page.dart';

void main() => runApp(new IppDriveApp());

class IppDriveApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Ipp Drive",
      theme: new ThemeData(
        //brightness: Brightness.dark
        primaryColor: Colors.blueGrey[700]
      ),
      home: new HomePage(),
      routes: <String, WidgetBuilder>{
        "/listView": (BuildContext context) => new ListFolder()
      }
          );
        }
}