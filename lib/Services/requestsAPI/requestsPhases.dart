import 'dart:async';
import 'dart:convert';

import 'package:ippdrive/Services/requestsAPI/apiRESTRequests.dart';

  ///First Request to API
  Future<Map> wsAuth() async {
    var url = 'https://pae.ipportalegre.pt/testes2/wsjson/api/app/ws-authenticate';
    // var url ='/http://localhost:8080/baco/wsjson/api/app/ws-authenticate';
    Map body = { "data": { "apikey": "1234567890"}};

    String response = await postRequest(url, body);
    Map jsonReply = jsonDecode(response);

    return jsonReply;
  }

  ///Second Request to API
  Future<Map> wsRLogin(String user, String password, String bacosess) async {
    var url = 'https://pae.ipportalegre.pt/testes2/wsjson/api/app/secure/ws-rlogin-challenge';
    //var url = 'http://localhost:8080/baco/wsjson/api/app/secure/ws-rlogin-challenge';
    var body = {
      "data": {
        "chaveAppsMoveis": password,
        "username": user
      },
      "BACOSESS": bacosess
    };

    String response = await postRequest(url, body);
    Map jsonReply = jsonDecode(response);
    //print(s._session);
    return jsonReply;
  }

  ///UnitsList Request to API
  Future<String> wsCoursesUnitsList(String bacosess) async {

    var url = 'https://pae.ipportalegre.pt/testes2/wsjson/api/user/ws-courses-units-my-list?BACOSESS=${bacosess}';
    //var url = 'http://localhost:8080/baco/wsjson/api/user/ws-courses-units-my-list?BACOSESS=${bacosess}';

    String courseUnitListJson;
    String response = await getRequest(url);
    Map jsonReply = jsonDecode(response);

    if (jsonReply['service'] == 'error')
      return jsonReply['exception'];
    else
      courseUnitListJson = jsonReply.toString();

    //jsonReply.forEach((a,b) => print('$a : $b'));

    return courseUnitListJson;
  }

  ///Folders Request to API
  Future<Map> wsCoursesUnitsContents(String bacosess) async {
    // var url = 'http://localhost:8080/baco/user/vfs.do';
    var url = 'https://pae.ipportalegre.pt/testes2/user/vfs.do';
    var body = {
      "BACOSESS": bacosess,
      "data": {
        // "year":"201718" //pode ir ou nao, se nao levar parametros vai buscar o ano atual
      },
      "serviceJson": "vfsReadMyCourseUnitsContents"
    };

    String response = await postRequest(url, body);
    Map jsonReply = jsonDecode(response);

    if (jsonReply['service'] == 'error')
      return jsonReply['exception'];
    else
      return jsonReply;
  }

  ///Contents inside UCFolders
  Future<Map> courseUnitsContents(int parentId, String session) async {

    print(session);

    var url = 'https://pae.ipportalegre.pt/testes2/user/vfs.do';

    var body = {
      "BACOSESS": session,
      "data": {"command": "read", "parentId": parentId},
      "serviceJson": "vfscommand"
    };

    String response = await postRequest(url, body);
    Map jsonReply = jsonDecode(response);

    if (jsonReply['service'] == 'error')
      return jsonReply['exception'];
    else
      return jsonReply;

  }

