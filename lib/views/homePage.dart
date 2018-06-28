import 'package:flutter/material.dart';

import 'package:ippdrive/drawer.dart';

import 'package:ippdrive/views/themes/colorsThemes.dart';
import 'package:ippdrive/views/ucContentPage.dart';
import 'package:ippdrive/user.dart';

class HomePage extends StatelessWidget {
  final Map json;
  final PaeUser paeUser;
  HomePage([this.json, this.paeUser, Key key]) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List list = json['response']['childs'];
    String school = list[0]['path'].split('/')[3];
    String course = list[0]['path'].split('/')[5];
    // String year = list[0]['path'].split('/')[6].toString().split('.')[0] +' '+list[0]['path'].split('/')[6].toString().split('.')[1];
    // print(year);

    return WillPopScope(
      onWillPop: () async => false,
      child: new Scaffold(
          drawer: new MyDrawer(school, course, paeUser, json['response']),
          appBar: new AppBar(
            title: new Text(
              'Unidades Curricuares ${list[0]['path'].split('/')[6].toString().split('.')[1]}',
              //textScaleFactor: 1.5,
              style: new TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: semestres(list, context, school, course)),
    );
  }

  ///
  Widget myExpandTile(List list, BuildContext context, String school, String course) {
    String title = list[0]['pathParent'].contains('Semestre1')
        ? 'Semestre 1'
        : 'Semestre 2';

    return new ExpansionTile(
      // leading: new Icon(Icons.list),
      title: new Text(
        title,
        textScaleFactor: 1.5,
      ),
      children: list
          .map((val) => new ListTile(
                title: Container(
                  decoration: new BoxDecoration(
                      shape: BoxShape.rectangle,
                      //  borderRadius: new BorderRadius.circular(50.0),
                      border: Border.all(
                          style: BorderStyle.solid, color: cAppBlackish),
                      color: cAppBlueAccent),
                  child: new ListTile(
                    // leading: new Favorite(val['id'], session),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            new UcContent(val, paeUser, school, course))),
                    title: new Text(val['title'].toString().split('-')[0],
                        textScaleFactor: 0.95),
                  ),
                ),
              ))
          .toList(),
    );
  }

  ///
  Widget semestres(list, BuildContext context, String school, String course) {
    List sem1 = new List();
    List sem2 = new List();
    sem1 = semestreUm(list);
    sem2 = semestreDois(list);
    //String year = list[0]['path'].split('/')[6].toString().split('.')[0] +' '+list[0]['path'].split('/')[6].toString().split('.')[1];

    return new SingleChildScrollView(
        child: new Wrap(
      runSpacing: 8.0,
      children: <Widget>[
        /*  new Text(year,
      textAlign: TextAlign.center,
      textScaleFactor: 1.2,),*/
        new Padding(padding: EdgeInsets.all(1.0)),
        new Container(
            decoration: new BoxDecoration(
              shape: BoxShape.rectangle,
              // borderRadius: new BorderRadius.only(topRight:Radius.circular(20.0),bottomLeft: Radius.circular(20.0)),
              border: Border.all(style: BorderStyle.solid, color: cAppBlackish),
              //color: cAppBlue
            ),
            child: myExpandTile(sem1, context, school, course)),
        new Container(
            decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
                // borderRadius: new BorderRadius.only(topLeft:Radius.circular(20.0),bottomRight: Radius.circular(20.0)),
                border:
                    Border.all(style: BorderStyle.solid, color: cAppBlackish)),
            child: myExpandTile(sem2, context, school, course)),
      ],
    ));
  }

  ///
  List semestreUm(list) {
    List sem1 = new List();

    for (var i = 0; i < list.length; i++) {
      if (list[i]['pathParent'].contains('Semestre1')) sem1.add(list[i]);
    }

    return sem1;
  }

  ///
  List semestreDois(list) {
    List sem2 = new List();
    for (var i = 0; i < list.length; i++) {
      if (list[i]['pathParent'].contains('Semestre2')) sem2.add(list[i]);
    }

    return sem2;
  }
}
