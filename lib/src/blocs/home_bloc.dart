import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../models/user.dart';
import '../resources/apiCalls.dart';
import '../common/dialogs.dart';
import '../screens/home.dart';
import '../common/utilities.dart';

class HomeBloc extends Object with  Utilities, Requests, ExceptionDialog, Connectivity{

  final _response = BehaviorSubject<dynamic>();
  final _paeUser = BehaviorSubject<PaeUser>();
  final _connectivityStatus = BehaviorSubject<String>();
  final _connectivity = Connectivity();

  //Stream<dynamic> get response => _response.stream;
  //Stream<PaeUser> get paeUser => _paeUser.stream;

  PaeUser get paeUser => _paeUser.value;
  String get connectionStatus => _connectivityStatus.value;

  Function(PaeUser) get setPaeUser => _paeUser.sink.add;
  Function(dynamic) get setResponse => _response.sink.add;
  Function(String) get setConnectionStatus =>_connectivityStatus.sink.add;

  void initConnection() async => setConnectionStatus((await _connectivity.checkConnectivity()).toString());
  void onConnectionChange() => _connectivity.onConnectivityChanged.listen((ConnectivityResult result)=> setConnectionStatus(result.toString()));

  route2Home(BuildContext context) async {
    var contentYear;

    if (_response.value.runtimeType != String) {
      setPaeUser(PaeUser.fromJson(_response.value));

      contentYear = await wsYearsCoursesUnitsFolders(paeUser.session);

      contentYear['service'] == 'error'
          ? _response.sink.add(contentYear['exception'])
          : _response.sink.add(contentYear['response']);

      _response.value['childs'].isEmpty
          ? contentYear = await wsReadMyDefaultFoldersFolders(paeUser.session)
          : contentYear = await wsYearsCoursesUnitsFolders(paeUser.session);

      _response.sink.add(contentYear['response']);

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                  unitsCourseList: _response.value['childs'], paeUser: paeUser)));
    } else
      errorDialog(_response.value, context);
  }


  dispose() {
    _response.close();
    _paeUser.close();
    _connectivityStatus.close();

  }
}