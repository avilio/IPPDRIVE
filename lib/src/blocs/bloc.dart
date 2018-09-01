import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/dialogs.dart';
import '../common/error401.dart';
import '../common/utilities.dart';
import '../models/user.dart';
import '../resources/apiCalls.dart';
import '../saveLocally.dart';
import '../screens/home.dart';

class Bloc extends Object
    with Utilities, Requests, ExceptionDialog, Connectivity, SaveLocally,Error401 {
  final _response = BehaviorSubject<dynamic>();
  final _paeUser = BehaviorSubject<PaeUser>();
  final _connectivityStatus = BehaviorSubject<String>();
  final _connectivity = Connectivity();
  final _shared = BehaviorSubject<SharedPreferences>();
  final _username = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _formKey = BehaviorSubject<GlobalKey<FormState>>();


  PaeUser get paeUser => _paeUser.value;
  String get connectionStatus => _connectivityStatus.value;
  SharedPreferences get sharedPrefs => _shared.value;

  Function(PaeUser) get setPaeUser => _paeUser.sink.add;
  Function(dynamic) get setResponse => _response.sink.add;
  Function(String) get setConnectionStatus => _connectivityStatus.sink.add;
  Function(SharedPreferences) get setSharedPref => _shared.sink.add;
  Function(String) get setUsername => _username.sink.add;
  Function(String) get setPassword => _password.sink.add;
  Function(GlobalKey<FormState>) get setKey => _formKey.sink.add;
  Function(String) get checkUser => userValidation;
  Function(String) get checkPass => passwordValidation;

  void initConnection() async =>
      setConnectionStatus((await _connectivity.checkConnectivity()).toString());
  void onConnectionChange() => _connectivity.onConnectivityChanged.listen(
      (ConnectivityResult result) => setConnectionStatus(result.toString()));

  void offlineToOnline() async{

    if(!connectionStatus.contains('none') && _paeUser.value.session == null){

      var paeAuth;
      var paeRLogin;

      paeAuth = await wsAuth();
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var user = preferences.get("username");
      var password = preferences.get("password");

      ///
      !paeAuth.containsValue('ok')
          ? _response.sink.add(paeAuth['exception'])
          : paeRLogin =
      await wsRLogin(user, password, paeAuth['response']['BACOSESS']);

      ///
      paeRLogin['service'] == 'error'
          ? _response.sink.add(paeRLogin['exception'])
          : _response.sink.add(paeRLogin['response']);

      setPaeUser(PaeUser.fromJson(_response.value,password: password));

    }
  }



  submit(String user, String password, BuildContext context) async {

    FocusScope.of(context).requestFocus(new FocusNode());

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

    //print(connectionStatus);
    if(connectionStatus.contains('none')) {
      SharedPreferences preferences = await SharedPreferences.getInstance();

      setSharedPref(preferences);

      List list = preferences.get("home");
      Map json = {
        "username" : preferences.get("username"),
        "password" : preferences.get("password"),
        "session" : "",
        "name" : preferences.get("name")
      };
      setPaeUser(PaeUser.fromJson(json, password: password));

      print(paeUser.toString());


      List newList = new List();
      list.forEach((value){
        newList.add(jsonDecode(value));
      });

      _response.sink.add(newList);

    }else {
      paeAuth = await wsAuth();
      SharedPreferences preferences = await SharedPreferences.getInstance();

      setSharedPref(preferences);

      ///
      !paeAuth.containsValue('ok')
          ? _response.sink.add(paeAuth['exception'])
          : paeRLogin =
      await wsRLogin(user, password, paeAuth['response']['BACOSESS']);

      ///
      paeRLogin['service'] == 'error'
          ? _response.sink.add(paeRLogin['exception'])
          : _response.sink.add(paeRLogin['response']);
    }
    //todo mudar isto daqui e fazer um auth mesmo fora do bloc
    setResponse(_response.value);
    setConnectionStatus(connectionStatus);
    return route2Home(context, password);
  }


   route2Home(BuildContext context, String password) async {
    var contentYear;
///
    print(connectionStatus);
    if(connectionStatus.contains('none')){

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  HomePage(
                      unitsCourseList: _response.value,
                      paeUser: paeUser)));

    }else {
      if (_response.value.runtimeType != String) {

        setPaeUser(PaeUser.fromJson(_response.value, password: password));

        sharedPrefs.setString("username", paeUser.username);
        sharedPrefs.setString("password", password);
        sharedPrefs.setString("name", paeUser.name);

        ///todo
    /*    if (sharedPrefs.getBool("memoLoginUser") != null &&
            sharedPrefs.getBool("memoLoginUser"))
          sharedPrefs.setStringList("userLogin", [paeUser.username, password]);*/

        contentYear = await wsYearsCoursesUnitsFolders(paeUser.session);

        contentYear['service'] == 'error'
            ? _response.sink.add(contentYear['exception'])
            : _response.sink.add(contentYear['response']);

        _response.value['childs'].isEmpty
            ? contentYear = await wsReadMyDefaultFoldersFolders(paeUser.session)
            : contentYear = await wsYearsCoursesUnitsFolders(paeUser.session);

        _response.sink.add(contentYear['response']);

        List lista = _response.value['childs'];

        saveListLocally("home", lista, sharedPrefs);
///
        //print(preferences.get("home"));
        //return _response.value['childs'];
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    HomePage(
                        unitsCourseList: _response.value['childs'],
                        paeUser: paeUser)));
      } else
        errorDialog(_response.value, context);
    }
  }

  dispose() {

    _username.close();
    _password.close();
    _formKey.close();
    _response.close();
    _paeUser.close();
    _connectivityStatus.close();
    _shared.close();
  }
}
