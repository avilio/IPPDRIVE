import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:ippdrive/Services/requestsAPI/apiRESTRequests.dart';

//var host = 'https://pae.ipportalegre.pt/testes2';
final String server = defaultTargetPlatform == TargetPlatform.android ? "10.0.2.2" : "localhost";

var host = 'http://$server:8080/baco';

  ///First Request to API
  Future<Map> wsAuth() async {
    //var url = 'https://pae.ipportalegre.pt/testes2/wsjson/api/app/ws-authenticate';
    var url ='$host/wsjson/api/app/ws-authenticate';
    Map body = { "data": { "apikey": "1234567890"}};

    String response = await postRequest(url, body);

    return jsonDecode(response);
  }

  ///Second Request to API
  Future<Map> wsRLogin(String user, String password, String bacosess) async {
    //var url = 'https://pae.ipportalegre.pt/testes2/wsjson/api/app/secure/ws-rlogin-challenge';
    var url ='${host}/wsjson/api/app/secure/ws-rlogin-challenge';
    var body = {
      "data": {
        "chaveAppsMoveis": password,
        "username": user
      },
      "BACOSESS": bacosess
    };

    String response = await postRequest(url, body);

    return jsonDecode(response);
  }

  ///UnitsList Request to API
  Future<String> wsCoursesUnitsList(String bacosess) async {

    //var url = 'https://pae.ipportalegre.pt/testes2/wsjson/api/user/ws-courses-units-my-list?BACOSESS=${bacosess}';
    var url = '${host}/wsjson/api/user/ws-courses-units-my-list?BACOSESS=${bacosess}';

    String response = await getRequest(url);

    if (jsonDecode(response)['service'] == 'error')
      return jsonDecode(response)['exception'];
    else
      return jsonDecode(response);
  }

  ///Folders Request to API
  Future<Map> wsCoursesUnitsContents(String bacosess) async {
     var url = '${host}/user/vfs.do';
    //var url = 'https://pae.ipportalegre.pt/testes2/user/vfs.do';
    var body = {
      "BACOSESS": bacosess,
      "data": {
        // "year":"201718" //pode ir ou nao, se nao levar parametros vai buscar o ano atual
      },
      "serviceJson": "vfsReadMyCourseUnitsContents"
    };

    String response = await postRequest(url, body);

    if (jsonDecode(response)['service'] == 'error')
      return jsonDecode(response)['exception'];
    else
      return jsonDecode(response);
  }

  ///Contents inside UCFolders
  Future<Map> courseUnitsContents(List list, String session) async {
    Iterator i = list.iterator;
    int parentId;

    while(i.moveNext()) {
      parentId = i.current['id'];
    }
      //print(parentId);
      //var url = 'https://pae.ipportalegre.pt/testes2/user/vfs.do';
      var url = '${host}/user/vfs.do';
      var body = {
        "BACOSESS": session,
        "data": {"command": "read", "parentId": parentId},
        "serviceJson": "vfscommand"
      };

      String response = await postRequest(url, body);

      if (jsonDecode(response)['service'] == 'error')
        return jsonDecode(response)['exception'];
      else
        return jsonDecode(response);
  //  }
  }

