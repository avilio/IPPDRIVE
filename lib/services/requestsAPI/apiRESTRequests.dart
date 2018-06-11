/*
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;


*/
/**
 * Sends a POST request to a given [url] with the [jsonMap] as a payload
 * and returns a json as a string [reply]
 *//*

Future<String> postRequest (String url, Map jsonMap) async {

  String reply;
  
  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
  request.headers.set('content-type', 'application/json');
  request.add(utf8.encode(json.encode(jsonMap)));
  HttpClientResponse response = await request.close();
  if ( response.statusCode == HttpStatus.OK) {
    reply = await response.transform(utf8.decoder).join();
  }else {
    reply = 'ERROR ON REQUEST ${response.statusCode}';
  }
  httpClient.close();
  request.close();
  //print(reply);

  return reply;
}

Future<dynamic> getRequest (String url) async {

  var reply;

  var response = await http.get(url);

  if ( response.statusCode == HttpStatus.OK)
    reply = response;
  else
    reply = 'ERROR ON REQUEST ${response.statusCode}';
  */
/*
  reply = await http.get(url)
  .then((http.Response response) {
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
    print(response.headers);
    print(response.request);
  });*//*

*/
/*
  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
  HttpClientResponse response = await request.close();
  if ( response.statusCode == 200) {
    reply = await response.transform(utf8.decoder).join();
  }else {
    reply = 'ERROR ON REQUEST ${response.statusCode}';
  }
  httpClient.close();*//*

  return reply;
}



*/
