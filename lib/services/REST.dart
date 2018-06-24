import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class REST {

  ///creates a singleton
  static final REST _instance = new REST.internal();

  REST.internal();

  factory REST() => _instance;


  /**
   * Sends a POST request to a given [url] with the [jsonMap] as a payload
   * and returns a json as a string [reply]
   */
  Future<dynamic> post(String url, Map jsonMap) async =>
      http.post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(jsonMap)
    ).then((response) => jsonDecode(response.body));
  

  
//return await http.get(url);
  Future<dynamic> get(String url) async =>
      http.get(url).then((response)=> jsonDecode(response.body));


}