import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Material(
      color: Colors.lightBlueAccent[100],
        child: new Padding(
          padding: new EdgeInsets.only(top: 70.0,left: 60.0, right: 60.0),
                  child: new Column(
      //mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
          new Image.asset(
            "images/icon.png",
            width: 150.0,
            height: 150.0,
          ),
          new TextField(
           style: new TextStyle(color: Colors.yellowAccent[100] , fontSize: 20.0),
            decoration: new InputDecoration(
                labelText: "Number of Student", hintText: "your student number", 
                labelStyle:new TextStyle(color: Colors.blueGrey[700])),
          ),
          new TextField(
            obscureText: true,
           style: new TextStyle(color: Colors.yellowAccent[100], fontSize: 20.0),
            decoration: new InputDecoration(
              labelText: "Password",
              labelStyle:new TextStyle(color:Colors.blueGrey[700] ),
              hintText: "your password",
            ),
          )
      ],
    ),
        ));
  }
}

