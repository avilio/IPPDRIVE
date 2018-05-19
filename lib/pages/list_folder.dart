import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:ippdrive/RequestsAPI/json/folderFieldsRequest.dart';
import 'package:ippdrive/requestsAPI/model/ucFoldersModel.dart';

List<UCModel> uC;


class ListFolder extends StatelessWidget{

  //final items = new List<String>.generate(uC.length, (i)=> uC[i].courseUnitsListName);
  final items = _buildUC();
  final map =  _pathName();
//todo contruir um layout bem estrutrado
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Unidades Curriculares'),
      ),
      body: new Row(
        children: <Widget>[new ListView.builder(
              itemBuilder: (context, index) {
               // if (uC[index].path.contains("Semestre1")) {
                  return new ListTile(
                    title: new Text('${items[index]}'),
                  );
                }
            //  }
            ),
        ]
          /*  new Column(
              children: <Widget>[
                Text('Semestre2'),
                Padding(padding: EdgeInsets.all(10.0)),
                new ListView.builder(
                  itemBuilder: (context, index){
                    if (uC[index].path.contains("Semestre2")) {
                      return new ListTile(
                        title: new Text('${uC[index].courseUnitsListName}'),
                      );
                    }
                  }
                ),
              ],
            ),*/
        )
      );
  }
}
Map<String, String> _pathName(){

  var pN;

  for (int x = 0; x < uC.length; x++) {
    pN = {
      'path': uC[x].path,
      'Name': uC[x].courseUnitsListName,
    };
  }

  return pN;
}


List<String> _buildUC(){
  final ucNames = new List<String>();
  for (var value in uC) {
    ucNames.add(value.courseUnitsListName);
  }
  return ucNames;
}

void courseUnitFields(Map json){

  uC = CourseUnits
      .fromJson(json['response'])
      .courseFolders
      .map((ucFields) => UCModel.fromResponse(ucFields))
      .toList();
}