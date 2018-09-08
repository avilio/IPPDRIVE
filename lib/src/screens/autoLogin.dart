
/*
import 'package:async_loader/async_loader.dart';
import 'package:flutter/material.dart';


import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';

import '../blocs/bloc.dart';
import '../blocs/bloc_provider.dart';
import '../screens/login.dart';
import '../screens/home.dart';
import '../common/widgets/progress_indicator.dart';

class AutoLogin extends StatefulWidget {
  @override
  _AutoLoginState createState() => _AutoLoginState();
}

class _AutoLoginState extends State<AutoLogin> {

  final _padding = EdgeInsets.all(25.0);

  @override
  Widget build(BuildContext context) {

    final bloc = BlocProvider.of(context);
    bool b = false;


    return Scaffold(
      body: AsyncLoader(
        initState: () async{

          SharedPreferences pref = await SharedPreferences.getInstance();
          b = pref.get("memoUser") ?? false;
          bloc.setIsMemo(b);
          bloc.setUsername(pref.get("username"));
          bloc.setPassword(pref.get("password"));
          bloc.submit(bloc.username, bloc.password, context);
        },
        renderLoad: () => Center(child: AdaptiveProgressIndicator()),
        renderSuccess:({data}) {

          if(b) {

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        HomePage(
                            unitsCourseList: bloc.response['childs'],
                            paeUser: bloc.paeUser)));
          }else
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LoginPage()));
        },
      )
    );
  }


}
*/

