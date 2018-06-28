import 'package:async_loader/async_loader.dart';
import 'package:flutter/material.dart';

import 'package:ippdrive/security/verifications/display.dart';
import 'package:ippdrive/security/verifications/validation.dart';
import 'package:ippdrive/services/apiRequests.dart';

import 'package:ippdrive/user.dart';
import 'package:ippdrive/views/homePage.dart';
import 'package:ippdrive/views/loginPage.dart';
import 'package:ippdrive/views/themes/colorsThemes.dart';
import 'package:ippdrive/views/ucContentPage.dart';

class MyDrawer extends StatelessWidget {
  final PaeUser paeUser;
  final String school;
  final String course;
  final Map json;

  MyDrawer(this.school, this.course, this.paeUser, [this.json]);

  @override
  Widget build(BuildContext context) {
    Requests request = Requests();
    Validations validations = Validations();

    return new Drawer(
      child: new ListView(
        children: <Widget>[
          myDrawerHeader(school, paeUser.name, course),
          new ExpansionTile(
            leading: new Icon(Icons.school),
            title: new Text(
              ' Ano Lectivo',
              style: new TextStyle(fontWeight: FontWeight.bold),
            ),
            children: <Widget>[yearList(request, validations)],
          ),
          new ExpansionTile(
            leading: new Icon(Icons.star),
            title: new Text(
              'Favoritos',
              style: new TextStyle(fontWeight: FontWeight.bold),
            ),
            children: <Widget>[favorites(request, validations, json)],
          ),
          new ExpansionTile(
            leading: Image(image: AssetImage("assets/images/ipp.png"),width: 40.0,), //ImageIcon(AssetImage("assets/images/ipp.png"))
            title: new Text(
              'IppDrive',
              style: new TextStyle(fontWeight: FontWeight.bold),
            ),
            children: <Widget>[ippDriveRoot(request)],
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

  Widget myDrawerHeader(String school, String user, [String course]) {
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
        textScaleFactor: 1.1,
        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
        maxLines: 2,
      ),
      accountEmail: new Text(
        stringSplitter(course, '.'),
        style: new TextStyle(fontSize: 11.0),
        maxLines: 2,
      ),
      currentAccountPicture: new CircleAvatar(
        backgroundImage: imgSchool,
        backgroundColor: Colors.transparent,
      ),
      decoration: BoxDecoration(
//          image: new DecorationImage(
//                    image: AssetImage("assets/images/ipp.png"),
//                  fit: BoxFit.scaleDown
//                ),
          shape: BoxShape.rectangle,
          //borderRadius: new BorderRadius.only(topRight:Radius.circular(20.0),bottomLeft: Radius.circular(20.0)),
          border: Border.all(style: BorderStyle.solid, color: cAppBlackish),
          color: cAppYellowish),
    );
  }

  Widget yearList(Requests request, validations) => new AsyncLoader(
        initState: () async => await request.getYears(paeUser.session),
        renderLoad: () => new CircularProgressIndicator(),
        renderError: ([error]) => new Text('ERROR LOANDING DATA'),
        renderSuccess: ({data}) {
          List list = List();
          list.add(data['response']['importYear']);
          list.add(data['response']['previousImportYear']);
          list.add(data['response']['previous2ImportYear']);

          return new ListView.builder(
            shrinkWrap: true,
            itemCount: list.length,
            itemBuilder: (context, index) {
              return new ListTile(
                dense: true,
                title: new Text(
                  list[index].toString().substring(0, 4) +
                      '-20' +
                      list[index].toString().substring(4),
                  style: new TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () async {
                  Map units = await request.wsYearsCoursesUnitsFolders(
                      paeUser.session, list[index]);
                  if (units['response']['childs'].isNotEmpty) {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => new HomePage(units, paeUser)),
                        (Route<dynamic> route) => false);
                  } else
                    validations.requestResponseValidation(
                        'No Data to Display', context);
                },
              );
            },
          );
        },
      );

  Widget favorites(Requests request, Validations validations, Map json) =>
      new AsyncLoader(
        initState: () async => await request.readFavorites(paeUser.session),
        renderLoad: () => new CircularProgressIndicator(),
        renderError: ([error]) => new Text('ERROR LOANDING DATA'),
        renderSuccess: ({data}) {
          List list = data['response']['favorites'];

          return new ListView.builder(
            shrinkWrap: true,
            itemCount: list.length ?? 0,
            itemBuilder: (context, index) {
              return new ListTile(
                dense: true,
                //leading: Icon(Icons.folder_special),
                title: new Text(
                  list[index]['title'],
                  style: new TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: new Text(
                  subtitleSplitter(list[index]['path'].split('/')[8]),
                  softWrap: true,
                ),
                onTap: () {
                  if (list.isNotEmpty) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => new UcContent(
                            list[index], paeUser, school, course)));
                  } else
                    validations.requestResponseValidation(
                        'No Data to Display', context);
                },
              );
            },
          );
        },
      );

  Widget ippDriveRoot(Requests request){
   return new AsyncLoader(
      initState: () async => await request.courseUnitsFoldersContents({"id" : 5}, paeUser.session),
      renderLoad: () => new CircularProgressIndicator(),
      renderError: ([error]) => new Text('ERROR LOANDING DATA'),
      renderSuccess: ({data}) {
        List list = data['response']['childs'];

     //   list.forEach((val)=>debugPrint(val['title']));

        return new ListView.builder(
          shrinkWrap: true,
          itemCount: list.length ?? 0,
          itemBuilder: (context, index) {
            return new ListTile(
              dense: true,
              leading: imageSchoolLeading(list[index]['title']),
              title: new Text(
                list[index]['title'],
                style: new TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                if (list.isNotEmpty) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => new UcContent(
                          list[index], paeUser, school, course)));
                } else
                  validations.requestResponseValidation(
                      'No Data to Display', context);
              },
            );
          },
        );
      },
    );

  }



  Widget imageSchoolLeading(String title){
    switch (title.toLowerCase()) {
      case 'estg':
        return Image(image: AssetImage("assets/images/estg.png"),width: 40.0);
        break;
      case 'esecs':
        return Image(image:  AssetImage("assets/images/esecs.png"),width: 40.0);
        break;
      case 'ess':
        return Image(image:  AssetImage("assets/images/ess.png"),width: 40.0);
        break;
      case 'esae':
        return Image(image:  AssetImage("assets/images/esae.png"),width: 40.0);
        break;
    }
    return Icon(Icons.layers);
  }
  String subtitleSplitter(String sub) {
    String response = '';

    List list = sub.split('.');
    list.forEach((string) {
      if (double.parse(string, (e) => null) == null) response += string + ' ';
    });

    return response;
  }
}
