import 'package:flutter/material.dart';

import 'package:ippdrive/views/themes/colorsThemes.dart';

import '../models/user.dart';
import '../screens/login.dart';
import '../blocs/home_provider.dart';
import '../blocs/home_bloc.dart';
import '../widgets/drawer/drawer_years_list.dart';
import '../widgets/drawer/drawer_favorites_list.dart';
import '../widgets/drawer/drawer_ippDrive_list.dart';

class MyDrawer extends StatelessWidget {
  final PaeUser paeUser;

  final dynamic courseUnits;

  MyDrawer(
      {this.paeUser, this.courseUnits, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeBloc = HomeProvider.of(context);

    String school, course;

    /// Trata as variaveis que se vierem a null, consoante o tipo de variavel da courseUnit (Map ou List)
    if(courseUnits.runtimeType is Map) {
      school = courseUnits['courseUnitsList'][0]['course']['schoolInitials'];
      course = courseUnits['courseUnitsList'][0]['course']['name'];
    }else{
      if(courseUnits[0]['courseUnitsList'].isNotEmpty) {
        school = courseUnits[0]['courseUnitsList'][0]['course']['schoolInitials'];
        course = courseUnits[0]['courseUnitsList'][0]['course']['name'];
      }else{
        course = 'Funcionario/a';
        school = '';
      }
    }

    return new Drawer(
      child: new ListView(
        physics: PageScrollPhysics(),
        children: <Widget>[
          _myDrawerHeader(school, paeUser.username, paeUser.name, course, homeBloc),
          DrawerYearsList(),
          DrawerFavoritesList(school: school, course: course),
          IppDriveList(school: school, course: course),
          _logoutButton(context)
        ],
      ),
    );
  }

  Widget _myDrawerHeader(String school, String user, String name, String course, HomeBloc bloc) {
    ImageProvider imgSchool = bloc.imageSchoolHeader(school);

    return new UserAccountsDrawerHeader(
      accountName: new Text(
        name,
        textScaleFactor: 1.1,
        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
        maxLines: 2,
      ),
      accountEmail: new Text(
        course,
        style: new TextStyle(fontSize: 11.0),
        maxLines: 2,
      ),
      currentAccountPicture: new CircleAvatar(
        backgroundImage: imgSchool,
        backgroundColor: Colors.transparent,
      ),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          border: Border.all(style: BorderStyle.solid, color: cAppBlackish),
          color: cAppYellowish),
    );
  }

  Widget _logoutButton(BuildContext context) => new ListTile(
        title: new Text(
          "Logout",
          textScaleFactor: 1.5,
          style: new TextStyle(fontWeight: FontWeight.bold),
        ),
        onTap: () => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => new LoginPageBloc()),
            (Route<dynamic> route) => false),
        trailing: new Icon(Icons.exit_to_app),
      );
}
