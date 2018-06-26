import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ippdrive/services/REST.dart';

class DialogKey extends StatelessWidget {

  final REST res = REST();
  final RegExp _regUser = new RegExp("[a-zA-Z0-9]{1,256}");
  final _userController = new TextEditingController();
  final _passwordController = new TextEditingController();


  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('PAE Login',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),textAlign: TextAlign.center,),
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
                var map = {"username": _userController.text, "password": _passwordController.text};
                var url = "https://pae.ipportalegre.pt/authenticateWidget.do?dispatch=executeService&serviceJson=generateChaveApps";
                var response = await res.postAppKey(url, map);
                print(response);
                if(response['service'] == 'ok') {
                  showDialog(context: context,
                      child: AlertDialog(
                        title: Text(response['messages'][0]),
                        content: Text(response['response']['chave']),
                      ));
                }else {
                  showDialog(context: context,
                      child: AlertDialog(
                        title: Text('ERROR'),
                        content: Text(response['exception']),
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
}
