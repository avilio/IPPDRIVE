import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'requestsHTTP.dart';

/// Due to the simulation purposes, the Android VM simulator does not recognize localhost as
/// localhost, so the address 10.0.2.2 have to replace the original address, in order to work
final String server = defaultTargetPlatform == TargetPlatform.android ? "10.0.2.2" : "localhost";
/// The [host] that contains the web service
var host = 'http://$server:8080/baco';
//var host = 'http://172.20.107.87:80/baco';
//var host = 'https://pae.ipportalegre.pt';

class Requests {
  final rest = HTTPRequests.internal();

  /// Create a body JSON to send a post request to the api and returns a [Map] obtained as response,
  /// this is the first phase of user authentication, in order to 'login' into to the app.
  /// (the 'apikey' 1234567890 it was generated by the Api Admin)
  Future<Map> wsAuth() async{
    var url = '$host/wsjson/api/app/ws-authenticate';
   Map body = { "data": { "apikey": "1234567890"}};
   // Map body = { "data": { "apikey": "#\$223567&jjad#46f.,-ayalker\\ergnermvf"}};

    return await rest.post(url, body);
  }

  /// Create a [body] JSON with given [user], [password] and [bacoSess] to send a post request to the api
  /// and returns a Map obtained as response, bacosess is a field from the Map returned by [wsAuth],
  /// username and password (chave de App Moveis) need to be previously generated by the user
  Future<Map> wsRLogin(String user, String password, String bacoSess) async {
    var url = '$host/wsjson/api/app/secure/ws-rlogin-challenge';
    var body = {
      "data": {
        "chaveAppsMoveis": password,
        "username": user
      },
      "BACOSESS": bacoSess
    };
    return await rest.post(url, body);
  }

  /// Create a [body] JSON with given [bacoSess] to send a post request to the api
  /// and returns a Map with the course units from the specific year as [response].
  /// [bacoSess] is a field from the Map returned by [wsRLogin]
  Future<Map> wsYearsCoursesUnitsFolders(String bacoSess, [year]) async {
    if (year == null)
      year = 201718;

    var url = '$host/user/vfs.do';

    var body = {
      "BACOSESS": bacoSess,
      "data": {
        "year": year.toString()
        //pode ir ou nao, se nao levar parametros vai buscar o ano atual
      },
      "serviceJson": "vfsReadMyCourseUnitsContents"
    };

    return await rest.post(url, body);
  }

  /// Create a [body] JSON with given [bacoSess] to send a post request to the api
  /// and returns a Map with the course units from the specific year as [response].
  /// [bacoSess] is a field from the Map returned by [wsRLogin]
  Future<Map> wsReadMyDefaultFoldersFolders(String bacoSess) async {

    var url = '$host/user/vfs.do';

    var body = {
      "BACOSESS": bacoSess,
      "data": {},
      "serviceJson": "vfsReadMyDefaultFolders"
    };

    return await rest.post(url, body);
  }

  /// Create a [body] JSON with given [list] and [session] to send a post request to the api
  /// and returns a Map with the content of a course unit as [response].
  Future<Map> courseUnitsFoldersContents(int id, String session) async {

    var url = '$host/user/vfs.do';
    var body = {
      "BACOSESS": session,
      "data": {"command": "read", "parentId":id},
      "serviceJson": "vfscommand"
    };

    return await rest.post(url, body);
  }

  /// Create a [body] JSON with given [id] and [session] to send a post request to the api
  /// and returns a Map with the folder added to favorites as [response].
  Future<Map> addFavorites(int id, String session) async {
    var url = '$host/user/vfs.do';
    var body = {
      "BACOSESS": session,
      "data": {"id": id},
      "serviceJson": "vfsAddFavorite"
    };

    return await rest.post(url, body);
  }

  /// Create a [body] JSON with given [id] and [session] to send a post request to the api
  /// and returns a Map with the folder removed to favorites as [response].
  Future<Map> remFavorites(int id, String session) async {
    var url = '$host/user/vfs.do';
    var body = {
      "BACOSESS": session,
      "data": {"id": id},
      "serviceJson": "vfsRemoveFavorite"
    };

    return await rest.post(url, body);
  }

