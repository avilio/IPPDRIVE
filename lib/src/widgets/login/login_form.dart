import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../blocs/bloc.dart';
import '../../blocs/bloc_provider.dart';

class LoginForm extends StatefulWidget {
  @override
  LoginFormState createState() {
    return new LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  final _padding = EdgeInsets.all(25.0);
  final _userController = new TextEditingController();
  final _passwordController = new TextEditingController();
  final _regUser = new RegExp("[a-zA-Z0-9]{1,256}");
  bool _flagLog = false;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of(context);

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
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text('Memorizar o login'),
                Checkbox(
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  value: _flagLog,
                  onChanged: (bool b) {
                    isMemoUserLogin(b, _userController.text);
                    setState(() {
                      _flagLog = b;
                    });
                  },
                  activeColor: Theme.of(context).buttonColor,
                ),
              ],
            ),
            _submitButton(bloc, context),
            new Padding(padding: new EdgeInsets.all(1.5)),
          ],
        ),
        //  ),
      ),
    );
  }

  ///
  Future isMemoUserLogin(bool memo, String username) async {
    //todo mudar o memouser para o numero de aluno para poder memorizar o login a cada utilizador em vez de geral
    //todo se meter o user name - para um valor bool permite guardar varios logins memorize
    memo ?? false;
    SharedPreferences prefs = await _prefs;
    prefs.setBool(username, memo);
    print(prefs.getBool(username));
  }

  ///
  Widget _usernameField(Bloc bloc) {
    return TextFormField(
      controller: _userController,
      maxLines: 1,
      decoration: new InputDecoration(
        labelText: "Username",
        suffixText: new TextSpan(text: '@ipportalegre.pt').text,
        hintText: "O seu username ",
      ),
      validator: bloc.userValidation,
      inputFormatters: [WhitelistingTextInputFormatter(_regUser)],
    );
  }

  ///
  Widget _passwordField(Bloc bloc) {
    return TextFormField(
      controller: _passwordController,
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
      validator: bloc.passwordValidation,
    );
  }

  ///
  Widget _submitButton(Bloc bloc, BuildContext context) {
    return new Container(
      padding: _padding,
      child: new RaisedButton(
        onPressed: () {
          //!bloc.connectionStatus.contains('none')?
          bloc.submit(_userController.text.trim(),
                  _passwordController.text, context);
             // : bloc.errorDialog('Sem acesso a Internet', context);
        },
        child: new Text('Login'),
        elevation: 2.0,
        shape: BeveledRectangleBorder(
            borderRadius: new BorderRadius.circular(5.0)),
      ),
    );
  }
}
