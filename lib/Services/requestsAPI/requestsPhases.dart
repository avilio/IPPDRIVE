import 'dart:async';
import 'dart:convert';

import 'package:ippdrive/Services/requestsAPI/apiRESTRequests.dart';


  Map bacoSessAuth;
  Map bacoSessRLogin;
  Map courseUnitFoldersJson;

//todo acescentar campos nas classes para passar o login talvez nao seja a melhor solucao
  Future<Map> requestPhases(String user, String password) async {

/*
  wsAuth()
      .then((result)=> wsRLogin(user, password, result)
      .then((reply) => print(reply)));
  */

    //Outra maneira de fazer e provavelmente a ser usada
    bacoSessAuth = await wsAuth();
    bacoSessRLogin = await wsRLogin(user, password, bacoSessAuth['response']['BACOSESS']);

    if (bacoSessRLogin.length == 19)
      return bacoSessRLogin;
    //print(bacoSessRLogin.length);
    // String courseUnitListJson= await wsCoursesUnitsList(bacoSessRLogin);
    courseUnitFoldersJson = await wsCoursesUnitsContents(bacoSessRLogin['response']['BACOSESS']);

    //print(bacoSessRLogin.split(':')[1].split(',')[0].trim());

    // print(courseUnitFoldersJson);

    return courseUnitFoldersJson;
  }

  ///First Request to API
  Future<Map> wsAuth() async {
    var url = 'https://pae.ipportalegre.pt/testes2/wsjson/api/app/ws-authenticate';
    // var url ='/http://localhost:8080/baco/wsjson/api/app/ws-authenticate';
    Map body = { "data": { "apikey": "1234567890"}};
    //String bacoSess;

    String response = await postRequest(url, body);
    Map jsonReply = jsonDecode(response);
   /* if (jsonReply['service'] == 'error')
      return jsonReply['exception'];

    bacoSess = jsonReply['response']['BACOSESS'];
*/
    /*
  jsonReply.forEach((key,value) {
    if(value is Map)
      bacoSess = value['BACOSESS'];
  });*/


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
   // String session;
    String response = await postRequest(url, body);
    Map jsonReply = jsonDecode(response);

    /*if (jsonReply['service'] == 'error')
      return jsonReply['exception'];*/
/*
  jsonReply.forEach((key,value){
    if(value is Map)
      session = (value['BACOSESS']);
    });*/

    //session = jsonReply['response']['BACOSESS'];

    return jsonReply;
  }

  ///UnitsList Request to API
  Future<String> wsCoursesUnitsList(String bacosess) async {
    //meter https noslinks do teste2 e este units listo talves sirva, mas so par encontrar o semestre da cadeira

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

    //String courseUnitFoldersJson;
    String response = await postRequest(url, body);
    Map jsonReply = jsonDecode(response);

    if (jsonReply['service'] == 'error')
      return jsonReply['exception'];
    else
      //courseUnitFoldersJson = jsonReply.toString();
     // courseUnitFields(jsonReply);


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
   // String UnitsContents;

    String response = await postRequest(url, body);
    Map jsonReply = jsonDecode(response);

    if (jsonReply['service'] == 'error')
      return jsonReply['exception'];
    else {
      //UnitsContents = jsonReply.toString();
      //courseUnitFields(jsonReply);
      //jsonReply.forEach((a, b) => print('$a : $b'));
      return jsonReply;
    }
  }

