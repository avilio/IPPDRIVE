import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/dialogs.dart';
import '../common/error401.dart';
import '../common/permissions.dart';
import '../common/slugify.dart';
import '../common/utilities.dart';
import '../common/widgets/progress_indicator.dart';
import '../models/user.dart';
import '../resources/apiCalls.dart';
import '../saveLocally.dart';
import '../screens/home.dart';

class Bloc extends Object
    with Utilities, Requests, ExceptionDialog, Connectivity, SaveLocally,Error401, DevicePermissions {
  final _response = BehaviorSubject<dynamic>();
  final _paeUser = BehaviorSubject<PaeUser>();
  final _connectivityStatus = BehaviorSubject<String>();
  final _connectivity = Connectivity();
  final _shared = BehaviorSubject<SharedPreferences>();
  final _username = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _formKey = BehaviorSubject<GlobalKey<FormState>>();
  final _isMemo = BehaviorSubject<bool>();


  PaeUser get paeUser => _paeUser.value;
  String get connectionStatus => _connectivityStatus.value;
  SharedPreferences get sharedPrefs => _shared.value;
  bool get isMemo => _isMemo.value;
  String get username => _username.value;
  String get password => _password.value;

  Function(bool) get setIsMemo => _isMemo.sink.add;
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

    bool b = false;
    SharedPreferences pref = await SharedPreferences.getInstance();
      b = pref.get("memoUser") ?? false;
print(b);
    if(b)
      auth(user, password, context);
    else {
      setUsername(user);
      setPassword(password);


      if (_formKey.value.currentState.validate()) {
        final validUser = _username.value;
        final validPassword = _password.value;

        auth(validUser, validPassword, context);
      }
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
      //todo escola
      setPaeUser(PaeUser.fromJson(json, password: password,anoCorrente: preferences.get("anoCorrente")));

      print(paeUser.toString());


      List newList = new List();
      list.forEach((value){
        newList.add(jsonDecode(value));
      });

      _response.sink.add(newList);

    }else {
      Timer timer = Timer(Duration(seconds: 10),(){ errorDialog("Algo correu mal!!\nVerifique se o PAE esta com os servidores UP!", context); });

      paeAuth = await wsAuth();
      SharedPreferences preferences = await SharedPreferences.getInstance();

      setSharedPref(preferences);

      ///
      !paeAuth.containsValue('ok')
          ? _response.sink.add(paeAuth['exception'])
          : paeRLogin =
      await wsRLogin(user, password, paeAuth['response']['BACOSESS']);

      ///
      if(paeRLogin['service'] == 'error'){
           _response.sink.add(paeRLogin['exception']);
           preferences.setBool("memoUser", false);
      }else
         _response.sink.add(paeRLogin['response']);

      timer.cancel();
    }
    //todo mudar isto daqui e fazer um auth mesmo fora do bloc
    setResponse(_response.value);
    setConnectionStatus(connectionStatus);
    route2Home(context, password);
  }

   route2Home(BuildContext context, String password) async {
    var contentYear;
///todo
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


        var map = await getYears(_response.value["BACOSESS"]);
        //todo este escola é para mudar porque na realidade esta a ir ao mail que no caso d aluno tem ippportalgre
        setPaeUser(PaeUser.fromJson(_response.value,password: password,anoCorrente: map['response']['importYear']));

        sharedPrefs.setString("username", paeUser.username);
        sharedPrefs.setString("password", password);
        sharedPrefs.setString("name", paeUser.name);
        sharedPrefs.setString("anoCorrente", paeUser.anoCorrente);

        ///todo
    /*    if (sharedPrefs.getBool("memoLoginUser") != null &&
            sharedPrefs.getBool("memoLoginUser"))
          sharedPrefs.setStringList("userLogin", [paeUser.username, password]);*/

        contentYear = await wsYearsCoursesUnitsFolders(paeUser.session);

        contentYear['service'] == 'error'
            ? _response.sink.add(contentYear['exception'])
            : _response.sink.add(contentYear['response']);

        if(_response.value['childs'].isEmpty) {
            if(!isNumeric(paeUser.username))
              contentYear = await wsReadMyDefaultFoldersFolders(paeUser.session);
        }
         else
           contentYear = await wsYearsCoursesUnitsFolders(paeUser.session);

        _response.sink.add(contentYear['response']);

        List lista = _response.value['childs'];
        //todo apagar o clear
        //await sharedPrefs.clear();
        saveListLocally("home", lista, sharedPrefs);
///
        showDialog(context: context,
            barrierDismissible: false,
            child: AlertDialog(
              content: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  AdaptiveProgressIndicator(),
                  Text('      Loading...')
                ],
              ),
            )
        );

        await checkWriteExternalStorage();
        await checkReadExternalStorage();
        Future.delayed(Duration(seconds: 3),(){
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      HomePage(
                          unitsCourseList: _response.value['childs'],
                          paeUser: paeUser)));
        });

      } else
        errorDialog(_response.value, context);
    }
  }

  Future checkOnlineIsGreaterThanLocal(items, BuildContext context) async {

    String dir = await buildFileDirectory(items['path']);

    try {
      if(
      await FileSystemEntity.type("$dir/${items["title"]}") != FileSystemEntityType.notFound) {
            try {
              //sharedPrefs.get("${items['path']}/${items['title']}");
              //Map localFile = jsonDecode(;
              File file = new File('$dir/${items['title']}');
              //DateTime lastMod = file.lastModifiedSync();
              //todo

              int localTime = sharedPrefs.get("${items['path']}/${items['title']}/localTime") ?? 0;
              //print("JSON ${localFile['dateUpdateDate']}  -> LOCAL ${file.lastModifiedSync().millisecondsSinceEpoch};");
              print("$localTime ->"+" ${file.lastModifiedSync().millisecondsSinceEpoch}");

              if(localTime ==  file.lastModifiedSync().millisecondsSinceEpoch){
                //todo apagar print
                print(items['title']+" sao iguais");
                if (localTime < items['dateUpdateDate'])
                  sharedPrefs.setBool("isModify/${items['path']}/${items['id']}", true);
              }else {
                //todo apagar print
                print(items['title']+" modificaçao local");
                sharedPrefs.setBool("localFile/${items['path']}/${items['id']}", true);
              }
            } catch (e) {
              print(e);
            }
          }
    } catch (e) {
      print(e);
    }
  }

  ///
  Future fileOfflineToOnline(Bloc bloc, items) async{


    bloc.sharedPrefs.remove("isModify/${items['path']}/${items['id']}");
    bloc.sharedPrefs.remove("newFile/${items['id']}");

    File localFile = await bloc.getFiles(bloc.paeUser.session, items);

    bloc.uploadFile(localFile, bloc.paeUser.session).then((resp)async {
      Slugify slug = Slugify();

       Map object = {
                  "@class": "pt.estgp.estgweb.domain.PageRepositoryFileImpl",
                  "id": 0,
                  "tmpFile": resp['uploadedFiles'][0],
                  "title": resp['uploadedFiles'][0]['fileName'],
                  "slug": slug.slugGenerator(resp['uploadedFiles'][0]['fileName']),
                  "repositoryFile4JsonView": null,
                  "visible": true,
                  "cols": 12
                };
      //Map object = items;
     // object["tmpFile"] = resp['uploadedFiles'][0];
      //todo testar com o now parent ID

        Map map = await bloc.addFile(object, items['nowParentId'], bloc.paeUser.session);

          map.forEach((key,value)=>  print("$key : $value"));


      return map;
    });
  }


  Future fileOnlineToOffline(Bloc bloc, items) async {

    File file = await bloc.getFiles(bloc.paeUser.session, items);

    print(file.path);
    bloc.sharedPrefs.remove(items['id'].toString());

    //bloc.sharedPrefs.setString(items['id'].toString(), jsonEncode(items));
  }

  dispose() {

    _username.close();
    _password.close();
    _formKey.close();
    _response.close();
    _paeUser.close();
    _connectivityStatus.close();
    _shared.close();
    _isMemo.close();
  }
}
