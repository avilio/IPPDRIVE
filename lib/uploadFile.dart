

import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class UploadFile{


  String url;

  UploadFile(this.url);

  sendFile(){

   var response = new http.MultipartRequest("POST",Uri.parse(url+ "/filesUpload"));
   //response.files.add(value);
    //todo fazer o multipart


  }


}