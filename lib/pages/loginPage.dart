import 'package:flutter/material.dart';
import 'package:ippdrive/keydialog.dart';


import 'package:ippdrive/pages/layouts/components/loginPageComponents.dart';
import 'package:ippdrive/pages/themes/colorsThemes.dart';
import 'package:ippdrive/services/requestsAPI/apiRequests.dart';
import 'package:url_launcher/url_launcher.dart';


const _padding = EdgeInsets.all(25.0);

class LoginPage extends StatefulWidget {

  State createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _userController = new TextEditingController();
  final _passwordController = new TextEditingController();
  var req = Requests();

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
                  new Padding(padding: new EdgeInsets.all(35.0)),
                  new RichText(text: new TextSpan(text: 'Do not have Mobile Key? Click on the Key',
                  style: Theme.of(context).textTheme.caption),
                  textAlign: TextAlign.center,),
                  new FloatingActionButton(
                    onPressed: () {
                    /*  if (await canLaunch('https://pae.ipportalegre.pt/startGenerateChaveApps.do')) {
                      await launch('https://pae.ipportalegre.pt/startGenerateChaveApps.do', forceSafariVC: false, forceWebView: false);
                      } else {
                      throw 'Could not launch https://pae.ipportalegre.pt/startGenerateChaveApps.do';
                      }*/
                      showDialog(context: context,
                      child: DialogKey());
                    },
                    child: Icon(Icons.vpn_key),
                    mini: true,
                    tooltip: 'Chave Apps Moveis',
                    backgroundColor: cAppYellowish,
                    foregroundColor: cAppBlackish,
                    ),
              new Padding(padding: new EdgeInsets.all(15.0)),
                  Align(
                    child: new Text('Powered by IPP-ESTG_EI', textAlign: TextAlign.center,
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

