import 'package:flutter/material.dart';
import 'package:ippdrive/Services/validation.dart';

Widget myLoginBox(context,_userController,_passwordController,_formKey,_scaffoldKey,_padding ){

  return new Center(
    // heightFactor: 1.3,
    /*child: new DecoratedBox(
      decoration: new BoxDecoration(
          border: new Border.all(style: BorderStyle.solid, color: cAppBlackish),
          color: cAppYellowishAccent,
          borderRadius: new BorderRadius.circular(10.0)),*/
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
          button(_userController,_passwordController, _formKey, context, _scaffoldKey, _padding),
          new Padding(padding: new EdgeInsets.all(1.5)),

        ],
      ),
      //  ),
    ),
  );
}

Widget button (_userController,_passwordController, _formKey, context, _scaffoldKey, _padding) {

  return new Padding(
    padding: _padding,
    child: new Container(
      //margin: new EdgeInsets.symmetric(horizontal: 20.0),
      child: new RaisedButton(
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
}