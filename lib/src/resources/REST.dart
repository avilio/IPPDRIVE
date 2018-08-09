import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class REST {

  ///creates a singleton
  static final REST _instance = new REST.internal();

  REST.internal();

  factory REST() => _instance;

  /// Sends a POST request to a given [url] with the [jsonMap] as a payload
  /// and returns a json as a string [reply]
  Future<dynamic> post(String url, Map jsonMap) async => http
          .post(url,
              headers: {"Content-Type": "application/json"},
              body: jsonEncode(jsonMap))
          .then((response) {
        if (response.statusCode == 200)
          return jsonDecode(response.body);
        else
         // return response.statusCode;
          throw (response.statusCode);
      });

  ///
  Future<dynamic> get(String url) async =>
      http.get(url).then((response) => jsonDecode(response.body));

  ///
  Future<dynamic> postAppKey(String url, bodyApp) async => http
      .post(url,
          headers: {
            // "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          },
          body: bodyApp)
      .then((response) => jsonDecode(response.body));

  ///
  Future<dynamic> multipartRequest(String session, List<String> mimeType, String url, File file, {String fileFolders}) async {
    String filename = file.path.split("/").last;

    ///name
    String filePath = file.path;

    ///path
    ///
    print('${mimeType[0]} / ${mimeType[1]} ');
    print(url);

    ///
    print(filename);
    print(filePath);

    final fileUploadRequest = http.MultipartRequest('POST', Uri.parse(url));
    final payload = await http.MultipartFile.fromPath('$filename', filePath,
        contentType: MediaType(mimeType[0], mimeType[1]), filename: filename);

    //var file = http.ByteStream(DelegatingStream.typed(filePath.openRead()));
    //var length = await filePath.length();
    //var requestfile = new http.MultipartFile(filename, file, length, filename: filePath.path);

    fileUploadRequest.headers['Cookie'] = "BACOSESS=$session";
    fileUploadRequest.fields['Content-Disposition'] = "form-data";
    fileUploadRequest.fields['name'] = "filesInputId-UPLOAD[]";
    fileUploadRequest.files.add(payload);

    if (fileFolders != null) {
      //fileUploadRequest.fields['Referer'] = Uri.encodeComponent(fileFolders);
      fileUploadRequest.headers['Referer'] = fileFolders;
    }

    // var response = await fileUploadRequest.send();
    //print(response.statusCode);

    //response.stream.transform(utf8.decoder).listen((value) => print(value));

    try {
      final streamedResponse = await fileUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 200) {
        print('Algo correu mal');
        print(jsonDecode(response.body));
        return null;
      }
      return jsonDecode(response.body);
    } catch (error) {
      print(error);
      return null;
    }
  }
}
