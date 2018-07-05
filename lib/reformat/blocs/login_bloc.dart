import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../models/user.dart';
import '../resources/apiCalls.dart';
import '../common/dialogs.dart';
import './home_provider.dart';

import '../common/utilities.dart';

class LoginBloc extends Object with Utilities, Requests, ExceptionDialog {
  final _username = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _response = BehaviorSubject<dynamic>();
  final _paeUser = BehaviorSubject<PaeUser>();
  final _formKey = BehaviorSubject<GlobalKey<FormState>>();

  /// Add data to stream
//  Stream<String> get username => _username.stream.transform(validateUsername);
//  Stream<String> get password => _password.stream.transform(validatePassword);
//  Stream<bool> get submitValid =>
//      Observable.combineLatest2(username, password, (e, p) => true);
  Stream<dynamic> get response => _response.stream;
  //Stream<PaeUser> get paeUser => _paeUser.stream;
  //PaeUser get paeUser => _paeUser.value;

  /// Change data
  Function(String) get setUsername => _username.sink.add;
  Function(String) get setPassword => _password.sink.add;
  Function(PaeUser) get setPaeUser => _paeUser.sink.add;
  Function(GlobalKey<FormState>) get setKey => _formKey.sink.add;
  Function(String) get checkUser => userValidation;
  Function(String) get checkPass => passwordValidation;

  submit(String user, String password, BuildContext context) async {
    setUsername(user);
    setPassword(password);

    if (_formKey.value.currentState.validate()) {
      final validUser = _username.value;
      final validPassword = _password.value;

      auth(validUser, validPassword, context);
    }
  }

  auth(String user, String password, BuildContext context) async {
    var paeAuth;
    var paeRLogin;

    final homeBloc = HomeProvider.of(context);

    paeAuth = await wsAuth();

    ///
    !paeAuth.containsValue('ok')
        ? _response.sink.add(paeAuth['exception'])
        : paeRLogin =
            await wsRLogin(user, password, paeAuth['response']['BACOSESS']);

    ///
    paeRLogin['service'] == 'error'
        ? _response.sink.add(paeRLogin['exception'])
        : _response.sink.add(paeRLogin['response']);

    homeBloc.setResponse(_response.value);
    homeBloc.route2Home(context);
  }

  dispose() {
    _username.close();
    _password.close();
    _response.close();
    _paeUser.close();
    _formKey.close();
  }
}
