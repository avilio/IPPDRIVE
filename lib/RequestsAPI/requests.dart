import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ippdrive/dataJ.dart';



Future<HttpClientRequest> postRequest () async {

  var url ='https://pae.ipportalegre.pt/testes2/wsjson/api/app/ws-authenticate';
 // var body = { 'data': { 'apikey': '12345678901234567890' } };

 // Map <String, dynamic> userMap = jsonDecode(body);
  //print(userMap);
 // var apk = new AppKey.fromJson({ 'apikey': '12345678901234567890' });
  print(jsonEncode(glossaryData));
  //var dataj= new DataJ.fromJson({ 'data': jsonEncode(apk) });
  //print(jsonEncode(dataj));

  http.post(url,
      headers: {"Content-Type": "application/json"},
      body: 'data.json'
  ).then((http.Response response) {
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
    print(response.headers);

  });


  return null;
}

