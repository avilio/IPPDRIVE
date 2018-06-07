import 'package:flutter/material.dart';
import 'package:ippdrive/pages/homePage.dart';

import 'package:ippdrive/pages/loginPage.dart';
import 'package:ippdrive/pages/themes/colorsThemes.dart';
import 'package:ippdrive/security/verifications/display.dart';
import 'package:ippdrive/security/verifications/validation.dart';
import 'package:ippdrive/services/requestsAPI/requestsPhases.dart';

import 'package:ippdrive/user.dart';

class MyDrawer extends StatelessWidget {
  final PaeUser paeUser;
  final String school;
  final String course;

  MyDrawer(this.school, this.course, this.paeUser);

  Widget myDrawerHeader(String school, String user, [String course]) {
    //todo arranjar forma de fazer display so do nome do curso

    var imgSchool;
    switch (school) {
      case 'estg':
        imgSchool = AssetImage("assets/images/estg.png");
        break;
      case 'esecs':
        imgSchool = AssetImage("assets/images/esecs.png");
        break;
      case 'ess':
        imgSchool = AssetImage("assets/images/ess.png");
        break;
      case 'esae':
        imgSchool = AssetImage("assets/images/esae.png");
        break;
      default:
        imgSchool = AssetImage("assets/images/ipp.png");
        break;
    }

    return new UserAccountsDrawerHeader(
      accountName: new Text(
        user,
        textScaleFactor: 1.5,
        style: new TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
      ),
      accountEmail: new Text(
        stringSplitter(course, '.'),
        style: new TextStyle(fontWeight: FontWeight.bold),
      ),
      currentAccountPicture: new CircleAvatar(
        backgroundImage: imgSchool,
        backgroundColor: Colors.transparent,
      ),
      decoration: BoxDecoration(
          /*  image: new DecorationImage(
                    image: AssetImage("assets/images/ipp.png"),
                  fit: BoxFit.fill
                ),*/
          shape: BoxShape.rectangle,
          // borderRadius: new BorderRadius.only(topRight:Radius.circular(20.0),bottomLeft: Radius.circular(20.0)),
          border: Border.all(style: BorderStyle.solid, color: cAppBlackish),
          color: cAppYellowish),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isSelect = false;
    List fav = new List();

    return new Drawer(
      child: new ListView(
        children: <Widget>[
          myDrawerHeader(school, paeUser.username, course),
          new ExpansionTile(
            title: new Text(
              ' Ano Lectivo',
              style: new TextStyle(fontWeight: FontWeight.bold),
            ),
            children: <Widget>[
              new ListTile(
                title: new Text(
                  '2017-18',
                  style: new TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () async {
                  Map units = await wsCoursesUnitsContents(paeUser.session);
                  if (units['response']['childs'].isNotEmpty) {
                    isSelect = true;
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => new HomePage(units, paeUser)),
                        (Route<dynamic> route) => false);
                  } else
                    requestResponseValidation('No Data to Display', context);
                },
                selected: isSelect,
              ),
              new ListTile(
                title: new Text(
                  '2016-17',
                  style: new TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () async {
                  Map units =
                      await wsCoursesUnitsContents(paeUser.session, 201617);
                  if (units['response']['childs'].isNotEmpty) {
                    isSelect = true;
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => new HomePage(units, paeUser)),
                        (Route<dynamic> route) => false);
                  } else
                    requestResponseValidation('No Data to Display', context);
                },
                selected: isSelect,
              ),
              new ListTile(
                title: new Text(
                  '2015-16',
                  style: new TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () async {
                  Map units =
                      await wsCoursesUnitsContents(paeUser.session, 201516);
                  if (units['response']['childs'].isNotEmpty) {
                    isSelect = true;
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => new HomePage(units, paeUser)),
                        (Route<dynamic> route) => false);
                  } else
                    requestResponseValidation('No Data to Display', context);
                },
                selected: isSelect,
              ),
            ],
          ),
          new ExpansionTile(
            title: new Text(
              'Favoritos',
              style: new TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          new ListTile(
            title: new Text(
              "Logout",
              textScaleFactor: 1.5,
              style: new TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => new LoginPage()),
                (Route<dynamic> route) => false),
            trailing: new Icon(Icons.exit_to_app),
          )
        ],
      ),
    );
  }
}
