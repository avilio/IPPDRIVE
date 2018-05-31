import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ippdrive/Pages/Themes/colorsThemes.dart';
import 'package:ippdrive/Services/requestsAPI/requestsPhases.dart';

myDrawer(BuildContext context, List list, String user) {

  String school = list[0]['path'].split('/')[3];
  String course = list[0]['path'].split('/')[5];
  //print(school);

  return new Drawer(
    child: new ListView(
      children: <Widget>[
        myDrawerHeader(school, user, course),
        new ListTile(
          title: new Text("Logout", textScaleFactor: 1.5,
            style: new TextStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () => Navigator.of(context).pushReplacementNamed("/login"),
          trailing: new Icon(Icons.exit_to_app),
        )
      ],
    ),
  );
}

myDrawerHeader(String school, String user, [String course]) {

  //todo arranjar forma de fazer display so do nome do curso

  var imgSchool;
  switch(school){
    case 'estg' : imgSchool = AssetImage("assets/images/estg.png");break;
    case 'esecs' : imgSchool = AssetImage("assets/images/esecs.png");break;
    case 'ess' : imgSchool = AssetImage("assets/images/ess.png");break;
    case 'esae' : imgSchool = AssetImage("assets/images/esae.png");break;
  }

  return new UserAccountsDrawerHeader(
    accountName: new Text(user,textScaleFactor: 1.5,
      style: new TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
    ),
    accountEmail: new Text(course,
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
        color: cAppYellowish
    ),
  );
}

Widget myExpandTile(List list, String session) {

  String title = list[0]['pathParent'].contains('Semestre1')
      ? 'Semestre 1'
      : 'Semestre 2';

  return new ExpansionTile(
   // leading: new Icon(Icons.list),
    title:new Text(title,textScaleFactor: 1.5,),
    children: list.map((val) => new ListTile(
      title: Container(
        decoration:new BoxDecoration(
            shape: BoxShape.rectangle,
            //  borderRadius: new BorderRadius.circular(50.0),
            border: Border.all(style: BorderStyle.solid, color: cAppBlackish),
            color: cAppBlueAccent
        ),
        child: new ExpansionTile(
          title:GestureDetector(
            child: new Text(val['title'].toString().split('-')[0],textScaleFactor: 0.95),
          ),
          children: <Widget>[
            folders(list, session),

            // myExpandTileRecursive(list, session, index)
          ],
        ),
      ),
    )).toList(),
  );
}


Future<List> ucFolder(list, session) async {
  Map response;

  for (var i = 0; i < list.length; i++) {
    response = await courseUnitsContents(list[i]['id'], session);
  }

  List mapCont = response['response']['childs'];

  return mapCont;
}


Widget folders(list, session) {

  var answerWidget = new FutureBuilder(
      future: ucFolder(list, session),
      builder: (context, response) {
        switch (response.connectionState) {
          case ConnectionState.none:
            return new Text('Press button to start');
          case ConnectionState.waiting:
            return new Text('Awaiting result...');
          default:
            if (response.hasError)
              return new Text('Error: ${response.error}');
            else
              // return createList(context, response);
              return createList(context, response);
        }
      });

  return answerWidget;
}

Widget createList(BuildContext context, AsyncSnapshot response) {
  List values = response.data;

  return new ListView.builder(
      itemCount: values.length,
      shrinkWrap: true,
      itemBuilder: (context, i){
        if(values[i]['directory']) {
          return new ExpansionTile(
              title: new ListTile(
                dense: true,
                title: new Text(values[i]['title']),
              )
          );
        }else
          return new ListTile(
            dense: true,
            title: new Text(values[i]['title']),
          );
      }
  );
}

Widget semestres(list, session) {

  List sem1 = new List();
  List sem2 = new List();
  sem1 = semestreUm(list);
  sem2 = semestreDois(list);

  return new SingleChildScrollView(
      child: new Wrap(
        runSpacing: 8.0,
        children: <Widget>[
          new Padding(padding: EdgeInsets.all(1.0)),
          new Container(
              decoration:new BoxDecoration(
                shape: BoxShape.rectangle,
                // borderRadius: new BorderRadius.only(topRight:Radius.circular(20.0),bottomLeft: Radius.circular(20.0)),
                border: Border.all(style: BorderStyle.solid, color: cAppBlackish),
                //color: cAppBlue
              ),
              child: myExpandTile(sem1,session)
          ),
          new Container(
              decoration:new BoxDecoration(
                  shape: BoxShape.rectangle,
                  // borderRadius: new BorderRadius.only(topLeft:Radius.circular(20.0),bottomRight: Radius.circular(20.0)),
                  border: Border.all(style: BorderStyle.solid, color: cAppBlackish)),
              child: myExpandTile(sem2,session)
          ),
        ],
      )
  );
}

List semestreUm(list) {
  List sem1 = new List();

  for (var i = 0; i < list.length; i++) {
    if (list[i]['pathParent'].contains('Semestre1'))
      sem1.add(list[i]);
  }

  return sem1;
}

List semestreDois(list) {

  List sem2 = new List();
  for (var i = 0; i < list.length; i++) {
    if (list[i]['pathParent'].contains('Semestre2'))
      sem2.add(list[i]);

  }

  return sem2;
}

List myExpandTileRecursive(List list, String session, int index) {
//todo arranjar de forma a que o tittle seja a lista content

  List content = new List();

  new FutureBuilder(
      future: ucFolder(list, session),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return new Text('Loading...');
        for (var o in snapshot.data) {
          content.add(o);
        }
      });

  return content;
}

