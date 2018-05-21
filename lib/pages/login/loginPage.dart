import 'package:flutter/material.dart';
import 'package:ippdrive/Pages/Themes/colorsThemes.dart';

import 'package:ippdrive/validation.dart';
/*
class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final _userController = new TextEditingController();
  final _passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: cAppWhite,
      body: new Form(
        key: _formKey,
          child: new Column(
            children: <Widget>[
              new Padding(padding: new EdgeInsets.all(20.0)),
              new Container(
                alignment: Alignment.bottomCenter,
                padding: new EdgeInsets.all(20.0),
                decoration: new BoxDecoration(
                    border: new Border.all(color: cAppBlackish),
                  color:cAppYellowishAccent,
                  borderRadius: new BorderRadius.circular(20.0)
                ),
                margin: new EdgeInsets.symmetric(horizontal: 35.0),
                //margin: new EdgeInsets.only(top: 20.0),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Padding(padding: new EdgeInsets.all(50.0)),
                    new Image.asset(
                      "assets/images/icon.png",
                      width: 150.0,
                      height: 150.0,
                      fit: BoxFit.contain,
                    ),
                    new TextFormField(
                      decoration: new InputDecoration(
                        labelText: "Number of Student",
                        hintText: "your student number",
                      ),
                      controller: _userController,
                      validator: userValidation,
                      maxLines: 1,
                    ),
                    new Padding(padding: new EdgeInsets.all(5.0)),
                    new TextFormField(
                      obscureText: true,
                      decoration: new InputDecoration(
                        labelText: "Password",
                        hintText: "Mobile Key",
                      ),
                      controller: _passwordController,
                      keyboardType: TextInputType.number,
                      validator: passwordValidation,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              new Padding(padding: new EdgeInsets.all(5.0)),
              new RaisedButton(
                // onPressed: () {Navigator.of(context).pushNamed("/listView");},
                onPressed: () {
                  //validation(_userController.text,_passwordController.text, context);
                  submit(_userController.text, _passwordController.text,
                      _formKey, context);
                },
                child: new Text('Login'),
               // elevation: 8.0,
                shape: BeveledRectangleBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
              ),
            ],
          ),
        ),
    );
  }
}
*/