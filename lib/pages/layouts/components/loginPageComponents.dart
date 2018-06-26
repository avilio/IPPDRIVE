import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:ippdrive/security/verifications/validation.dart';

Validations validations = Validations();
RegExp _regUser = new RegExp("[a-zA-Z0-9]{1,256}");

Widget myLoginBox(context, _userController, _passwordController, _formKey,
    _scaffoldKey, _padding) {
  return new Center(
    // heightFactor: 1.3,
    /*child: new DecoratedBox(
      decoration: new BoxDecoration(
          border: new Border.all(style: BorderStyle.solid, color: cAppBlackish),
          color: cAppYellowishAccent,
          borderRadius: new BorderRadius.circular(10.0)),*/
    child: Container(
      padding: _padding,
      child: Column(
        children: <Widget>[
          new Image.asset("assets/images/icon.png",
              width: 150.0, height: 150.0),
          new TextFormField(
            maxLines: 1,
            decoration: new InputDecoration(
              labelText: "Username",
              suffixText: new TextSpan(text: '@ipportalegre.pt').text,
              hintText: "Your student number ",
            ),
            controller: _userController,
            inputFormatters: [WhitelistingTextInputFormatter(_regUser)],
            validator: validations.userValidation,
          ),
          new Padding(padding: new EdgeInsets.all(1.5)),
          new TextFormField(
              obscureText: true,
              decoration: new InputDecoration(
                labelText: "Mobile App Key",
                hintText: "Mobile Key",
              ),
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(5),
                BlacklistingTextInputFormatter.singleLineFormatter
              ],
              controller: _passwordController,
              keyboardType: TextInputType.number,
              validator: validations.passwordValidation),
          submitButton(_userController, _passwordController, _formKey, context,
              _scaffoldKey, _padding),
          new Padding(padding: new EdgeInsets.all(1.5)),
        ],
      ),
      //  ),
    ),
  );
}

Widget submitButton(_userController, _passwordController, _formKey, context,
    _scaffoldKey, _padding) {
  return new Padding(
    padding: _padding,
    child: new Container(
      //margin: new EdgeInsets.symmetric(horizontal: 20.0),
      child: new RaisedButton(
        onPressed: () {
          validations.submit(_userController.text, _passwordController.text,
              _formKey, context, _scaffoldKey);
        },
        child: new Text('Login'),
        elevation: 2.0,
        shape: BeveledRectangleBorder(
            borderRadius: new BorderRadius.circular(5.0)),
      ),
    ),
  );
}
