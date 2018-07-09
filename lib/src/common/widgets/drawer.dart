import 'package:flutter/material.dart';

import '../themes/colorsThemes.dart';
import '../../models/user.dart';
import '../../screens/login.dart';
import '../../blocs/home_provider.dart';
import '../../blocs/home_bloc.dart';
import '../../blocs/drawer_bloc.dart';
import '../../blocs/drawer_provider.dart';
import '../../widgets/drawer/drawer_years_list.dart';
import '../../widgets/drawer/drawer_favorites_list.dart';
import '../../widgets/drawer/drawer_ippDrive_list.dart';

class MyDrawer extends StatelessWidget {
  final PaeUser paeUser;

  final dynamic courseUnits;

  MyDrawer(
      {this.paeUser, this.courseUnits, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeBloc = HomeProvider.of(context);
    final drawerBloc = DrawerProvider.of(context);

    return new Drawer(
      child: new ListView(
        physics: PageScrollPhysics(),
        children: <Widget>[
          _myDrawerHeader(drawerBloc.school, paeUser.username, paeUser.name, drawerBloc.course, homeBloc),
          DrawerYearsList(),
          DrawerFavoritesList(school: drawerBloc.school, course: drawerBloc.course),
          IppDriveList(school: drawerBloc.school, course: drawerBloc.course),
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
            MaterialPageRoute(builder: (context) => new LoginPage()),
            (Route<dynamic> route) => false),
        trailing: new Icon(Icons.exit_to_app),
      );
}
