import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ippdrive/Pages/Themes/ColorsThemes.dart';
import 'package:ippdrive/RequestsAPI/RequestsHandler.dart';

String valUser = "[a-zA-Z0-9]{1,256}";
RegExp regUser = new RegExp(valUser);

/// OnPressed Button checker
Future submit(user,pass,form, context) async {

  final key = form.currentState;

  if(key.validate()){
    String requestResponse = await handler(user, pass);
    if(!requestResponse.contains('ok'))
      requestResponseValidation(requestResponse, context);
    print(requestResponse);
  }
}
/// User checker
String userValidation(String user){

  return regUser.hasMatch(user) ? null : 'User is not valid';
}
/// Password checker
String passwordValidation(String password){

  return password.length<5 ? 'Password too short' : null;
}
///Dialog Box in Case of Error
void requestResponseValidation(String message, BuildContext context) {

    showDialog(context: context,
        child: buildDialog(message, context));
}
///Dialog Box Builder
AlertDialog buildDialog(message, context){

  var dialog = AlertDialog(
    title: Text('ERROR',style: TextStyle(fontWeight: FontWeight.bold),),
    content: Text(message,
    //    style: TextStyle(color: Colors.redAccent)
    ),
    actions: <Widget>[
      FlatButton(
        onPressed: () =>Navigator.pop(context),
        child: Text('OK'),
        color: kDriveYellow600,
        shape: BeveledRectangleBorder(
            borderRadius:new BorderRadius.circular(3.0)),
      )
    ],
  );

  return dialog;
}

