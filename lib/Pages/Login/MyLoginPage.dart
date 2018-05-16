import 'package:flutter/material.dart';
import 'package:ippdrive/Pages/Themes/ColorsThemes.dart';

import 'package:ippdrive/Pages/Validation.dart';

class MyLoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new MyLoginPageState();
}

class MyLoginPageState extends State<MyLoginPage>{
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final _userController = new TextEditingController();
  final _passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: cAppWhite,
      body: new Form(
          key: _formKey,
          child: new ListView(
            children: <Widget>[
              new Column(
                children: <Widget>[
                  new Image.asset(
                    "assets/images/icon.png",
                    width: 150.0,
                    height: 150.0,
                  ),
                  new Padding(padding: new EdgeInsets.all(50.0)),
                ],
              ),
              new TextFormField(
                decoration: new InputDecoration(
                  labelText: "Number of Student",
                  hintText: "your student number",
                ),
                controller: _userController,
                validator: userValidation,
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
                  validator: passwordValidation
              ),
              new Container(
                margin: new EdgeInsets.symmetric(horizontal: 20.0),
                child:  new RaisedButton(
                  // onPressed: () {Navigator.of(context).pushNamed("/listView");},
                  onPressed: (){
                    //validation(_userController.text,_passwordController.text, context);
                    submit(_userController.text, _passwordController.text, _formKey, context);
                  },
                  child: new Text('Login'),
                  elevation: 8.0,
                  shape: BeveledRectangleBorder(
                      borderRadius:new BorderRadius.circular(5.0)),
                ),
              )
            ],
          )
      ),
    );
  }
}