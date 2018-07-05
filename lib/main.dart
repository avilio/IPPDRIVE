import 'package:flutter/material.dart';

import './src/common/themes/mainTheme.dart';
import './src/screens/content.dart';
import './src/screens/login.dart';
import './src/screens/home.dart';
import './src/blocs/login_provider.dart';
import './src/blocs/favorites_provider.dart';
import './src/blocs/home_provider.dart';
import './src/blocs/drawer_provider.dart';

void main() => runApp(
      DrawerProvider(
        child: FavoritesProvider(
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
      ),
    );

Route routes(RouteSettings settings){
  switch(settings.name){
    case "/" : return MaterialPageRoute(
        builder: (context)=> LoginPage()
    );break;
    case "/home" : return MaterialPageRoute(
      builder: (context)=> HomePage()
    );break;
    case "/content" : return MaterialPageRoute(
      builder: (context){
        //get do id para ir buscar cadeiras
        settings.name.replaceFirst("/", "");

        return Content();}
    );break;
  }
  return null;
}