import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ippdrive/Pages/Themes/colorsThemes.dart';
import 'package:ippdrive/RequestsAPI/requestsPhases.dart';
import 'package:ippdrive/pages/list_folder.dart';

String valUser = "[a-zA-Z0-9]{1,256}";
RegExp regUser = new RegExp(valUser);

/// OnPressed Button checker
Future submit(user,pass,form, context) async {

  final formKey = form.currentState;

  if(formKey.validate()){
    String requestResponse = await requestPhases(user, pass);
    if(!requestResponse.contains('ok'))
      requestResponseValidation(requestResponse, context);
   // print(requestResponse);
    else
      //Navigator.of(context).pushNamed("/listView");
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ListFolder()));
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
        color: cAppMainColor,
        shape: BeveledRectangleBorder(
            borderRadius:new BorderRadius.circular(3.0)),
      )
    ],
  );

  return dialog;
}



