import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:ippdrive/RequestsAPI/ApiPostRequests.dart';


Future<String> handler(String user, String password)async {

  String repsonse;
/*
  wsAuth()
      .then((result)=> wsRLogin(user, password, result)
      .then((reply) => print(reply)));
  */
  //Outra maneira de fazer e provavelmente a ser usada
  String bacosess= await wsAuth();
  //print(bacosess);


  //jsonReply.forEach((a,b) => print('$a : $b'));
  //print(user);
  //print(password);

  String replyRLogin = await wsRLogin(user, password, bacosess);
  //todo ir buscar o campo da exception para retornar





  /* todo tratar do get das courses units
  http.get('https://pae.ipportalegre.pt/testes2/wsjson/api/user/ws-courses-units-my-list').then((http.Response response) {
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
    print(response.headers);
    print(response.request);

  });
  */
  //ira retornar a exception
  return null;

}

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
  //jsonReply.forEach((a,b) => print('$a : $b'));

  return jsonReply.toString();
}