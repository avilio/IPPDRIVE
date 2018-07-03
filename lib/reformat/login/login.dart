import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ippdrive/views/themes/colorsThemes.dart';
import '../blocs/login_bloc.dart';
import '../blocs/login_provider.dart';

class LoginPageBloc extends StatelessWidget {
  final _padding = EdgeInsets.all(25.0);
  final _userController = new TextEditingController();
  final _passwordController = new TextEditingController();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    final bloc = LoginProvider.of(context);
    final deviceHeight = MediaQuery.of(context).size.height;
    final targetHeight = deviceHeight > 1080 ? 1080 : deviceHeight * 0.90;

    /// Apenas para evitar enviar por parametro
    bloc.setKey(_formKey);

    return WillPopScope(
      onWillPop: () async {
        showDialog(context: context,child: AlertDialog(
          title: Text('IppDrive'),
          content: Text('Tem a certeza que quer sair?'),
          actions: <Widget>[
            FlatButton(onPressed: ()=> exit(0), child: Text('Sim'),color: cAppYellowish,),
            FlatButton(onPressed: ()=> Navigator.pop(context), child: Text('Nao'),color: cAppYellowish,)
          ],
        ));
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: _padding,
                child: Column(
                  children: <Widget>[
                    _myLoginFields(bloc),
                    new Padding(
                        padding: new EdgeInsets.all(deviceHeight - targetHeight)),
                    _buttonKey(bloc),
                    new Padding(padding: new EdgeInsets.all(15.0)),
                    _bottomText()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
///
  Widget _myLoginFields(LoginBloc bloc) {
    return new Center(
      child: Container(
        padding: _padding,
        child: Column(
          children: <Widget>[
            new Image.asset("assets/images/icon.png",
                width: 150.0, height: 150.0),
            _usernameField(bloc),
            new Padding(padding: new EdgeInsets.all(1.5)),
            _passwordField(bloc),
            _submitButton(bloc),
            new Padding(padding: new EdgeInsets.all(1.5)),
          ],
        ),
        //  ),
      ),
    );
  }

  Widget _usernameField(LoginBloc bloc) {
    final _regUser = new RegExp("[a-zA-Z0-9]{1,256}");

    return TextFormField(
      controller: _userController,
      maxLines: 1,
      decoration: new InputDecoration(
        labelText: "Username",
        suffixText: new TextSpan(text: '@ipportalegre.pt').text,
        hintText: "O seu username ",
      ),
      validator: (user)=> RegExp("[a-zA-Z0-9]{1,256}").hasMatch(user) ? null : 'User is not valid',
      inputFormatters: [WhitelistingTextInputFormatter(_regUser)],
    );
  }

  Widget _passwordField(LoginBloc bloc) {

    return TextFormField(
      obscureText: true,
      maxLines: 1,
      decoration: new InputDecoration(
        labelText: "Chave de Apps Moveis",
        hintText: "A sua chave de apps moveis",
      ),
      inputFormatters: [
        WhitelistingTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(5),
        BlacklistingTextInputFormatter.singleLineFormatter
      ],
      keyboardType: TextInputType.number,
      validator: (pass) => pass.length < 5 ? 'Password too short' : null,
    );
  }

  Widget _submitButton(LoginBloc bloc) {
    return new Padding(
      padding: _padding,
      child: new Container(
        child: new RaisedButton(
          onPressed:  ()=> bloc.submit(_userController.text.trim(), _passwordController.text.trim()),
          child: new Text('Login'),
          elevation: 2.0,
          shape: BeveledRectangleBorder(
              borderRadius: new BorderRadius.circular(5.0)),
        ),
      ),
    );
  }

  Widget _bottomText() {
    return Align(
      child: new Text(
        'Desenvolvido por IPP-ESTG_EI',
        textAlign: TextAlign.center,
      ),
      alignment: FractionalOffset.bottomCenter,
    );
  }

  _buttonKey(LoginBloc bloc) {
    return   new FloatingActionButton(
      onPressed: ()  {
        bloc.launchGenetareKeyInBrowser();
      },
      child: Icon(Icons.vpn_key),
      mini: true,
      tooltip: 'Chave Apps Moveis',
      backgroundColor: cAppYellowish,
      foregroundColor: cAppBlackish,
    );
  }
}
