import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ippdrive/keydialog.dart';

import 'package:ippdrive/pages/layouts/components/loginPageComponents.dart';
import 'package:ippdrive/pages/themes/colorsThemes.dart';
import 'package:ippdrive/services/requestsAPI/apiRequests.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';

const _padding = EdgeInsets.all(25.0);

class LoginPage extends StatefulWidget {
  State createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
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
    print(_connectionStatus);
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
                  myLoginBox(context, _userController, _passwordController,
                      _formKey, _scaffoldKey, _padding),
                  // button,
                  new Padding(padding: new EdgeInsets.all(35.0)),
                  new RichText(
                    text: new TextSpan(
                        text: 'Do not have Mobile Key? Click on the Key',
                        style: Theme.of(context).textTheme.caption),
                    textAlign: TextAlign.center,
                  ),
                  new FloatingActionButton(
                    onPressed: () {
                      /*  if (await canLaunch('https://pae.ipportalegre.pt/startGenerateChaveApps.do')) {
                      await launch('https://pae.ipportalegre.pt/startGenerateChaveApps.do', forceSafariVC: false, forceWebView: false);
                      } else {
                      throw 'Could not launch https://pae.ipportalegre.pt/startGenerateChaveApps.do';
                      }*/
                      if (!_connectionStatus.contains('none')) {
                        showDialog(context: context, child: DialogKey());
                      }
                      showDialog(
                          context: context,
                          child: Form(
                            child: Column(
                              children: <Widget>[
                                SimpleDialog(
                                  title: Text('ERROR'),
                                  children: <Widget>[
                                    Text('No internet Connection'),
                                    RaisedButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: new Text('Ok'),
                                        shape: BeveledRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(5.0)))
                                  ],
                                ),
                              ],
                            ),
                          ));
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
                      'Powered by IPP-ESTG_EI',
                      textAlign: TextAlign.center,
                    ),
                    alignment: FractionalOffset.bottomCenter,
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
