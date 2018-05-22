import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ippdrive/Pages/Themes/colorsThemes.dart';
import 'package:ippdrive/Services/requestsAPI/json/folderFieldsRequest.dart';
import 'package:ippdrive/Services/requestsAPI/model/ucFoldersModel.dart';
import 'package:ippdrive/Services/requestsAPI/requestsPhases.dart';

List<UCModel> uC;

class ListFolder extends StatefulWidget {
  String session;
  Map json;
  ListFolder(this.session, this.json);

  @override
  ListFolderState createState() => new ListFolderState(session, json);
}

class ListFolderState extends State<ListFolder> {
  //final items = new List<String>.generate(uC.length, (i)=> uC[i].courseUnitsListName);
  //final sem1 = _semestreUm();
 // final sem2 = _semestreDois();
  String session;
  Map json;

  ListFolderState( this.session, this.json);

  requestsApi req = new requestsApi();

//todo contruir um layout bem estrutrado
  @override
  Widget build(BuildContext context) {

    print(json['response']['childs']);
    List list = json['response']['childs'];


    final unitCourseList = new ListView.builder(
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          return new Column(
            children: <Widget>[
              new Padding(padding: new EdgeInsets.all(10.0)),
              new InkWell(
               child: new Text('${json['response']['childs'][index]['title']}'),
                onTap: () async {
                 Map insideFolder = await req.courseUnitsContents(json['response']['childs'][index]['id'],session);
                 Expanded(child: new Text('${insideFolder['response']['childs'][index]['title']}'),);

                },
              ),
              new Divider(height: 10.0, color: cAppBlue,),
              //new Text('${sem2[index]}'),
            ],
          );
        });

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          'Unidades Curriculares',
          textScaleFactor: 1.5,
          style: new TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: new Center(
        child: unitCourseList,
      ),
    );
  }
}

List<String> _semestreUm() {
  final ucNames = new List<String>();
  for (var value in uC) {
    if (value.path.contains("Semestre1"))
      ucNames.add(value.courseUnitsListName);
  }
  return ucNames;
}

List<String> _semestreDois() {
  final ucNames = new List<String>();
  for (var value in uC) {
    if (value.path.contains("Semestre2"))
      ucNames.add(value.courseUnitsListName);
  }
  return ucNames;
}

void courseUnitFields(Map json) {

  uC = CourseUnits
      .fromJson(json['response'])
      .courseFolders
      .map((ucFields) => UCModel.fromResponse(ucFields))
      .toList();
}
//todo nao foi a melhor maneira de resolver o problema
void courseUnitContent(Map json) {

  uC = CourseUnits
      .fromJson(json['response'])
      .courseFolders
      .map((ucFields) => UCModel.fromRecursiveResponse(ucFields))
      .toList();
}