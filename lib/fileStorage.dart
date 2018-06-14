
import 'dart:async' show Future;
import 'dart:io' show Directory, File, HttpClient;

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

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

 Future<File> downloadFile(String url, String filename) async {

   var request = await httpClient.getUrl(Uri.parse(url));
   var response = await request.close();
   var bytes = await consolidateHttpClientResponseBytes(response);
   String dir = (await getApplicationDocumentsDirectory()).path;
   File file = new File('$dir/$filename');
   await file.writeAsBytes(bytes);
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