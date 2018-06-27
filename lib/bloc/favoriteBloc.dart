import 'dart:async';

import 'package:ippdrive/newFavorties.dart';
import 'package:rxdart/rxdart.dart';

class FavoritesBloc {

  final tapController = StreamController<MyFavorites>();

  Sink<MyFavorites> get tap => tapController.sink;

  final iconController = BehaviorSubject<bool>();

  Stream<bool> get isFav => iconController.stream;

  FavoritesBloc(Map favorite) {
    tapController.stream.map((fav)=> fav.favorites.contains(favorite)).listen((isFav) => iconController.add(isFav));
  }

  void dispose() {
    tapController.close();
    iconController.close();
  }
}
