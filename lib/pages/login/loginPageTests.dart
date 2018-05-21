import 'package:flutter/material.dart';
import 'package:ippdrive/Pages/Themes/colorsThemes.dart';
import 'package:ippdrive/Services/requestsAPI/requestsPhases.dart';


class LoginPageTests extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new LoginPageTestsState();
}

class LoginPageTestsState extends State<LoginPageTests> {

  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final _userController = new TextEditingController();
  final _passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ListView(
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      children: <Widget>[
        SizedBox(height: 80.0),
        new Image.asset(
          "assets/images/icon.png",
          width: 100.0,
          height: 100.0,
        ),
        SizedBox(height: 80.0),
        new TextFormField(
          controller: _userController,
          decoration: new InputDecoration(
            labelText: "Number of Student",
            hintText: "your student number",
          ),
        ),
        SizedBox(height: 12.0),
        new TextFormField(
            obscureText: true,
            style: new TextStyle(fontFamily: 'Exo2', color: Colors.black),
            controller: _passwordController,
            decoration: new InputDecoration(
                labelText: "Password",
                hintText: "Mobile Key",
            )
        ),
        SizedBox(height: 20.0),
        new RaisedButton(
            // onPressed: () {Navigator.of(context).pushNamed("/listView");},
            onPressed: () {
              requestPhases(_userController.text, _passwordController.text);
            },
            child: new Text('Login', maxLines: 1,),
            elevation: 8.0,
            shape: BeveledRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0)
            )
        ),
      ],
    )
    );
  }
}
