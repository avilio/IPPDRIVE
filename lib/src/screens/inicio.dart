import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../blocs/bloc.dart';
import '../blocs/bloc_provider.dart';
import '../screens/login.dart';

class Index extends StatefulWidget {
  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {

  final _padding = EdgeInsets.all(25.0);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of(context);

    final deviceHeight = MediaQuery.of(context).size.height;
    final targetHeight = deviceHeight > 1080 ? 1080 : deviceHeight * 0.95;
    final paddingDevice = deviceHeight - targetHeight;


    return Scaffold(
      body:_buildBody(bloc, paddingDevice, context) ,
    );
  }

  ///
  Widget _buildBody(Bloc bloc, double padding, BuildContext context) {
    bloc.onConnectionChange();
    return SingleChildScrollView(
      child: Container(
        child: Padding(
          padding: _padding,
          child: Column(
            children: <Widget>[
              Padding(padding: new EdgeInsets.all(padding)),
              new Image.asset("assets/images/icon.png",
                  width: 150.0, height: 150.0),
              Padding(padding: new EdgeInsets.all(10.0)),
              Text("Bem vindo ao IppDrive", style: Theme.of(context).primaryTextTheme.title,textScaleFactor: 1.5,),
              Padding(padding: new EdgeInsets.all(10.0)),
              _submitButton(bloc, context),
              Padding(padding: new EdgeInsets.all(15.0)),
              _bottomText()
            ],
          ),
        ),
      ),
    );
  }

  Widget _submitButton(Bloc bloc, BuildContext context) {
    return new Container(
      padding: _padding,
      child: new RaisedButton(
        onPressed: () async {

          SharedPreferences pref = await SharedPreferences.getInstance();
          bool b = pref.get("memoUser") ?? false;
          bloc.setIsMemo(b);
          bloc.setUsername(pref.get("username"));
          bloc.setPassword(pref.get("password"));
           if(b)
             bloc.submit(bloc.username,
              bloc.password, context);
           else
             Navigator.push(
                 context,
                 MaterialPageRoute(
                     builder: (context) => LoginPage()));
          // : bloc.errorDialog('Sem acesso a Internet', context);
        },
        child: new Text('Entrar'),
        elevation: 2.0,
        shape: BeveledRectangleBorder(
            borderRadius: new BorderRadius.circular(5.0)),
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
}
