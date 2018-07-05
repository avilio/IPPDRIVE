import 'package:flutter/material.dart';

import 'drawer_bloc.dart';

class DrawerProvider extends InheritedWidget{

  final bloc = DrawerBloc();

  DrawerProvider({Key key, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static DrawerBloc of(BuildContext context)
  => (context.inheritFromWidgetOfExactType(DrawerProvider) as DrawerProvider).bloc;

}