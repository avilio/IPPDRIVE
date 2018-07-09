import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class REST {

  ///creates a singleton
  static final REST _instance = new REST.internal();

  REST.internal();

  factory REST() => _instance;


  /// Sends a POST request to a given [url] with the [jsonMap] as a payload
  /// and returns a json as a string [reply]
  Future<dynamic> post(String url, Map jsonMap) async =>
      http.post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(jsonMap)
      ).then((response) {
        if(response.statusCode == 200)
          return jsonDecode(response.body);
        else
          throw (response.statusCode);
      });

  ///
  Future<dynamic> get(String url) async =>
      http.get(url).then((response)=> jsonDecode(response.body));

  ///
  Future<dynamic> postAppKey(String url, bodyApp) async =>
      http.post(url,
          headers: {
            // "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"},
          body: bodyApp
      ).then((response) => jsonDecode(response.body));

  ///
  Future<dynamic> multipartRequest(List<String> mimeType,String url,String filename, String filePath,{String fileFolders} ) async{

    print('${mimeType[0]} / ${mimeType[1]} ');
    print(url);
    print(filename);
    print(filePath);

    final fileUploadRequest = http.MultipartRequest('POST', Uri.parse(url));
    final file = await http.MultipartFile.fromPath('$filename', filePath,
        contentType: MediaType(mimeType[0],mimeType[1]),
    filename: filename);


    //Content-Disposition: form-data; name="filesInputId-UPLOAD[]";
    fileUploadRequest.fields['Content-Disposition'] = "form-data";
    fileUploadRequest.fields['name'] = "filesInputId-UPLOAD[]";
    fileUploadRequest.files.add(file);

    if(fileFolders != null){
      //fileUploadRequest.fields['Referer'] = Uri.encodeComponent(fileFolders);
      fileUploadRequest.headers['Referer'] = fileFolders;
    }

    try{
      final streamedResponse = await fileUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      if(response.statusCode != 200 && response.statusCode != 201) {
        print('Algo correu mal');
        print(jsonDecode(response.body));
        return null;
      }
      return jsonDecode(response.body);

    }catch(error){
      print(error);
      return null;
    }

  }
}