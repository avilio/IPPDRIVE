import 'package:flutter/material.dart';

import 'home_bloc.dart';

class HomeProvider extends InheritedWidget {
  final bloc = HomeBloc();

  HomeProvider({Key key, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static HomeBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(HomeProvider) as HomeProvider)
          .bloc;
}
