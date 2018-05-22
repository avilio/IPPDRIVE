import 'package:flutter/material.dart';

import 'package:ippdrive/Pages/Themes/colorsThemes.dart';
import 'package:ippdrive/Services/requestsAPI/requestsPhases.dart';


class ListFolder extends StatefulWidget {
  String session;
  Map json;
  ListFolder(this.session, this.json);

  @override
  ListFolderState createState() => new ListFolderState(session, json);
}


class ListFolderState extends State<ListFolder> {

  ListFolderState( this.session, this.json);
  String session;
  Map json;

  requestsApi req = new requestsApi();

//todo contruir um layout bem estrutrado
  @override
  Widget build(BuildContext context) {

   // print(json['response']['childs']);
    List list = json['response']['childs'];

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          'Unidades Curriculares',
          textScaleFactor: 1.5,
          style: new TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: new Center(
        child: semestreUm(list, session, req),
      ),
    );
  }
}

Widget semestreUm(list,session,req) {

  List sem1 = new List();

  for (var i = 0; i < list.length; ++i) {
    if(list[i]['pathParent'].contains('Semestre1'))
      sem1.add(list[i]);
  }

  return new ListView.builder(
      itemCount: sem1.length,
      itemBuilder: (BuildContext context, int index) {
        return new Column(
          children: <Widget>[
            new Padding(padding: new EdgeInsets.all(10.0)),
            new InkWell(
              child: new Text('${sem1[index]['title'].toString().split('-')[0]}'),
              onTap: () async {
                Map insideFolder = await req.courseUnitsContents(sem1[index]['id'],session);
                //Expanded(child: new Text('${insideFolder['response']['childs'][index]['title']}'),);
              },
              onDoubleTap: null,
              onLongPress: null,
              onTapDown: null,
            ),
            new Divider(height: 10.0, color: cAppBlue,),
            //new Text('${sem2[index]}'),
          ],
        );
      });
}

Widget semestreDois(list,session,req) {

  List sem1 = new List();

  for (var i = 0; i < list.length; ++i) {
    if(list[i]['pathParent'].contains('Semestre2'))
      sem1.add(list[i]);
  }

  return new ListView.builder(
      itemCount: sem1.length,
      itemBuilder: (BuildContext context, int index) {
        return new Column(
          children: <Widget>[
            new Padding(padding: new EdgeInsets.all(10.0)),
            new InkWell(
              child: new Text('${sem1[index]['title'].toString().split('-')[0]}'),
              onTap: () async {
                Map insideFolder = await req.courseUnitsContents(sem1[index]['id'],session);
                //Expanded(child: new Text('${insideFolder['response']['childs'][index]['title']}'),);
              },
              onDoubleTap: null,
              onLongPress: null,
              onTapDown: null,
            ),
            new Divider(height: 10.0, color: cAppBlue,),
            //new Text('${sem2[index]}'),
          ],
        );
      });
}