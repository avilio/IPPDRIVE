import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ippdrive/security/verifications/display.dart';
import 'package:ippdrive/services/requestsAPI/requestsPhases.dart';
import 'package:ippdrive/pages/homePage.dart';
import 'package:ippdrive/user.dart';

/**
 * Regular expression to make sure the username contains only letters and/or numbers
 */
RegExp _regUser = new RegExp("[a-zA-Z0-9]{1,256}");

/**
 * On pressed a button given [user],[pass],[form],[context] and [key] it will validate
 * the fields from the form, await from all the 'login'stages requests to the api and
 * finally if everything goes well navigates to the new route, else will display any error
 * occurred.
 */
Future submit(user, pass, form, context, key) async {
  final formKey = form.currentState;
  Map bacoSessAuth = new Map();
  Map bacoSessRLogin = new Map();
  Map courseUnitFoldersJson = new Map();

  if (formKey.validate()) {
    bacoSessAuth = await wsAuth();
    if (!bacoSessAuth.containsValue('ok'))
      requestResponseValidation(bacoSessAuth['exception'], context, key);
    else
      bacoSessRLogin =
          await wsRLogin(user, pass, bacoSessAuth['response']['BACOSESS']);
    if (bacoSessRLogin['service'] == 'error')
      requestResponseValidation(bacoSessRLogin['exception'], context, key);
    else {
      PaeUser paeUser =
          new PaeUser(user, bacoSessRLogin['response']['BACOSESS']);
      courseUnitFoldersJson = await wsCoursesUnitsContents(paeUser.session);
      if (!courseUnitFoldersJson.containsValue('ok'))
        requestResponseValidation(
            courseUnitFoldersJson['exception'], context, key);
      else
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => HomePage(courseUnitFoldersJson, paeUser)));
    }
    /* forma de fazer sem retornar Future

    wsAuth().then((bacoSessAuth){
      if(!bacoSessAuth.containsValue('ok'))
        requestResponseValidation(bacoSessAuth['exception'], context, key);
      else
        wsRLogin(user, pass, bacoSessAuth['response']['BACOSESS']).then((bacoSessRLogin){;
        if (bacoSessRLogin['service'] == 'error')
          requestResponseValidation(bacoSessRLogin['exception'], context, key);
        else {
          PaeUser paeUser = new PaeUser(user, bacoSessRLogin['response']['BACOSESS']);
          wsCoursesUnitsContents(paeUser.session).then((courseUnitFoldersJson) {
            if (!courseUnitFoldersJson.containsValue('ok'))
              requestResponseValidation(
                  courseUnitFoldersJson['exception'], context, key);
            else
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      ListFolder(courseUnitFoldersJson,
                          paeUser)));
          });
        }
        });
    });*/
  }
}

/**
 * User validation
 */
String userValidation(String user) {
  return _regUser.hasMatch(user) ? null : 'User is not valid';
}

/**
 * Password validation
 */
String passwordValidation(String password) {
  return password.length < 5 ? 'Password too short' : null;
}

/**
 * Error display
 */
void requestResponseValidation(String message, BuildContext context, key) {
  /* key.currentState
      .showSnackBar(
      new SnackBar(
        content: new Text('ERROR: '+message, textScaleFactor: 1.5,
          textAlign: TextAlign.center,),
        backgroundColor: Colors.redAccent,));*/
  showDialog(context: context, child: buildDialog(message, context));
}