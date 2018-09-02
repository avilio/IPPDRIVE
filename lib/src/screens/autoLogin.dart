
/*
class AutoLogin extends StatefulWidget {
  @override
  _AutoLoginState createState() => _AutoLoginState();
}

class _AutoLoginState extends State<AutoLogin> {

  final _padding = EdgeInsets.all(25.0);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of(context);
    init(context, bloc);

    return Scaffold(
      body: Center(
        child: _submitButton(bloc, context),
      ),
    );
  }

  Widget _submitButton(Bloc bloc, BuildContext context) {
    return new Container(
      padding: _padding,
      child: new RaisedButton(
        onPressed: () {
          //!bloc.connectionStatus.contains('none')?
          bloc.submit(bloc.username,
              bloc.password, context);
          // : bloc.errorDialog('Sem acesso a Internet', context);
        },
        child: new Text('AutoLogin'),
        elevation: 2.0,
        shape: BeveledRectangleBorder(
            borderRadius: new BorderRadius.circular(5.0)),
      ),
    );
  }
  void init(BuildContext context, Bloc bloc)async{

    SharedPreferences pref = await SharedPreferences.getInstance();
    bool b = pref.get("memoUser") ?? false;
    bloc.setIsMemo(b);
    bloc.setUsername(pref.get("username"));
    bloc.setPassword(pref.get("password"));
  }
}
*/
