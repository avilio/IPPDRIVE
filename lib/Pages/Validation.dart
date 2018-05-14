import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ippdrive/Pages/Themes/ColorsThemes.dart';
import 'package:ippdrive/RequestsAPI/RequestsHandler.dart';

String valUser = "[a-zA-Z0-9]{1,256}";

RegExp regUser = new RegExp(valUser);

Future submit(user,pass,form) async {

  final key = form.currentState;

  if(key.validate()){
    String r = await handler(user, pass);
    print(r);
  }
}

String userValidation(String user){

  return regUser.hasMatch(user) ? null : 'User is not valid';
}

String passwordValidation(String password){

  return password.length<5 ? 'Password too short' : null;
}


/** Validaçoes antigas com popup do dialog em erro util apra depois da resposta ao request
 *

void validation(String user, String pass , BuildContext context) {
  //user validation
  if (!regUser.hasMatch(user)){
    showDialog(context: context,
        child: buildDialog('User is not valid', context));
  }//password validation
  else if(pass.length <5){
    showDialog(context: context,
        child: buildDialog('Password is too short!', context));
  }
  else
    //todo caso o user/password nao exista ou esteja errada(verificar consoante a resposta do server)
    handler(user, pass);
  //todo tentar mostrar a vermelho nos campos de input os erros
}


AlertDialog buildDialog(message, context){

  var dialog = AlertDialog(
    title: Text('ERROR',style: TextStyle(fontWeight: FontWeight.bold),),
    content: Text(message, style: TextStyle(color: Colors.redAccent)),
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

*/
