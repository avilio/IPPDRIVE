import 'package:flutter/material.dart';

import 'bloc.dart';

class BlocProvider extends InheritedWidget {
  final bloc = Bloc();

  BlocProvider({Key key, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static Bloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(BlocProvider) as BlocProvider)
          .bloc;
}
