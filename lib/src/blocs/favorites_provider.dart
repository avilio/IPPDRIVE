import 'package:flutter/material.dart';

import '../blocs/favorites_bloc.dart';

class FavoritesProvider extends InheritedWidget {

  final bloc = FavoritesBloc();

  FavoritesProvider({Key key, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static FavoritesBloc of(BuildContext context)
    => (context.inheritFromWidgetOfExactType(FavoritesProvider) as FavoritesProvider).bloc;
}