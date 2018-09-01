import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/dialogs.dart';
import '../common/utilities.dart';
import '../models/user.dart';
import '../resources/apiCalls.dart';
import '../saveLocally.dart';
import '../screens/home.dart';

class HomeBloc extends Object
    with Utilities, Requests, ExceptionDialog, Connectivity, SaveLocally {
  final _response = BehaviorSubject<dynamic>();
  final _paeUser = BehaviorSubject<PaeUser>();
  final _connectivityStatus = BehaviorSubject<String>();
  final _connectivity = Connectivity();
  final _shared = BehaviorSubject<SharedPreferences>();

  //Stream<dynamic> get response => _response.stream;
  //Stream<PaeUser> get paeUser => _paeUser.stream;

  PaeUser get paeUser => _paeUser.value;
  String get connectionStatus => _connectivityStatus.value;
  SharedPreferences get sharedPrefs => _shared.value;

  Function(PaeUser) get setPaeUser => _paeUser.sink.add;
  Function(dynamic) get setResponse => _response.sink.add;
  Function(String) get setConnectionStatus => _connectivityStatus.sink.add;
  Function(SharedPreferences) get setSharedPref => _shared.sink.add;

  void initConnection() async =>
      setConnectionStatus((await _connectivity.checkConnectivity()).toString());
  void onConnectionChange() => _connectivity.onConnectivityChanged.listen(
      (ConnectivityResult result) => setConnectionStatus(result.toString()));

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
    _response.close();
    _paeUser.close();
    _connectivityStatus.close();
    _shared.close();
  }
}
