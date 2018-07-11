import 'package:flutter/material.dart';

import '../blocs/home_provider.dart';

class Error401 {

  error401(BuildContext context){
    final homeBloc = HomeProvider.of(context);
    ///
    homeBloc.wsAuth().then((response) {
      homeBloc.paeUser.session =
      response['response']['BACOSESS'];
      ///
      //Future.delayed(Duration.zero);
      ///
      homeBloc
          .wsRLogin(
          homeBloc.paeUser.username,
          homeBloc.paeUser.password,
          homeBloc.paeUser.session)
          .then((response) => homeBloc.paeUser.session =
      response['response']['BACOSESS']);
    });

  }
}