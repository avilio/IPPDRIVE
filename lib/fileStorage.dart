
import 'dart:async' show Future;
import 'dart:io' show Directory, File, FileSystemEntity, HttpClient;

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';


class FileStorage {
 /* Future<String> get _localPath async {
    final directory = await getExternalStorageDirectory();
    //getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async{
    final path = await _localPath;
    print('PATH -> $path');
    return new File('$path');
  }*/
  static var httpClient = new HttpClient();


  Future<Null> launchInBrowser(String url) async {

    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
  }

 Future<FileSystemEntity> downloadFile(String url, String filename) async {

   var request = await httpClient.getUrl(Uri.parse(url));
   var response = await request.close();
   var bytes = await consolidateHttpClientResponseBytes(response);
   String dir = (await getApplicationDocumentsDirectory()).path;
  // File file = new File('$dir/$filename');
  // await file.writeAsBytes(bytes);
   FileSystemEntity file = new File('$dir/$filename');

   return file;
 }


  void createFile(List<int> file) async{
    print('Create FILE');
    Directory dir = await getApplicationDocumentsDirectory();
    File newFile = new File(dir.resolveSymbolicLinksSync());
    newFile.createSync();
    newFile.writeAsBytesSync(file);



  }

  void writeFile(File file) async {
  print("WRITTING TO FILE");

    if(file.existsSync()){
      file.writeAsBytesSync(file.readAsBytesSync());
    }else
      createFile(file.readAsBytesSync());

    print('BYTES ---> ${file.readAsBytesSync()}');

  }

  //Future<List<int>> readFile() async {}
}