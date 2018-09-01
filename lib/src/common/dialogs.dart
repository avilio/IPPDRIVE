import 'dart:io';

import 'package:flutter/material.dart';

import './themes/colorsThemes.dart';

class ExceptionDialog {

  /// Dialog de saida da app
  void quitDialog(BuildContext context) {
    showDialog(
        context: context,
        child: AlertDialog(
          title: Text(
            'IppDrive',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Tem a certeza que quer sair?',
            textAlign: TextAlign.justify,
          ),
          actions: <Widget>[
            FlatButton(
                onPressed: () => exit(0),//todo mudar isto do exit para algo "melhor"
                child: Text('Sim'),
                color: cAppYellowish,
                shape: BeveledRectangleBorder(
                    borderRadius: new BorderRadius.circular(3.0))),
            FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Nao'),
                color: cAppYellowish,
                shape: BeveledRectangleBorder(
                    borderRadius: new BorderRadius.circular(3.0)))
          ],
        ));
  }

  /// Dialog de erros
  void errorDialog(String message, BuildContext context) =>
      showDialog(context: context, builder:(context)=> _buildErrorDialog(message, context));

  /// Dialog Box Builder
  AlertDialog _buildErrorDialog(String message, BuildContext context) =>
      AlertDialog(
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


}
