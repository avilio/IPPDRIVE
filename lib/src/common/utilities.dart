import 'package:flutter/material.dart';

class Utilities {

  ///Usar para TextFormField
  String userValidation(String user) =>
      RegExp("[a-zA-Z0-9]{1,256}").hasMatch(user) ? null : 'Utilizador nao valido';

  String passwordValidation(String password) =>
      password.length < 5 ? 'Password muito curta' : null;

  /// Verifica se a String é número
  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  /// Recebe uma string com campos numericos, formata e retorna uma nova string sem campos numericos
  String stringSplitter( String string, [var splitter]) {
    if (string != null) {
      List splitList = string.split(splitter);
      String resultString = '';

      splitList.forEach((item){
        if(!isNumeric(item))
          resultString+=item + ' ';
      });
      return resultString;
    }else
      return "Funcionario/a";
  }

  ///
  String pathBuilder(Map parent,List listPath) {

    if (parent != null) {

      if ( parent['pathParent'].split('/').length > 7) {
        List fields =  parent['pathParent'].split('/');
        String path = '';
        for (var j = 7; j < fields.length; j++) {
          path += stringSplitter(fields[j], '.') + ' / ';
        }
        listPath.add(parent);
        return path;
      }else{
        List fields =  parent['pathParent'].split('/');
        String path = '';
        for (var j = 0; j < fields.length; j++) {
          path += stringSplitter(fields[j], '.') + ' / ';
        }
        listPath.add(parent);
        return path;
      }
    }
    return "";
  }

  ///
  String subtitleSplitter(String sub) {

    int size =sub.split('/').length;
    sub = sub.split('/')[size-2];

    if(sub.contains('.')) {
      List list = sub.split('.');
      sub = '';
      list.forEach((string) {
        if (double.parse(string, (e) => null) == null) sub += string + ' ';
      });
    }
    return sub;
  }

  ///
  Widget imageSchoolLeading(String title){
    switch (title.toLowerCase()) {
      case 'estg':
        return Image(image: AssetImage("assets/images/estg.png"),width: 40.0);
        break;
      case 'esecs':
        return Image(image:  AssetImage("assets/images/esecs.png"),width: 40.0);
        break;
      case 'ess':
        return Image(image:  AssetImage("assets/images/ess.png"),width: 40.0);
        break;
      case 'esae':
        return Image(image:  AssetImage("assets/images/esae.png"),width: 40.0);
        break;
    }
    return Icon(Icons.layers);
  }

  ///
  ImageProvider imageSchoolHeader(String school){
    var imgSchool;
    switch (school.toLowerCase()) {
      case 'estg':
        imgSchool = AssetImage("assets/images/estg.png");
        break;
      case 'esecs':
        imgSchool = AssetImage("assets/images/esecs.png");
        break;
      case 'ess':
        imgSchool = AssetImage("assets/images/ess.png");
        break;
      case 'esae':
        imgSchool = AssetImage("assets/images/esae.png");
        break;
      default:
        imgSchool = AssetImage("assets/images/ipp.png");
        break;
    }
    return imgSchool;
  }
}
