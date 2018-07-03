import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ippdrive/keydialog.dart';
import 'package:ippdrive/security/verifications/display.dart';
import 'package:ippdrive/security/verifications/validation.dart';

import 'package:ippdrive/views/themes/colorsThemes.dart';
import 'package:ippdrive/services/apiRequests.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';

const _padding = EdgeInsets.all(25.0);
RegExp _regUser = new RegExp("[a-zA-Z0-9]{1,256}");
Validations validations = Validations();

class LoginPage extends StatefulWidget {
  State createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  final _userController = new TextEditingController();
  final _passwordController = new TextEditingController();


  final Connectivity _connectivity = new Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  var req = Requests();
  String _connectionStatus = 'Unknown';
  Future<Null> initConnectivity() async {
    String connectionStatus;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      connectionStatus = (await _connectivity.checkConnectivity()).toString();
    } on PlatformException catch (e) {
      print(e.toString());
      connectionStatus = 'Failed to get connectivity.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

    setState(() {
      _connectionStatus = connectionStatus;
    });
  }

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() => _connectionStatus = result.toString());
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final targetHeight = deviceHeight > 1080 ? 1080 : deviceHeight * 0.95;
    ///
    print(_connectionStatus);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: cAppWhite,
        body: SingleChildScrollView(
          child: Container(
            child: new Form(
                key: _formKey,
                child: new Padding(
                  padding: _padding,
                  child: new Column(
                    children: <Widget>[
                      myLoginBox(),
                      // button,
                      new Padding(padding: new EdgeInsets.all((deviceHeight-targetHeight)/2)),
                      new RichText(
                        text: new TextSpan(
                            text:
                                'Nao tem chave app moveis? Clique no botao com a Chave',
                            style: Theme.of(context).textTheme.caption),
                        textAlign: TextAlign.center,
                      ),
                      new FloatingActionButton(
                        onPressed: () async {
                          var url = 'http://10.0.2.2:8080/baco';
                          //var url = 'https://pae.ipportalegre.pt';

                         //  CODIGO PARA FAZER LAUNCH DO BROWSER EM VEZ DE MOSTRAR O DIALOG DE LOGIN DO PAE
                             if (await canLaunch('$url/startGenerateChaveApps.do')) {
                             await launch('$url/startGenerateChaveApps.do', forceSafariVC: false, forceWebView: false);
                             } else {
                             throw 'Could not launch $url/startGenerateChaveApps.do';
                             }
                        /*  print(_connectionStatus);
                          if (!_connectionStatus.contains('none')) {
                            showDialog(context: context, child: DialogKey());
                          } else
                            showDialog(
                                context: context,
                                child:
                                    buildDialog('Sem acesso a internet', context));*/
                        },
                        child: Icon(Icons.vpn_key),
                        mini: true,
                        tooltip: 'Chave Apps Moveis',
                        backgroundColor: cAppYellowish,
                        foregroundColor: cAppBlackish,
                      ),
                      new Padding(padding: new EdgeInsets.all(15.0)),
                      Align(
                        child: new Text(
                          'Desenvolvido por IPP-ESTG_EI',
                          textAlign: TextAlign.center,
                        ),
                        alignment: FractionalOffset.bottomCenter,
                      ),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }

  Widget myLoginBox() {
    return new Center(
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
                hintText: "O seu username ",
              ),
              controller: _userController,
              inputFormatters: [WhitelistingTextInputFormatter(_regUser)],
              validator: validations.userValidation,
            ),
            new Padding(padding: new EdgeInsets.all(1.5)),
            new TextFormField(
                obscureText: true,
                decoration: new InputDecoration(
                  labelText: "Chave de Apps Moveis",
                  hintText: "A sua chave de apps moveis",
                ),
                inputFormatters: [
                  WhitelistingTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(5),
                  BlacklistingTextInputFormatter.singleLineFormatter
                ],
                controller: _passwordController,
                keyboardType: TextInputType.number,
                validator: validations.passwordValidation),
            submitButton(),
            new Padding(padding: new EdgeInsets.all(1.5)),
          ],
        ),
        //  ),
      ),
    );
  }

  Widget submitButton() {
    return new Padding(
      padding: _padding,
      child: new Container(
        //margin: new EdgeInsets.symmetric(horizontal: 20.0),
        child: new RaisedButton(
          onPressed: () {
            if (!_connectionStatus.contains('none')) {
              validations.submit(_userController.text..trim(), _passwordController.text.trim(),
                  _formKey, context, _scaffoldKey);
            } else
              showDialog(
                  context: context,
                  child: buildDialog('Sem acesso a internet', context));
          },
          child: new Text('Login'),
          elevation: 2.0,
          shape: BeveledRectangleBorder(
              borderRadius: new BorderRadius.circular(5.0)),
        ),
      ),
    );
  }
}
