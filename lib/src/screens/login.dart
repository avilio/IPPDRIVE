import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../blocs/bloc.dart';
import '../blocs/bloc_provider.dart';
import '../common/themes/colorsThemes.dart';
import '../widgets/login/login_form.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() {
    return new LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> with Connectivity {
  final _padding = EdgeInsets.all(25.0);
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero,(){
      final bloc = BlocProvider.of(context);
      bloc.onConnectionChange();
     /* onConnectivityChanged.listen((ConnectivityResult result){
        loginBloc.setConnectionStatus(result.toString());
      });*/
    });


  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of(context);

    final deviceHeight = MediaQuery.of(context).size.height;
    final targetHeight = deviceHeight > 1080 ? 1080 : deviceHeight * 0.95;
    final paddingDevice = deviceHeight - targetHeight;
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

    /// Apenas para evitar enviar por parametro
    bloc.setKey(_formKey);
    bloc.initConnection();


    bloc.onConnectionChange();
      
    return WillPopScope(
      onWillPop: () async {
        bloc.quitDialog(context);
      },
      child: Scaffold(body: _buildBody(bloc, paddingDevice, context)),
    );
  }



  ///
  Widget _buildBody(Bloc bloc, double padding, BuildContext context) {
    bloc.onConnectionChange();
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
  _buttonKey(Bloc bloc) {

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
