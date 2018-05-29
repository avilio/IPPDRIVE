import 'dart:async';

import 'package:flutter/material.dart';

import 'package:ippdrive/Pages/Themes/colorsThemes.dart';
import 'package:ippdrive/Services/requestsAPI/requestsPhases.dart';

class ListFolder extends StatefulWidget {
  final Map json;
  final String session;
  ListFolder(this.json, this.session);

  @override
  ListFolderState createState() => new ListFolderState(json, session);
}

class ListFolderState extends State<ListFolder> {
  ListFolderState(this.json, this.session);
  Map json;
  String session;

  @override
  Widget build(BuildContext context) {
    List list = json['response']['childs'];

    String title =
        json['response']['childs'][0]['pathParent'].contains('Semestre1')
            ? 'Semestre 1'
            : 'Semestre 2';

    return new Scaffold(
        appBar: new AppBar(
          title: new Text(
            'Unidades Curricuares',
            textScaleFactor: 1.5,
            style: new TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: new SizedBox(child: semestres(list, session))
        //new Divider(height: 10.0, color: cAppBlue,),

        );
  }
}

Widget semestres(list, session) {
  List sem1 = new List();
  List sem2 = new List();
  sem1 = semestreUm(list);
  sem2 = semestreDois(list);
  int len = list.length + 2;

  return new ListView.builder(
      itemCount: list.length,
      itemBuilder: (BuildContext context, int index) {
        final Map uc = list[index];
        return myExpandTile(uc, session, 3);
      });

/*

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
                //color: cAppBlue
                ),
                child: myExpandTile(sem1,session,index)
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Container(
                decoration:new BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: new BorderRadius.only(topLeft:Radius.circular(20.0),bottomRight: Radius.circular(20.0)),
                    border: Border.all(style: BorderStyle.solid, color: cAppBlackish)),
                child: myExpandTile(sem2,session, index)
              ),
            ),
          ],
        );
      });*/
}

Widget getItemsUc(Map uc) {
  return new ListTile(
    title: Column(
      children: <Widget>[
        new Text(uc['title'].toString().split('-')[0], textScaleFactor: 0.95),
      ],
    ),
  );
}

Widget myExpandTile(Map list, String session, int index) {
  Map uContent = new Map();

  return new ExpansionTile(
    //leading:
    title:
        new Text(list['title'].toString().split('-')[0], textScaleFactor: 0.95),
    children: folders(list, session),
    leading: new Icon(Icons.list),

  );
}

List<Widget> folders (list, session){
  List<Widget> reasonList = [];

  new FutureBuilder(
      future: ucFolder(list, session),
      builder: (context, response) {
        if (!response.hasData) {

          return const Center(
            child: const Text('Loading...'),
          );
        } else {
          if(response.data['directory']) {
            for (var val in response.data['title']) {
              reasonList.add(new ListTile(
                dense: true,
                title: val,
              ));
              print(reasonList);
            }
            return new ExpansionTile(
              title: new Column(
                  children: reasonList
              ),
              children: <Widget>[],
              leading: new Icon(Icons.list),

            );
          }else
            return new Text(
                response.data['title'].toString().split('-')[0],
                textScaleFactor: 0.95);
        }
      });

  return reasonList;
}

Future<Map> ucFolder(list, session) async {
  //print(list['id']);

  Map foldersUC = new Map();
  Map xpto = await courseUnitsContents(list['id'], session);
  List cont = xpto['response']['childs'];

  for (var i = 0; i < cont.length; i++) {
    foldersUC = cont[i];
  }
  //print(foldersUC);

  return foldersUC;
}

List semestreUm(list) {
  List sem1 = new List();

  for (var i = 0; i < list.length; ++i) {
    if (list[i]['pathParent'].contains('Semestre1')) sem1.add(list[i]);
  }

  return sem1;
}

List semestreDois(list) {
  List sem2 = new List();

  for (var i = 0; i < list.length; ++i) {
    if (list[i]['pathParent'].contains('Semestre2')) sem2.add(list[i]);
  }

  return sem2;
}

/*
Widget myExpandTile(List list, String session, int index){

  String title;

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
        ),
      ),
    )).toList(),
  );
}
*/
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

/*
      //print('DATA QUE VEM : ${snapshot.data}\n');
      return new ExpansionTile(
        //leading: new CircleAvatar(backgroundColor: cAppBlueAccent,backgroundImage: AssetImage("assets/images/icon.png"),),
        title: new Text(''),
        children:  content.map((val) =>
        new ListTile(
          title: new Container(
            decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: new BorderRadius.circular(50.0),
                border: new Border.all(
                    style: BorderStyle.solid, color: cAppBlackish),
                color: cAppBlueAccent
            ),
            child: new ExpansionTile(
              title: new GestureDetector(
                child: new Text(val['title'].toString().split('-')[0],textScaleFactor: 0.95,),
              ),
               children: <Widget>[
              ],
               children: folders.map((val) => new ListTile(
                            title: Container(
                              child: new Text(val['title'].toString().split('-')[0],textScaleFactor: 0.95,)
                            ),
                           )).toList(),
            ),
          ),
        )).toList(),
      );
    }
  );*/
}
/*
*  myExpandTileRecursive(list, session, index).map((value)=> new ListTile(
          title: Container(
            decoration: new BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: new BorderRadius.circular(50.0),
              border: Border.all(style: BorderStyle.solid, color: cAppBlackish),
              color: cAppBlueAccent
          ),
            child: new ExpansionTile(
              title:GestureDetector(
                child: new Text(value['title'].toString().split('-')[0],textScaleFactor: 0.95,),
              ) ,
            ),
          ),
        )).toList()*/
