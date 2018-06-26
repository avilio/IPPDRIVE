import 'dart:async';

import 'package:ippdrive/newFavorties.dart';

class FavoritesBloc {
  final tapController = StreamController<MyFavorites>();

  Sink<MyFavorites> get tap => tapController.sink;

  final iconController = StreamController<bool>();

  Stream<bool> get isFav => iconController.stream;

  FavoritesBloc() {
    tapController.stream.listen(onTap);
  }

  void onTap(MyFavorites favorite) {
    //todo arranjar forma de passar os paramtros id e session para aqui
  }

  void dispose() {
    tapController.close();
    iconController.close();
  }
}
