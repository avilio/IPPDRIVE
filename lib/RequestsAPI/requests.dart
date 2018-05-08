import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;


Future<String> postRequest () async {

  var url ='https://pae.ipportalegre.pt/testes2/wsjson/api/app/ws-authenticate';
  var body = { "data": { "apikey": "12345678901234567890" } };

  http.post(url,
      headers: {'Content-type': 'application/json'},
      body: jsonEncode(body)
  ).then((http.Response response) {
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
    print(response.headers);
    print(response.request);

  });

  return null;
}
