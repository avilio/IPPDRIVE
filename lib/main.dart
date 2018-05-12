import 'package:flutter/material.dart';
import 'package:ippdrive/Pages/Login/LoginPage.dart';

import 'package:ippdrive/Pages/Login/LoginPageSecondary.dart';

/*void main() => runApp(new IppDriveApp());

class IppDriveApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Ipp Drive",
      theme: new ThemeData(
        //brightness: Brightness.dark
        primaryColor: Colors.blueGrey[700]
      ),
      home: HomePage(),
      routes: <String, WidgetBuilder>{
        "/listView": (BuildContext context) => new ListFolder()
      }
          );
        }
}
*/

void main() => runApp(new MaterialApp(
  title: 'IppDrive',
  home: new LoginPage(),
  debugShowCheckedModeBanner: false,

));

