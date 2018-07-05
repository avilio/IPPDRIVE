import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ippdrive/security/verifications/display.dart';
import 'package:ippdrive/services/apiRequests.dart';
import 'package:ippdrive/views/homePage.dart';


//import 'package:ippdrive/user.dart';

import '../../reformat/models/user.dart';
import 'package:ippdrive/views/ucContentPage.dart';

/// Regular expression to make sure the username contains only letters and/or numbers
RegExp _regUser = new RegExp("[a-zA-Z0-9]{1,256}");

/// On pressed a button given [user],[pass],[form],[context] and [key] it will validate
/// the fields from the form, await from all the 'login'stages requests to the api and
/// finally if everything goes well navigates to the new route, else will display any error
/// occurred.
class Validations {
  Requests request = Requests();
  PaeUser paeUser;

  Future submit(user, pass, form, context, key) async {
    final formKey = form.currentState;
    Map bacoSessAuth;
    Map bacoSessRLogin = new Map();
    Map courseUnitFoldersJson = new Map();

    if (formKey.validate()) {
      bacoSessAuth = await request.wsAuth();
      if (!bacoSessAuth.containsValue('ok'))
        requestResponseValidation(bacoSessAuth['exception'], context, key);
      else
        bacoSessRLogin = await request.wsRLogin(
            user, pass, bacoSessAuth['response']['BACOSESS']);
      if (bacoSessRLogin['service'] == 'error')
        requestResponseValidation(bacoSessRLogin['exception'], context, key);
      else {
         paeUser = new PaeUser(
            user,
            bacoSessRLogin['response']['BACOSESS'],
            bacoSessRLogin['response']['name']);
        courseUnitFoldersJson =
            await request.wsYearsCoursesUnitsFolders(paeUser.session);
        if (!courseUnitFoldersJson.containsValue('ok'))
          requestResponseValidation(
              courseUnitFoldersJson['exception'], context, key);
        else{
          ///PROVISORIO
          if(courseUnitFoldersJson['response']['childs'].isEmpty) {
            var courseUnitFoldersJson = await request.wsReadMyDefaultFoldersFolders(paeUser.session);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => HomePage(courseUnitFoldersJson, paeUser)));
          }else
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => HomePage(courseUnitFoldersJson, paeUser)));
        }
      }
    }
  }

  /// User validation
  String userValidation(String user) =>
      _regUser.hasMatch(user) ? null : 'User is not valid';

  /// Password validation
  String passwordValidation(String password) =>
      password.length < 5 ? 'Password too short' : null;

  /// Error display
  void requestResponseValidation(String message, BuildContext context, [key]) =>
      showDialog(context: context, child: buildDialog(message, context));
}

/* void requestResponseValidation(String message, BuildContext context, [key]) {
key.currentState
      .showSnackBar(
      new SnackBar(
        content: new Text('ERROR: '+message, textScaleFactor: 1.5,
          textAlign: TextAlign.center,),
        backgroundColor: Colors.redAccent,));}*/
