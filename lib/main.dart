import 'package:flutter/material.dart';
import 'package:ippdrive/reformat/blocs/login_provider.dart';
import 'package:ippdrive/reformat/login/login.dart';
import 'package:ippdrive/views/homePage.dart';

import 'package:ippdrive/views/loginPage.dart';
import 'package:ippdrive/views/themes/mainTheme.dart';
import 'package:ippdrive/views/ucContentPage.dart';

void main() => runApp(
      LoginProvider(
        child: new MaterialApp(
          title: 'IppDrive',
          home: new LoginPageBloc(),
          debugShowCheckedModeBanner: false,
          theme: buildAppTheme(),
          onGenerateRoute: routes,
        ),
      ),
    );

Route routes(RouteSettings settings){
  switch(settings.name){
    case "/" : return MaterialPageRoute(
        builder: (context)=> LoginPageBloc()
    );break;
    case "/home" : return MaterialPageRoute(
      builder: (context)=> HomePage()
    );break;
    case "/content" : return MaterialPageRoute(
      builder: (context){
        //get do id para ir buscar cadeiras
        settings.name.replaceFirst("/", "");

        return UcContent();}
    );break;
  }
  return null;
}