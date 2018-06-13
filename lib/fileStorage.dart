
import 'dart:async' show Future;
import 'dart:io' show Directory, File;

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