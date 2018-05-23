import 'dart:async';

import 'package:flutter/material.dart';

import 'package:ippdrive/Pages/Themes/colorsThemes.dart';
import 'package:ippdrive/Services/requestsAPI/requestsPhases.dart';



class ListFolder extends StatefulWidget {
  final Map json;
  final String session;
  ListFolder( this.json,this.session);

  @override
  ListFolderState createState() => new ListFolderState(json,session);
}

class ListFolderState extends State<ListFolder> {

  ListFolderState( this.json,this.session);
  Map json;
  String session;

  @override
  Widget build(BuildContext context) {

    List list = json['response']['childs'];

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          'Unidades Curricuares',
          textScaleFactor: 1.5,
          style: new TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: semestres(list,session)
            //new Divider(height: 10.0, color: cAppBlue,),

    );
  }
}

Widget semestres(list,session) {

  List sem1 = new List();
  List sem2 = new List();
  sem1 = semestreUm(list);
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
                child: myExpandTile(sem1)
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Container(
                decoration:new BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: new BorderRadius.only(topLeft:Radius.circular(20.0),bottomRight: Radius.circular(20.0)),
                    border: Border.all(style: BorderStyle.solid, color: cAppBlackish)),
                child: myExpandTile(sem2)
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

}
List semestreDois(list) {

  List sem2 = new List();

  for (var i = 0; i < list.length; ++i) {
    if(list[i]['pathParent'].contains('Semestre2'))
      sem2.add(list[i]);
  }

  return sem2;
}

Widget myExpandTile(List list){

  String title;
  //print(list.runtimeType);

  list[0]['pathParent'].contains('Semestre1') ? title='Semestre 1' : title = 'Semestre 2';

  return new ExpansionTile(
    //leading: new CircleAvatar(backgroundColor: cAppBlueAccent,backgroundImage: AssetImage("assets/images/icon.png"),),
    title:new Text(title,textScaleFactor: 1.5,),
    children: list.map((val) => new ListTile(
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
  );
}

Widget myExpandTileRecursive(List list){

  String title;
  //print(list.runtimeType);

  list[0]['pathParent'].contains('Semestre1') ? title='Semestre 1' : title = 'Semestre 2';

  return new ExpansionTile(
    //leading: new CircleAvatar(backgroundColor: cAppBlueAccent,backgroundImage: AssetImage("assets/images/icon.png"),),
    title:new Text(title,textScaleFactor: 1.5,),
    children: list.map((val) => new ListTile(
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
  );


}