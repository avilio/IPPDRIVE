import 'dart:async';


import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import '../common/themes/colorsThemes.dart';
import '../blocs/login_bloc.dart';
import '../blocs/login_provider.dart';
import '../widgets/login/login_form.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() {
    return new LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> with Connectivity{
  final _padding = EdgeInsets.all(25.0);
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    final loginBloc = LoginProvider.of(context);

    final deviceHeight = MediaQuery.of(context).size.height;
    final targetHeight = deviceHeight > 1080 ? 1080 : deviceHeight * 0.90;
    final paddingDevice = deviceHeight - targetHeight;

    /// Apenas para evitar enviar por parametro
    loginBloc.setKey(_formKey);
    loginBloc.initConnection();
    loginBloc.onConnectionChange();

    return WillPopScope(
      onWillPop: () async {loginBloc.quitDialog(context);},
      child: Scaffold(body: _buildBody(loginBloc, paddingDevice, context)),
    );
  }

  ///
  Widget _buildBody(LoginBloc bloc, double padding, BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: _padding,
            child: Column(
              children: <Widget>[
                LoginForm(),
                Padding(padding: new EdgeInsets.all(padding)),
                _textKey(),
                _buttonKey(bloc),
                Padding(padding: new EdgeInsets.all(15.0)),
                _bottomText()
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  _buttonKey(LoginBloc bloc) {
    return new FloatingActionButton(
      onPressed: () {
        !bloc.connectionStatus.contains('none')
            ? bloc.launchGenetareKeyInBrowser()
            : bloc.errorDialog('Sem acesso a Internet', context);
      },
      child: Icon(Icons.vpn_key),
      mini: true,
      tooltip: 'Chave Apps Moveis',
      backgroundColor: cAppYellowish,
      foregroundColor: cAppBlackish,
    );
  }

  ///
  Widget _bottomText() {
    return Align(
      child: new Text(
        'Desenvolvido por IPP-ESTG_EI',
        textAlign: TextAlign.center,
      ),
      alignment: FractionalOffset.bottomCenter,
    );
  }

  ///
  Widget _textKey() {
    return RichText(
        text: new TextSpan(
            text: 'Nao tem chave app moveis?\n Clique no botao com a Chave',
            style: Theme.of(context).textTheme.caption),
        textAlign: TextAlign.center);
  }
}