  /// Create a [body] JSON with given [session] to send a post request to the api
  /// and returns a Map with the list of favorites as [response].
  Future<Map> readFavorites(String session) async {
    var url = '$host/user/vfs.do';
    var body = {
      "BACOSESS": session,
      "data": {},
      "serviceJson": "vfsReadFavorites"
    };

    Map map = await rest.post(url, body);
    if(map.isNotEmpty)
      return map;
    else
      return {"": ""};

  }

  ///
  Future<Map> addFile(Map object, int parentId, String session) async {
 //todo apagar prints

    var url = '$host/user/vfs.do';
    var body = {
      "BACOSESS": session,
      "data": {
        "command": "addFiles",
        "object": jsonEncode(object),
        "parentId" : parentId,
      },
      "serviceJson": "vfscommand"
    };
      print("JSONENCODE" +jsonEncode(body));
      Map map  = await rest.post(url, body);

     // map['response'].forEach((key,value)=>print("$key: $value"));

    return map;
  }

  ///
  Future<Map> editFile(Map object, int parentId, String session) async {
    //todo apagar prints
    print(jsonEncode(object));
    var url = '$host/user/vfs.do';
    var body = {
      "BACOSESS": session,
      "data": {
        "command": "editFiles",
        "object":jsonEncode(object),
        "parentId" : parentId,
      },
      "serviceJson": "vfscommand"
    };
    print(jsonEncode(body));
    return await rest.post(url, body);
  }


  ///
  Future<Map> removeFile(Map object, int parentId, String session) async {
    print(parentId);
    var url = '$host/user/vfs.do';
    var body = {
      "BACOSESS": session,
      "data": {
        "command": "removeFiles",
        "object":jsonEncode(object),
        "parentId" : parentId,
      },
      "serviceJson": "vfscommand"
    };

    return await rest.post(url, body);
  }

  ///
  Future<Map> uploadFile(File file, String session) async {
    final mimeTypeData = lookupMimeType(file.path).split('/');
    final fileUploadfile = await rest.multipartRequest(session, mimeTypeData, '$host/filesUpload', file);

    if(fileUploadfile == null){
      print('Upload Falhado');
      return null;
    }
    return fileUploadfile;
  }

  ///
  Future<Map> getAppKey(String user, String pass) async {
    var url = '$host/authenticateWidget.do?dispatch=executeService&serviceJson=generateChaveApps';
    var body = {
      "username": user,
      "password": pass
    };

    Map map = await rest.postAppKey(url, body);

    return map.isNotEmpty ? map : {"": ""};
  }

  /// Create a [url] with given [id] and [bacosession] to send a get request to the api
  /// and returns a Map with the folder added to favorites as [response].
  @deprecated
  Future<Null> launchFilesInBrowser(String bacoSess, String id) async {

    var url = '$host/repositoryStream/$id?BACOSESS=$bacoSess';
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false,);
    } else {
      throw 'Could not launch $url';
    }
  }

  ///
  launchGenetareKeyInBrowser() async{
    //  CODIGO PARA FAZER LAUNCH DO BROWSER EM VEZ DE MOSTRAR O DIALOG DE LOGIN DO PAE
    if (await canLaunch('$host/startGenerateChaveApps.do')) {
      await launch('$host/startGenerateChaveApps.do', forceSafariVC: false, forceWebView: false);
    } else {
      throw 'Could not launch $host/startGenerateChaveApps.do';
    }
  }

  ///
  Future<Map> getYears(String bacoSess) async {

    var url = '$host/wsjson/api/user/ws-configs-get-import-year?BACOSESS=$bacoSess';

    return rest.get(url).then((response) => response);
  }

  ///
  Future<File> getFiles(String bacoSess, Map file) async {

    var url = '$host/repositoryStream/${file['repositoryId']}?BACOSESS=$bacoSess';

    return _downloadFile(url, file['title'], file['path']);
    //return rest.get(url).then((response) => response );
  }

  ///
  Future<File> _downloadFile(String url, String filename, String path) async {

    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);

    String dir = await buildFileDirectory(path);

    File file = await new File('$dir/$filename').create(recursive: true);
    await file.writeAsBytes(bytes);

    print(file.path);
    return file;

  }

  Future<String> buildFileDirectory(String path) async {
    var lastIndex = path.lastIndexOf("/");
    String dir = (await getExternalStorageDirectory()).path + path.substring(0,lastIndex);
    return dir;
  }

}