import 'dart:async';
import 'dart:convert';

import 'package:ippdrive/RequestsAPI/apiPostRequests.dart';

class inputFormValues extends Object {

  String _user;
  String _pass;

  inputFormValues(this._user, this._pass);

  set user(String value) {
    _user = value;
  }

  set pass(String value) {
    _pass = value;
  }
}

Future Handler( inputFormValues values)async {

  var url ='https://pae.ipportalegre.pt/testes2/wsjson/api/app/ws-authenticate';
  Map body = { "data": { "apikey": "12345678901234567890" } };

  String response = await postRequest(url,body);
  Map jsonReply = jsonDecode(response);

  //jsonReply.forEach((a,b) => print('$a : $b'));
  var jsonResponse = jsonReply['response'];

  String bacosess = jsonResponse['BACOSESS'];
  print(bacosess);
  print(values._user);
  print(values._pass);
}