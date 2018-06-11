import 'dart:io';
import 'dart:async';
import 'dart:convert';

class API {

  ///creates a singleton
  static final API _instance = new API.internal();
  API.internal();
  factory API() => _instance;


  /**
   * Sends a POST request to a given [url] with the [jsonMap] as a payload
   * and returns a json as a string [reply]
   */
  Future<dynamic> post(String url, Map jsonMap) async {
    var result;
    HttpClient httpClient = new HttpClient();

    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(jsonMap)));
    HttpClientResponse response = await request.close();

    if (response.statusCode == HttpStatus.OK) {
      result = jsonDecode(await response.transform(utf8.decoder).join());
    } else
      result = new Exception('Erro ${response.statusCode}');//to string se nao funcionar

    httpClient.close();
    request.close();

    return result;
  }


  //todo get para ficheiro

}