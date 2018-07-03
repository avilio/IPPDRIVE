import 'dart:async';

import 'package:flutter/material.dart';

import 'package:rxdart/rxdart.dart';

import '../models/user.dart';
import '../resources/apiCalls.dart';

import 'validators.dart';

class LoginBloc extends Object with Validators, Requests {
  final _username = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _response = BehaviorSubject<dynamic>();
  final _paeUser = BehaviorSubject<PaeUser>();
  final _formKey = BehaviorSubject<GlobalKey<FormState>>();
  //final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  /// Add data to stream
//  Stream<String> get username => _username.stream.transform(validateUsername);
//  Stream<String> get password => _password.stream.transform(validatePassword);
//  Stream<bool> get submitValid =>
//      Observable.combineLatest2(username, password, (e, p) => true);
  Stream<dynamic> get response => _response.stream;
  Stream<PaeUser> get paeUser => _paeUser.stream;
//  Stream<GlobalKey<FormState>> get formState => _formKey;

  /// Change data
  Function(String) get setUsername => _username.sink.add;
  Function(String) get setPassword => _password.sink.add;
  Function(PaeUser) get setPaeUser => _paeUser.sink.add;
  Function(GlobalKey<FormState>) get setKey => _formKey.sink.add;
  Function(String) get checkUser => userValidation;
  Function(String) get checkPass => passwordValidation;

  submit(String user, String password) async {
    //var state =_formKey.value.currentState;
    setUsername(user);
    setPassword(password);

    if(_formKey.value.currentState.validate()) {
      final validUser = _username.value;
      final validPassword = _password.value;

      print('user is $validUser');
      print('password is $validPassword');

      await auth(validUser, validPassword);
    }
  }

  auth(String user, String password) async {
    var bacoSessAuth;
    var bacoSessRLogin;

    bacoSessAuth = await wsAuth();
    ///
   !bacoSessAuth.containsValue('ok')
        ? _response.sink.add(bacoSessAuth['exception'])
        : bacoSessRLogin = await wsRLogin(
            user, password, bacoSessAuth['response']['BACOSESS']);

    ///
   bacoSessRLogin['service'] == 'error'
        ? _response.sink.add(bacoSessRLogin['exception'])
        : _response.sink.add(bacoSessRLogin['response']);


   print(_response.value);
   if(_response.value.runtimeType != String){
     setPaeUser(PaeUser.fromJson(_response.value));
     print(_paeUser.value.session);
     print(_paeUser.value.name);
     print(_paeUser.value.username);
   }
  }

  dispose() {
    _username.close();
    _password.close();
    _response.close();
    _paeUser.close();
    _formKey.close();
  }
}
