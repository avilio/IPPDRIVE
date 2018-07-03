import 'package:flutter/material.dart';
import 'package:ippdrive/views/themes/colorsThemes.dart';

class ExceptionDialog {

  /// Error display
  void requestResponseValidation(String message,BuildContext context) =>
      showDialog(context: context, child: _buildDialog(message, context));


  /// Dialog Box Builder
  AlertDialog _buildDialog(String message, BuildContext context) {
    var dialog = AlertDialog(
      title: Text(
        'ALERT!',
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
}