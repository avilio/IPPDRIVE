import 'package:flutter/material.dart';

import './common/themes/mainTheme.dart';
import './screens/content.dart';
import './screens/login.dart';
import './screens/home.dart';

import './blocs/login_provider.dart';

class IppDrive extends StatefulWidget {
  @override
  _IppDriveState createState() => _IppDriveState();
}


class _IppDriveState extends State<IppDrive> {
  @override
  Widget build(BuildContext context) {

    return  new MaterialApp(
      title: 'IppDrive',
      // home: new LoginPageBloc(),
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      onGenerateRoute: routes,
    );
  }
}

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