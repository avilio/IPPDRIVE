import 'dart:async';
import 'dart:convert';


import 'package:ippdrive/RequestsAPI/ApiRESTRequests.dart';


Future<String> requestPhases(String user, String password)async {

/*
  wsAuth()
      .then((result)=> wsRLogin(user, password, result)
      .then((reply) => print(reply)));
  */

  //Outra maneira de fazer e provavelmente a ser usada
  String bacoSessAuth= await wsAuth();
  String bacoSessRLogin = await wsRLogin(user, password, bacoSessAuth);
 // String courseUnitListJson= await wsCoursesUnitsList(bacoSessRLogin);
  String courseUnitFoldersJson= await wsCoursesUnitsFolders(bacoSessRLogin);
  //print(bacoSessRLogin.split(':')[1].split(',')[0].trim());

 // print(courseUnitFoldersJson);

  return courseUnitFoldersJson;
}
///First Request to API
Future<String> wsAuth ()async {

  var url ='https://pae.ipportalegre.pt/testes2/wsjson/api/app/ws-authenticate';
  Map body = { "data": { "apikey": "12345678901234567890" } };
  String bacoSess;

  String response = await postRequest(url,body);
  Map jsonReply = jsonDecode(response);
  bacoSess = jsonReply['response']['BACOSESS'];
/*
  jsonReply.forEach((key,value) {
    if(value is Map)
      bacoSess = value['BACOSESS'];
  });*/


  return bacoSess;
}
///Second Request to API
Future<String> wsRLogin (String user, String password, String bacosess)async {

  var url = 'https://pae.ipportalegre.pt/testes2/wsjson/api/app/secure/ws-rlogin-challenge';
  var body = {
    "data": {
      "chaveAppsMoveis": password,
      "username": user
    },
    "BACOSESS": bacosess
  };
  String session;
  String response = await postRequest(url,body);
  Map jsonReply = jsonDecode(response);

  if(jsonReply['service'] == 'error')
    return jsonReply['exception'];
/*
  jsonReply.forEach((key,value){
    if(value is Map)
      session = (value['BACOSESS']);
    });*/

  session = jsonReply['response']['BACOSESS'];

  return session;
}
///UnitsList Request to API
Future<String> wsCoursesUnitsList (String bacosess)async {
  //meter https noslinks do teste2 e este units listo talves sirva, mas so par encontrar o semestre da cadeira
  var url = 'https://pae.ipportalegre.pt/testes2/wsjson/api/user/ws-courses-units-my-list?BACOSESS=${bacosess}';


  String courseUnitListJson;
  String response = await getRequest(url);
  Map jsonReply = jsonDecode(response);

  if(jsonReply['service'] == 'error')
    return jsonReply['exception'];
  else
    courseUnitListJson = jsonReply.toString();

  //jsonReply.forEach((a,b) => print('$a : $b'));

  return courseUnitListJson;
}
///Folders Request to API
Future<String> wsCoursesUnitsFolders (String bacosess)async {

  var url = 'https://pae.ipportalegre.pt/testes2/user/vfs.do';
  var body = {
    "BACOSESS": bacosess,
    "data": {
     // "year":"201718" //pode ir ou nao, se nao levar parametros vai buscar o ano atual
    },
    "serviceJson": "vfsReadMyCourseUnitsContents"
  };

  String courseUnitFoldersJson;
  String response = await postRequest(url,body);
  Map jsonReply = jsonDecode(response);

  if(jsonReply['service'] == 'error')
    return jsonReply['exception'];
  else
    courseUnitFoldersJson = jsonReply.toString();

  print(jsonReply['response']['childs']);
  //jsonReply.forEach((a,b) => print('$a : $b'));

  return courseUnitFoldersJson;
}


