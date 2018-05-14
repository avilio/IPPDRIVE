import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:ippdrive/RequestsAPI/ApiPostRequests.dart';


Future<String> handler(String user, String password)async {

/*
  wsAuth()
      .then((result)=> wsRLogin(user, password, result)
      .then((reply) => print(reply)));
  */

  //Outra maneira de fazer e provavelmente a ser usada
  String bacosess= await wsAuth();

  String replyRLogin = await wsRLogin(user, password, bacosess);
  //print(replyRLogin.split(':')[1].split(',')[0].trim());

  /* todo tratar do get das courses units
  http.get('https://pae.ipportalegre.pt/testes2/wsjson/api/user/ws-courses-units-my-list').then((http.Response response) {
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
    print(response.headers);
    print(response.request);
  });
  */

  return replyRLogin;
}
///First Request to API
Future<String> wsAuth ()async {

  var url ='https://pae.ipportalegre.pt/testes2/wsjson/api/app/ws-authenticate';
  Map body = { "data": { "apikey": "12345678901234567890" } };
  String key;

  String response = await postRequest(url,body);
  Map jsonReply = jsonDecode(response);

  jsonReply.forEach((a,b) {
    if(b is Map)
      key = b['BACOSESS'];
  });

  return key;
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

  String response = await postRequest(url,body);
  Map jsonReply = jsonDecode(response);
  if(jsonReply['service'] == 'error')
    return jsonReply['exception'];
  //jsonReply.forEach((a,b) => print('$a : $b'));

  return jsonReply.toString();
}