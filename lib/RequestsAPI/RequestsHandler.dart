import 'dart:async';
import 'dart:convert';

import 'package:ippdrive/RequestsAPI/ApiPostRequests.dart';


Future Handler(String user, String password)async {

  var url ='https://pae.ipportalegre.pt/testes2/wsjson/api/app/ws-authenticate';
  Map body = { "data": { "apikey": "12345678901234567890" } };

  String response = await postRequest(url,body);
  Map jsonReply = jsonDecode(response);

  //jsonReply.forEach((a,b) => print('$a : $b'));
  var jsonResponse = jsonReply['response'];
  String bacosess = jsonResponse['BACOSESS'];

  print(bacosess);
  print(user);
  print(password);



}