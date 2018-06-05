import 'package:async_loader/async_loader.dart';
import 'package:flutter/material.dart';
import 'package:ippdrive/Pages/Themes/colorsThemes.dart';
import 'package:ippdrive/Services/requestsAPI/requestsPhases.dart';
import 'package:ippdrive/pages/layouts/components/favorites.dart';
import 'package:ippdrive/pages/layouts/ucContent.dart';
import 'package:ippdrive/user.dart';


Widget myExpandTile(List list, PaeUser paeUser, BuildContext context, String school, String course) {
  String title =
      list[0]['pathParent'].contains('Semestre1') ? 'Semestre 1' : 'Semestre 2';

  return new ExpansionTile(
    // leading: new Icon(Icons.list),
    title: new Text(
      title,
      textScaleFactor: 1.5,
    ),
    children: list.map((val) => new ListTile(
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
                      builder: (context) => new UcContent(val, paeUser, school, course))),
                    title: new Text(val['title'].toString().split('-')[0],
                        textScaleFactor: 0.95),
               /*   children: <Widget>[
                    //folders(list, session),
                    new AsyncLoader(
                      initState: () async => await courseUnitsContents(list, session),
                      renderLoad: () => new CircularProgressIndicator(),
                      renderError: ([error]) => new Text('ERROR LOANDING DATA') ,
                      renderSuccess: ({data}) => createList(data, session),
                    )
                    // myExpandTileRecursive(list, session, index)
                  ],*/
                ),
              ),
            ))
        .toList(),
  );
}

Widget folders(list, session) {

  var asyncLoader = new AsyncLoader(
    initState: () async => await courseUnitsContents(list, session),
    renderLoad: () => new CircularProgressIndicator(),
    renderError: ([error]) => new Text('ERROR LOANDING DATA') ,
    renderSuccess: ({data}) => UcContent(data, session),
    //renderSuccess: ({data}) => createList(data, session),

  );

/*
  return new FutureBuilder(
      future: courseUnitsContents(list, session),
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
              return createList(response.data, session);
        }
      });*/

  return asyncLoader;
}



Widget semestres(list, PaeUser paeUser, BuildContext context, String school, String course) {
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
          decoration: new BoxDecoration(
            shape: BoxShape.rectangle,
            // borderRadius: new BorderRadius.only(topRight:Radius.circular(20.0),bottomLeft: Radius.circular(20.0)),
            border: Border.all(style: BorderStyle.solid, color: cAppBlackish),
            //color: cAppBlue
          ),
          child: myExpandTile(sem1, paeUser, context, school, course)),
      new Container(
          decoration: new BoxDecoration(
              shape: BoxShape.rectangle,
              // borderRadius: new BorderRadius.only(topLeft:Radius.circular(20.0),bottomRight: Radius.circular(20.0)),
              border:
                  Border.all(style: BorderStyle.solid, color: cAppBlackish)),
          child: myExpandTile(sem2, paeUser, context, school, course)),
    ],
  ));
}

List semestreUm(list) {
  List sem1 = new List();

  for (var i = 0; i < list.length; i++) {
    if (list[i]['pathParent'].contains('Semestre1')) sem1.add(list[i]);
  }

  return sem1;
}

List semestreDois(list) {
  List sem2 = new List();
  for (var i = 0; i < list.length; i++) {
    if (list[i]['pathParent'].contains('Semestre2')) sem2.add(list[i]);
  }

  return sem2;
}
/*
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


Future<List> ucFolder(list, session) async {
  Map response;

  for (var i = 0; i < list.length; i++) {
    response = await courseUnitsContents(list[i]['id'], session);
  }

  List mapCont = response['response']['childs'];

  return mapCont;
}

*/
