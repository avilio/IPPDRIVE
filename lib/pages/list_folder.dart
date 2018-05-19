import 'package:flutter/material.dart';
import 'package:ippdrive/requestsAPI/json/folderFieldsRequest.dart';
import 'package:ippdrive/requestsAPI/model/ucFoldersModel.dart';

List<UCModel> uC;

class ListFolder extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Unidades Curriculares'),
      ),
      body: Container(
        child: new ListView(
          children: <Widget>[
           // Text(uC[0].courseUnitsListName),
            //Text(uC[1].courseUnitsListName),
          ],
        ),
      )
    );
  }
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