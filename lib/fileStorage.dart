
import 'dart:async' show Future;
import 'dart:io' show File;

import 'package:path_provider/path_provider.dart';

class FileStorage {
  Future<String> get _localPath async {
    final directory = await getExternalStorageDirectory();
    //getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async{
    final path = await _localPath;
    print('PATH -> $path');
    return new File('$path');
  }


  Future<File> writeFile(List<int> byte) async {

    final file = await _localFile;

    print('BYTES ---> $byte');

    return file.writeAsBytes(byte);
  }

  Future<List<int>> readFile() async {
    try {
      final file = await _localFile;

      // Read the file
      List<int> contents = await file.readAsBytes();

      return contents;
    } catch (e) {
      // If we encounter an error, return 0
      return [];
    }
  }
}