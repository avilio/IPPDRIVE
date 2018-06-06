
import 'package:flutter/material.dart';
import 'package:ippdrive/pages/themes/colorsThemes.dart';

/**
 * Dialog Box Builder
 */
AlertDialog buildDialog(message, context) {
  var dialog = AlertDialog(
    title: Text(
      'ERROR',
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
    content: Text(
      message, textAlign: TextAlign.justify,
      //    style: TextStyle(color: Colors.redAccent)
    ),
    actions: <Widget>[
      FlatButton(
        onPressed: () => Navigator.pop(context),
        child: Text('OK'),
        color: cAppYellowish,
        shape: BeveledRectangleBorder(
            borderRadius: new BorderRadius.circular(3.0)),
      )
    ],
  );

  return dialog;
}

/**
 * Check if a string is numeric
 */
bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.parse(s, (e) => null) != null;
}

/**
 * Splits a long string and return a new one without the fields with numbers
 */
String stringSplitter( String s, [var splitter]) {

  List splitList = s.split(splitter);

  String resultString = '';

  splitList.forEach((item){
    if(!isNumeric(item))
      resultString+=item + ' ';
  });

  return resultString;
}