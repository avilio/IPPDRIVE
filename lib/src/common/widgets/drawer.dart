import 'dart:async';

import 'package:flutter/material.dart';

import '../../blocs/bloc.dart';
import '../../blocs/bloc_provider.dart';
import '../../blocs/drawer_provider.dart';
import '../../models/user.dart';
import '../../screens/login.dart';
import '../../widgets/drawer/drawer_favorites_list.dart';
import '../../widgets/drawer/drawer_ippDrive_list.dart';
import '../../widgets/drawer/drawer_years_list.dart';
import '../themes/colorsThemes.dart';

class MyDrawer extends StatefulWidget {
  final PaeUser paeUser;

  final dynamic courseUnits;

  MyDrawer(
      {this.paeUser, this.courseUnits, Key key})
      : super(key: key);

  @override
  MyDrawerState createState() {
    return new MyDrawerState();
  }
}

class MyDrawerState extends State<MyDrawer> {

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      final bloc = BlocProvider.of(context);
      bloc.onConnectionChange();
    });

  }

  @override
  Widget build(BuildContext context) {
    final homeBloc = BlocProvider.of(context);
    final drawerBloc = DrawerProvider.of(context);

    return new Drawer(
      child: new ListView(
        physics: PageScrollPhysics(),
        children: <Widget>[
          _myDrawerHeader(drawerBloc.school, widget.paeUser.username, widget.paeUser.name, drawerBloc.course, homeBloc),
          DrawerYearsList(),
          DrawerFavoritesList(school: drawerBloc.school, course: drawerBloc.course),
          IppDriveList(school: drawerBloc.school, course: drawerBloc.course),
          _logoutButton(context)
        ],
      ),
    );
  }

  Widget _myDrawerHeader(String school, String user, String name, String course, Bloc bloc) {
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
