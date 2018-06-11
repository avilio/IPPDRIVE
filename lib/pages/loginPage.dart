import 'package:flutter/material.dart';


import 'package:ippdrive/pages/layouts/components/loginPageComponents.dart';
import 'package:ippdrive/pages/themes/colorsThemes.dart';


const _padding = EdgeInsets.all(25.0);

class LoginPage extends StatefulWidget {

  State createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _userController = new TextEditingController();
  final _passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: cAppWhite,
        body: new Form(
            key: _formKey,
            child: new Padding(
              padding: _padding,
              child: new ListView(
                children: <Widget>[
                  myLoginBox(context,_userController,_passwordController,_formKey,_scaffoldKey,_padding),
                 // button,
                  new Padding(padding: new EdgeInsets.all(90.5)),
                  new Text('Powered by Aluno', textAlign: TextAlign.center),
                ],
              ),
            )),
      ),
    );
  }
}

