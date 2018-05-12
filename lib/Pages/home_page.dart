import 'package:flutter/material.dart';
import 'package:ippdrive/RequestsAPI/requestsHandler.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Material(
        child: new Padding(
      padding: new EdgeInsets.only(top: 70.0, left: 60.0, right: 60.0),
      child: new Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Image.asset(
            "assets/images/icon.png",
            width: 150.0,
            height: 150.0,
          ),
          new TextField(
            style: new TextStyle(fontFamily: 'Exo2', color: Colors.black),
            decoration: new InputDecoration(
              labelText: "Number of Student",
              hintText: "your student number",
              labelStyle: new TextStyle(fontFamily: 'Exo2', color: Colors.blueGrey[700]),
              border: OutlineInputBorder(),
            ),
          ),
          new Padding(padding: const EdgeInsets.only(top: 10.0)),
          new TextField(
            obscureText: true,
            style: new TextStyle(fontFamily: 'Exo2', color: Colors.black),
            decoration: new InputDecoration(
              labelText: "Password",
              labelStyle: new TextStyle(fontFamily: 'Exo2',color: Colors.blueGrey[700]),
              hintText: "Mobile Key",
              border: OutlineInputBorder()
            ),
          ),
          new Padding(padding: const EdgeInsets.only(top: 40.0)),
          new RaisedButton(
           // onPressed: () {Navigator.of(context).pushNamed("/listView");},
            onPressed: Handler,
            child: new Text('Login',textScaleFactor: 1.2, maxLines: 1,
              style: new TextStyle(fontFamily: 'Exo2')),
            color: Colors.yellow,
            highlightColor: Colors.amber,
            elevation: 8.0,
            padding: new EdgeInsets.symmetric(horizontal: 80.0, vertical: 5.0),
            shape: BeveledRectangleBorder(
                borderRadius:new BorderRadius.circular(10.0)),
          )
        ],
      ),
    ));
  }

}
