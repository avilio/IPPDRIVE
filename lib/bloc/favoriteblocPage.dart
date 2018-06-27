import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ippdrive/newFavorties.dart';
import 'favoriteBloc.dart';


class FavoriteBlocPage extends StatefulWidget {

  final Map favorite;
  final Stream<MyFavorites> favStream;


  FavoriteBlocPage({this.favorite, this.favStream});

  @override
  _FavoriteBlocPageState createState() => _FavoriteBlocPageState();
}

class _FavoriteBlocPageState extends State<FavoriteBlocPage> {

  FavoritesBloc _bloc;

  StreamSubscription _subscription;
  var _favRem = new Icon(Icons.star_border);
  var _favAdd = new Icon(
    Icons.star,
    color: Colors.yellow,
  );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _bloc.isFav,
      builder: (context, snapshot) => snapshot.hasData
          ? new IconButton(
          icon: !snapshot.data ? _favRem : _favAdd, onPressed:null )//todo
          : new CircularProgressIndicator(),
    );
  }

  @override
  void dispose() {
    _disposeBloc();
    super.dispose();
  }

  @override
  void didUpdateWidget(FavoriteBlocPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _disposeBloc();
    _createBloc();
  }

  @override
  void initState() {
    super.initState();
    _createBloc();
  }

  void _createBloc() {
    _bloc = FavoritesBloc(widget.favorite);
    _subscription = widget.favStream.listen(_bloc.tap.add);
  }

  void _disposeBloc() {
    _subscription.cancel();
    _bloc.dispose();
  }

}
