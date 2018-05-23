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
      body: semestres(list, session, req)
            //new Divider(height: 10.0, color: cAppBlue,),

    );
  }
}

Widget semestres(list,session,req) {

  List sem1 = new List();
  List sem2 = new List();
  sem1 = semestreUm(list, session, req);
  sem2 = semestreDois(list, session, req);

  return new ListView.builder(
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: <Widget>[
            new Container(
              decoration:new BoxDecoration(
                shape: BoxShape.rectangle,
                //borderRadius: new BorderRadius.circular(8.0),
              border: Border.all(style: BorderStyle.solid, color: cAppBlackish)),
              child: new ExpansionTile(
                //leading: new CircleAvatar(backgroundColor: cAppBlueAccent,backgroundImage: AssetImage("assets/images/icon.png"),),
                title:new Text("Semestre 1",textScaleFactor: 1.5,),
                children: sem1.map((val) => new ListTile(
                  title: Container(
                    child: new Text(val['title'].toString().split('-')[0],textScaleFactor: 0.95,)
                  ),
                )).toList(),
              ),
            ),
            new Container(
              decoration:new BoxDecoration(
                  shape: BoxShape.rectangle,
                  //borderRadius: new BorderRadius.circular(8.0),
                  border: Border.all(style: BorderStyle.solid, color: cAppBlackish)),
              child: new ExpansionTile(
                //leading: new CircleAvatar(backgroundColor: cAppBlueAccent,backgroundImage: AssetImage("assets/images/icon.png"),),
                title:new Text("Semestre 2",textScaleFactor: 1.5,),
                children: sem2.map((val) => new ListTile(
                  title: Container(
                      child: new Text(val['title'].toString().split('-')[0],textScaleFactor: 0.95,)
                  ),
                )).toList(),
              ),
            ),
          ],
        );
      });
}

List semestreUm(list,session,req) {

  List sem1 = new List();

  for (var i = 0; i < list.length; ++i) {
    if(list[i]['pathParent'].contains('Semestre1'))
      sem1.add(list[i]);
  }

  return sem1;
/*
  return new ListView.builder(
      itemCount: sem1.length,
      itemBuilder: (BuildContext context, int index) {
        return new ExpansionTile(
              title: new GestureDetector(
                child: new Text('${sem1[index]['title'].toString().split('-')[0]}'),
                onTap: () async {
                  Map insideFolder = await req.courseUnitsContents(sem1[index]['id'],session);
                  new Expanded(child: new Text('${insideFolder['response']['childs'][index]['title']}'),);
                },
              ),
            /*  onTap: () async {
                Map insideFolder = await req.courseUnitsContents(sem1[index]['id'],session);
                //Expanded(child: new Text('${insideFolder['response']['childs'][index]['title']}'),);
              },*/
            );
           // new Divider(height: 10.0, color: cAppBlue,),
        //new Text('${sem2[index]}'),
      });*/
}
List semestreDois(list,session,req) {

  List sem2 = new List();

  for (var i = 0; i < list.length; ++i) {
    if(list[i]['pathParent'].contains('Semestre2'))
      sem2.add(list[i]);
  }

  return sem2;
/*
  return new ListView.builder(
      itemCount: sem2.length,
      itemBuilder: (BuildContext context, int index) {
        return new InkWell(
              child: new Text('${sem2[index]['title'].toString().split('-')[0]}'),
              onTap: () async {
                Map insideFolder = await req.courseUnitsContents(sem2[index]['id'],session);
                //Expanded(child: new Text('${insideFolder['response']['childs'][index]['title']}'),);
              },
              onDoubleTap: null,
              onLongPress: null,
              onTapDown: null,
            );
           // new Divider(height: 10.0, color: cAppBlue,),
            //new Text('${sem2[index]}'),
      });*/
}
/*

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
*/
/*
Widget semestreDois(list,session,req) {

  List sem2 = new List();

  for (var i = 0; i < list.length; ++i) {
    if(list[i]['pathParent'].contains('Semestre2'))
      sem2.add(list[i]);
  }

  return new ListView.builder(
      itemCount: sem2.length,
      itemBuilder: (BuildContext context, int index) {
        return new Column(
          children: <Widget>[
            new Padding(padding: new EdgeInsets.all(10.0)),
            new InkWell(
              child: new Text('${sem2[index]['title'].toString().split('-')[0]}'),
              onTap: () async {
                Map insideFolder = await req.courseUnitsContents(sem2[index]['id'],session);
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
}*/