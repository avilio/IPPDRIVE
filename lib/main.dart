import 'package:flutter/material.dart';
import 'package:ippdrive/pages/loginPage.dart';
import 'package:ippdrive/Pages/Themes/mainTheme.dart';

void main() => runApp(new MaterialApp(
      title: 'IppDrive',
      home: new LoginPage(),
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      /* onGenerateRoute: (settings){
      switch (settings.name) {
        case "/listView": (_) => new ListFolder(null,null);
      }
    },*/
      /* routes: <String, WidgetBuilder>{
    //  "/login" : (_) => new LoginPage(),
    //  "/listView": (_) => new ListFolder(),
      //"/content": (_) => new UcContent(),
    }*/
    ));
