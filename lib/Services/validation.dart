import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ippdrive/Pages/Themes/colorsThemes.dart';
import 'package:ippdrive/Services/requestsAPI/requestsPhases.dart';
import 'package:ippdrive/pages/homePage.dart';
import 'package:ippdrive/user.dart';

RegExp _regUser = new RegExp("[a-zA-Z0-9]{1,256}");

/// OnPressed Button checker
Future submit(user, pass, form, context, key) async {
  final formKey = form.currentState;
  Map bacoSessAuth = new Map();
  Map bacoSessRLogin = new Map();
  Map courseUnitFoldersJson = new Map();

  if (formKey.validate()) {
    bacoSessAuth = await wsAuth();
    if(!bacoSessAuth.containsValue('ok'))
      requestResponseValidation(bacoSessAuth['exception'], context, key);
    else
      bacoSessRLogin = await wsRLogin(user, pass, bacoSessAuth['response']['BACOSESS']);
    if (bacoSessRLogin['service'] == 'error')
      requestResponseValidation(bacoSessRLogin['exception'], context, key);
    else {
      PaeUser paeUser = new PaeUser(user, bacoSessRLogin['response']['BACOSESS']);
      courseUnitFoldersJson = await wsCoursesUnitsContents(paeUser.session);
      if (!courseUnitFoldersJson.containsValue('ok'))
        requestResponseValidation(courseUnitFoldersJson['exception'], context, key);
      else
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ListFolder(courseUnitFoldersJson,
                paeUser)));
    }
  }
}

/// User checker
String userValidation(String user) {
  return _regUser.hasMatch(user) ? null : 'User is not valid';
}

/// Password checker
String passwordValidation(String password) {
  return password.length < 5 ? 'Password too short' : null;
}

///Dialog Box in Case of Error
void requestResponseValidation(String message, BuildContext context, key) {
  /* key.currentState
      .showSnackBar(
      new SnackBar(
        content: new Text('ERROR: '+message, textScaleFactor: 1.5,
          textAlign: TextAlign.center,),
        backgroundColor: Colors.redAccent,));*/
  showDialog(context: context, child: buildDialog(message, context));
}

///Dialog Box Builder
AlertDialog buildDialog(message, context) {
  var dialog = AlertDialog(
    title: Text(
      'ERROR',
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
    content: Text(
      message, textAlign: TextAlign.justify,
      //    style: TextStyle(color: Colors.redAccent)
    ),
    actions: <Widget>[
      FlatButton(
        onPressed: () => Navigator.pop(context),
        child: Text('OK'),
        color: cAppYellowish,
        shape: BeveledRectangleBorder(
            borderRadius: new BorderRadius.circular(3.0)),
      )
    ],
  );

  return dialog;
}
