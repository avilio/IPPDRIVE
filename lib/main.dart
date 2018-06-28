import 'package:flutter/material.dart';
import 'package:ippdrive/views/homePage.dart';

import 'package:ippdrive/views/loginPage.dart';
import 'package:ippdrive/views/themes/mainTheme.dart';
import 'package:ippdrive/views/ucContentPage.dart';

void main() => runApp(
      new MaterialApp(
          title: 'IppDrive',
          home: new LoginPage(),
          debugShowCheckedModeBanner: false,
          theme: buildAppTheme(),

          /* onGenerateRoute: (settings){

        switch (settings.name) {

          case "/listView": (_) => new ListFolder(null,null);

        }

      },*/

          routes: <String, WidgetBuilder>{
            "/login": (_) => new LoginPage(),
            "/home": (_) => new HomePage(),
            "/content": (_) => new UcContent(),
          }),
    );
