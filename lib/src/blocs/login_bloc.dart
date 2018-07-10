import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../models/user.dart';
import '../resources/apiCalls.dart';
import '../common/dialogs.dart';
import './home_provider.dart';
import '../common/utilities.dart';

class LoginBloc extends Object with Utilities, Requests, ExceptionDialog, Connectivity{
  final _username = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _response = BehaviorSubject<dynamic>();
  final _paeUser = BehaviorSubject<PaeUser>();
  final _formKey = BehaviorSubject<GlobalKey<FormState>>();
  final _connectivityStatus = BehaviorSubject<String>();
  final _connectivity = Connectivity();

  /// Output da stream
  Stream<dynamic> get response => _response.stream;
  String get connectionStatus => _connectivityStatus.value;

  /// Recebe valores para a stream
  Function(String) get setUsername => _username.sink.add;
  Function(String) get setPassword => _password.sink.add;
  Function(PaeUser) get setPaeUser => _paeUser.sink.add;
  Function(GlobalKey<FormState>) get setKey => _formKey.sink.add;
  Function(String) get checkUser => userValidation;
  Function(String) get checkPass => passwordValidation;
  Function(String) get setConnectionStatus =>_connectivityStatus.sink.add;

  Future initConnection() async => setConnectionStatus((await _connectivity.checkConnectivity()).toString());
  void onConnectionChange() => _connectivity.onConnectivityChanged.listen((ConnectivityResult result)=> setConnectionStatus(result.toString()));


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
    homeBloc.route2Home(context,password);
  }

  dispose() {
    _username.close();
    _password.close();
    _response.close();
    _paeUser.close();
    _formKey.close();
    _connectivityStatus.close();
  }
}
