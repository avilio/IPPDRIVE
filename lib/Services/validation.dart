import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ippdrive/Pages/Themes/colorsThemes.dart';
import 'package:ippdrive/Services/requestsAPI/requestsPhases.dart';
import 'package:ippdrive/pages/homePage.dart';

String valUser = "[a-zA-Z0-9]{1,256}";
RegExp regUser = new RegExp(valUser);

/// OnPressed Button checker
Future submit(user,pass,form, context, key) async {

  final formKey = form.currentState;
  requestsApi req = new requestsApi();

  if(formKey.validate()){
    Map requestResponse = await req.requestPhases(user, pass);
    if(!requestResponse.containsValue('ok'))
      requestResponseValidation(requestResponse['exception'], context, key);
   // print(requestResponse);
    else
      //Navigator.of(context).pushNamed("/listView");
      //todo acescentar campos nas classes para passar o login talvez nao seja a melhor solucao
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ListFolder(req.bacoSessRLogin['response']['BACOSESS'], requestResponse)));
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
void requestResponseValidation(String message, BuildContext context, key) {
 /* key.currentState
      .showSnackBar(
      new SnackBar(
        content: new Text('ERROR: '+message, textScaleFactor: 1.5,
          textAlign: TextAlign.center,),
        backgroundColor: Colors.redAccent,));*/
    showDialog(context: context,
        child: buildDialog(message, context));
}
///Dialog Box Builder
AlertDialog buildDialog(message, context){

  var dialog = AlertDialog(
    title: Text('ERROR',style: TextStyle(fontWeight: FontWeight.bold),),
    content: Text(message,textAlign: TextAlign.justify,
    //    style: TextStyle(color: Colors.redAccent)
    ),
    actions: <Widget>[
      FlatButton(
        onPressed: () =>Navigator.pop(context),
        child: Text('OK'),
        color: cAppYellowish,
        shape: BeveledRectangleBorder(
            borderRadius:new BorderRadius.circular(3.0)),
      )
    ],
  );

  return dialog;
}



