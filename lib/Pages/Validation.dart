import 'package:flutter/material.dart';
import 'package:ippdrive/Pages/Themes/ColorsThemes.dart';
import 'package:ippdrive/RequestsAPI/RequestsHandler.dart';

String valUser = "[a-zA-Z0-9]{1,256}";

RegExp regUser = new RegExp(valUser);

void validation(String user, String pass , BuildContext context) {

  if (!regUser.hasMatch(user)){
    showDialog(context: context,
        child: buildDialog('User is not valid', context));
  }
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

