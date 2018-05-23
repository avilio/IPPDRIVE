import 'package:flutter/material.dart';

import 'package:ippdrive/Pages/Themes/colorsThemes.dart';
import 'package:ippdrive/Services/validation.dart';

const _padding = EdgeInsets.all(25.0);


class MyLoginPage extends StatefulWidget {

  State createState() => new MyLoginPageState();
}

class MyLoginPageState extends State<MyLoginPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _userController = new TextEditingController();
  final _passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final button = Padding(
      padding: _padding,
      child: new Container(
        //margin: new EdgeInsets.symmetric(horizontal: 20.0),
        child: new RaisedButton(
          // onPressed: () {Navigator.of(context).pushNamed("/listView");},
          onPressed: () {
            submit(_userController.text, _passwordController.text, _formKey,
                context, _scaffoldKey);
          },
          child: new Text('Login'),
          elevation: 2.0,
          shape: BeveledRectangleBorder(
              borderRadius: new BorderRadius.circular(5.0)),
        ),
      ),
    );

    final loginBox = new Center(
     // heightFactor: 1.3,
      child: new DecoratedBox(
        decoration: new BoxDecoration(
            border: new Border.all(style: BorderStyle.solid, color: cAppBlackish),
            color: cAppYellowishAccent,
            borderRadius: new BorderRadius.circular(10.0)),
        child: Container(
          //color: cAppYellowishAccent,
          padding: _padding,
          child: Column(
            children: <Widget>[
              new Image.asset("assets/images/icon.png",
                  width: 150.0, height: 150.0),
              new TextFormField(
                decoration: new InputDecoration(
                  labelText: "Number of Student",
                  hintText: "Your student number",
                ),
                controller: _userController,
                validator: userValidation,
              ),
              new Padding(padding: new EdgeInsets.all(1.5)),
              new TextFormField(
                  obscureText: true,
                  decoration: new InputDecoration(
                    labelText: "Password",
                    hintText: "Mobile Key",
                  ),
                  controller: _passwordController,
                  keyboardType: TextInputType.number,
                  validator: passwordValidation),
              button,
              new Padding(padding: new EdgeInsets.all(1.5)),

            ],
          ),
        ),
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: cAppWhite,
      body: new Form(
          key: _formKey,
          child: new Padding(
            padding: _padding,
            child: new ListView(
              children: <Widget>[
                loginBox,
               // button
                new Padding(padding: new EdgeInsets.all(90.5)),
                new Text('Powered by Aluno', textAlign: TextAlign.center),
              ],
            ),
          )),
    );
  }
}
