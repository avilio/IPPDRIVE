import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:ippdrive/Pages/Themes/colorsThemes.dart';
import 'package:ippdrive/RequestsAPI/json/folderFieldsRequest.dart';
import 'package:ippdrive/requestsAPI/model/ucFoldersModel.dart';

List<UCModel> uC;

class ListFolder extends StatefulWidget {
  @override
  ListFolderState createState() => new ListFolderState();
}

class ListFolderState extends State<ListFolder> {
  //final items = new List<String>.generate(uC.length, (i)=> uC[i].courseUnitsListName);
  final sem1 = _semestreUm();
  final sem2 = _semestreDois();

//todo contruir um layout bem estrutrado
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Container(
      child: new ListView.builder(
          itemCount: sem1.length,
          itemBuilder: (BuildContext context, int index) {
            return new Column(
              children: <Widget>[
                new Text('${sem1[index]}'),
                new Divider(height: 50.0,color: cAppBlue,),
                //new Text('${sem2[index]}'),
              ],
            );
          }),
    ));
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
