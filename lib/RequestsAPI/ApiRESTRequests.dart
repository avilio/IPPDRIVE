import 'dart:async';
import 'dart:convert';
import 'dart:io';

Future<String> postRequest (String url, Map jsonMap) async {

  String reply;

  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
  request.headers.set('content-type', 'application/json');
  request.add(utf8.encode(json.encode(jsonMap)));
  HttpClientResponse response = await request.close();
  // todo - you should check the response.statusCode
  if ( response.statusCode == 200) {
    reply = await response.transform(utf8.decoder).join();
  }else {
    reply = 'ERROR ON REQUEST ${response.statusCode}';
  }
  httpClient.close();

  return reply;
}

Future<String> getRequest (String url) async {

  String reply;

  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
  HttpClientResponse response = await request.close();
  // todo - you should check the response.statusCode
  if ( response.statusCode == 200) {
    reply = await response.transform(utf8.decoder).join();
  }else {
    reply = 'ERROR ON REQUEST ${response.statusCode}';
  }
  httpClient.close();

  return reply;
}



