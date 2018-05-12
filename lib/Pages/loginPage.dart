import 'package:flutter/material.dart';
import 'package:ippdrive/Pages/colors.dart';
import 'package:ippdrive/RequestsAPI/requestsHandler.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new LoginPageState();
}
class LoginData {
  String user;
  String password;
}

class LoginPageState extends State<LoginPage>{
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  LoginData data = new LoginData();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Login', style: new TextStyle(color: Colors.black),),
        backgroundColor: kPrimaryColor,
      ),
      body: new Container(
        alignment: Alignment.center ,
        padding: new EdgeInsets.all(20.0),
        child: new Form(
            key: this.formKey,
            child: new ListView(
              children: <Widget>[
                new Image.asset(
                  "assets/images/icon.png",
                  width: 150.0,
                  height: 150.0,
                ),
                new Padding(padding: new EdgeInsets.all(50.0)),
                new TextFormField(
                    decoration: new InputDecoration(
                      labelText: "Number of Student",
                      hintText: "your student number",
                      labelStyle: new TextStyle(fontFamily: 'Exo2', color: Colors.blueGrey[700]),
                      border: OutlineInputBorder(),
                    ),
                  onFieldSubmitted: (String str){ data.user = str; },
                ),
                new Padding(padding: new EdgeInsets.all(5.0)),
                new TextFormField(
                    obscureText: true,
                    style: new TextStyle(fontFamily: 'Exo2', color: Colors.black),
                    decoration: new InputDecoration(
                        labelText: "Password",
                        labelStyle: new TextStyle(fontFamily: 'Exo2',color: Colors.blueGrey[700]),
                        hintText: "Mobile Key",
                        border: OutlineInputBorder()
                    ),
                  onFieldSubmitted: (String str){ data.password = str; },
                ),
                new Container(
                  child:  new RaisedButton(
                    // onPressed: () {Navigator.of(context).pushNamed("/listView");},
                    onPressed: (){
                      //todo get values from input
                      Handler(this.data);
                    },
                    child: new Text('Login',textScaleFactor: 1.2, maxLines: 1,
                        style: new TextStyle(fontFamily: 'Exo2')),
                    color: kPrimaryColor,
                    highlightColor: Colors.amber,
                    elevation: 8.0,
                    shape: BeveledRectangleBorder(
                        borderRadius:new BorderRadius.circular(10.0)),
                  ),
                  margin: new EdgeInsets.only(top: 20.0),
                )
              ],
            )
        ),
      ),
    );
  }
}