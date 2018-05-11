import 'dart:async';
import 'dart:convert';

import 'package:ippdrive/RequestsAPI/apiPostRequests.dart';



Future Handler()async {

  var url ='https://pae.ipportalegre.pt/testes2/wsjson/api/app/ws-authenticate';
  Map body = { "data": { "apikey": "12345678901234567890" } };

  String response = await postRequest(url,body);
  Map jsonReply = jsonDecode(response);

  jsonReply.forEach((a,b) => print('$a : $b'));


}