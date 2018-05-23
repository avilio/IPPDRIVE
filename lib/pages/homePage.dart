import 'dart:async';

import 'package:flutter/material.dart';

import 'package:ippdrive/Pages/Themes/colorsThemes.dart';
import 'package:ippdrive/Services/requestsAPI/requestsPhases.dart';
import 'package:ippdrive/user.dart';


class ListFolder extends StatefulWidget {
 // String session;
  final Map json;
  ListFolder( this.json);

  @override
  ListFolderState createState() => new ListFolderState(json);
}


class ListFolderState extends State<ListFolder> with User {

  ListFolderState( this.json);
  //String session;
  Map json;

//todo contruir um layout bem estrutrado
  @override
  Widget build(BuildContext context) {

   // print(json['response']['childs']);
    List list = json['response']['childs'];
    print(getpassword());
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          'Unidades Curricuares',
          textScaleFactor: 1.5,
          style: new TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: semestres(list,getsession())
            //new Divider(height: 10.0, color: cAppBlue,),

    );
  }
}

Widget semestres(list,session) {

  List sem1 = new List();
  List sem2 = new List();
  sem1 = semestreUm(list );
  sem2 = semestreDois(list);


  return new ListView.builder(
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Container(
                decoration:new BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: new BorderRadius.only(topRight:Radius.circular(20.0),bottomLeft: Radius.circular(20.0)),
                border: Border.all(style: BorderStyle.solid, color: cAppBlackish),
                color: cAppBlue),
                child: new ExpansionTile(
                  //leading: new CircleAvatar(backgroundColor: cAppBlueAccent,backgroundImage: AssetImage("assets/images/icon.png"),),
                  title:new Text("Semestre 1",textScaleFactor: 1.5,),
                  children: sem1.map((val) => new ListTile(
                    title: Container(
                      decoration:new BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: new BorderRadius.circular(50.0),
                          border: Border.all(style: BorderStyle.solid, color: cAppBlackish),
                          color: cAppBlueAccent
                      ),
                       child: new ExpansionTile(
                        title:GestureDetector(
                            child: new Text(val['title'].toString().split('-')[0],textScaleFactor: 0.95,),
                        ),
                         children: <Widget>[

                         ],
                         /* children: folders.map((val) => new ListTile(
                          title: Container(
                            child: new Text(val['title'].toString().split('-')[0],textScaleFactor: 0.95,)
                          ),
                         )).toList(),*/
                    ),
                    ),
                  )).toList(),

                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Container(
                decoration:new BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: new BorderRadius.only(topLeft:Radius.circular(20.0),bottomRight: Radius.circular(20.0)),
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
            ),
          ],
        );
      });
}

Future<List> ucFolder(list,session) async {

  List foldersUC = new List();
  for (var i = 0; i < list.length; ++i) {
    Map xpto = await courseUnitsContents(list[i]['id'], session);
    foldersUC = xpto['response']['childs'];
  }

  return foldersUC.toList();
}

List semestreUm(list) {

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
List semestreDois(list) {

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