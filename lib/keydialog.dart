import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ippdrive/pages/loginPage.dart';
import 'package:ippdrive/pages/themes/colorsThemes.dart';
import 'package:ippdrive/services/REST.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DialogKey extends StatelessWidget {
  final REST res = REST();
  final RegExp _regUser = new RegExp("[a-zA-Z0-9]{1,256}");
  final _userController = new TextEditingController();
  final _passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(
        'PAE Login',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        textAlign: TextAlign.center,
      ),
      contentPadding: EdgeInsets.all(30.0),
      children: <Widget>[
        Column(
          children: <Widget>[
            new TextFormField(
              maxLines: 1,
              decoration: new InputDecoration(
                labelText: "Number of Student/Teacher",
                suffixText: new TextSpan(text: '@ipportalegre.pt').text,
                hintText: "Your student number ",
              ),
              controller: _userController,
              inputFormatters: [WhitelistingTextInputFormatter(_regUser)],
            ),
            new Padding(padding: new EdgeInsets.all(1.5)),
            new TextFormField(
              obscureText: true,
              decoration: new InputDecoration(
                labelText: "Password",
                hintText: "Password",
              ),
              inputFormatters: [
                BlacklistingTextInputFormatter.singleLineFormatter
              ],
              controller: _passwordController,
            ),
            new Padding(padding: new EdgeInsets.all(5.0)),
            new RaisedButton(
              onPressed: () async {
                var map = {
                  "username": _userController.text,
                  "password": _passwordController.text
                };
                var url =
                    "https://pae.ipportalegre.pt/authenticateWidget.do?dispatch=executeService&serviceJson=generateChaveApps";
                var response = await res.postAppKey(url, map);
                print(response);
                if (response['service'] == 'ok') {
                  showDialog(
                      context: context,
                      child: AlertDialog(
                        title: Text('KEY',style:TextStyle(fontWeight:FontWeight.bold,fontSize: 22.0),),
                        content: _okService(response['messages'][0],
                            response['response']['chave'], context),
                      ));
                } else {
                  showDialog(
                      context: context,
                      child: AlertDialog(
                        title: Text('ERROR'),
                        content: _error(response['exception'], context),
                      ));
                }
                //todo fazer o ok button para a loginPage ou ok para pop caso de erro
                //todo ver como se mete um icon ou button para copiar para a area de transferencia
              },
              child: new Text('Login'),
              elevation: 2.0,
              shape: BeveledRectangleBorder(
                  borderRadius: new BorderRadius.circular(5.0)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _okService(String message, String key, context) {
    return Form(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(message),
          new GestureDetector(
              child: new Tooltip(
                  preferBelow: false, message: "Copy",
                  child: new Text(key,style: TextStyle(color: cAppBlue,fontWeight: FontWeight.bold,fontSize: 20.0),)),
              onTap: () {
                Clipboard.setData(new ClipboardData(text: key));
              }),
          new Padding(padding: EdgeInsets.all(5.0)),
          RaisedButton(
            onPressed: () {
              Clipboard.setData(new ClipboardData(text: key));
              Fluttertoast.showToast(msg: "Key copied to clipboard",toastLength: Toast.LENGTH_SHORT);

              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => new LoginPage()),
                  (Route<dynamic> route) => false);
            },
            child: new Text('Ok'),
            shape: BeveledRectangleBorder(
                borderRadius: new BorderRadius.circular(5.0)),
          )
        ],
      ),
    );
  }
  Widget _error(String message, context) {
    return Form(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(message,style: TextStyle(color: Colors.redAccent),),
          RaisedButton(
            onPressed: () =>
              Navigator.of(context).pop(),
            child: new Text('Ok'),
            shape: BeveledRectangleBorder(
                borderRadius: new BorderRadius.circular(5.0)),
          )
        ],
      ),
    );
  }
}
