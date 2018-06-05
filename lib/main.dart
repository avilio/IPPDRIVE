import 'package:flutter/material.dart';
import 'package:ippdrive/Pages/Login/myLoginPage.dart';
import 'package:ippdrive/Pages/Themes/mainTheme.dart';
import 'package:ippdrive/pages/homePage.dart';
import 'package:ippdrive/pages/layouts/ucContent.dart';

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
    home: new MyLoginPage(),
    debugShowCheckedModeBanner: false,
    theme: buildAppTheme(),
   /* onGenerateRoute: (settings){
      switch (settings.name) {
        case "/listView": (_) => new ListFolder(null,null);
      }
    },*/
    routes: <String, WidgetBuilder>{
      "/login" : (_) => new MyLoginPage(),
    //  "/listView": (_) => new ListFolder(),
      //"/content": (_) => new UcContent(),
    }

));

