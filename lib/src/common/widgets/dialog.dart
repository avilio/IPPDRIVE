import 'package:flutter/material.dart';
import '../themes/colorsThemes.dart';

class DialogAlert extends StatefulWidget {
  final String message;

  DialogAlert({this.message});

  @override
  _DialogAlertState createState() => _DialogAlertState();
}

class _DialogAlertState extends State<DialogAlert> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text(
          'ALERT!',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          widget.message, textAlign: TextAlign.justify,
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
}
