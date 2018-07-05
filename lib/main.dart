import 'package:flutter/material.dart';


import 'package:ippdrive/views/homePage.dart';
import 'package:ippdrive/views/loginPage.dart';
import 'package:ippdrive/views/themes/mainTheme.dart';
import 'package:ippdrive/views/ucContentPage.dart';

import './reformat/screens/login.dart';
import './reformat/blocs/login_provider.dart';
import './reformat/blocs/favorites_provider.dart';
import './reformat/blocs/home_provider.dart';

void main() => runApp(
      FavoritesProvider(
        child: HomeProvider(
          child: LoginProvider(
            child: new MaterialApp(
              title: 'IppDrive',
             // home: new LoginPageBloc(),
              debugShowCheckedModeBanner: false,
              theme: buildAppTheme(),
              onGenerateRoute: routes,
            ),
          ),
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