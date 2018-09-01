import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../blocs/bloc_provider.dart';
import '../../blocs/favorites_provider.dart';
import '../../models/folders.dart';

class Favorites extends StatefulWidget {
  final Folders folders;
  final AnimationController controller;

  Favorites({this.folders, this.controller, Key key}) : super(key: key);

  @override
  FavoritesState createState() {
    return new FavoritesState();
  }
}

class FavoritesState extends State<Favorites> {
  final _favRem = new Icon(Icons.star_border);
  final _favAdd = new Icon(Icons.star, color: Colors.yellow);

  bool _isFav = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      final homeBloc = BlocProvider.of(context);
      homeBloc.onConnectionChange();
      /* onConnectivityChanged.listen((ConnectivityResult result){
        loginBloc.setConnectionStatus(result.toString());
      });*/
    });

    SharedPreferences.getInstance().then((sharedPreferences) {
      //sharedPreferences.setBool("favorite/${widget.folders.title}", widget.folders.isFav);

      setState(() {
        _isFav =
            sharedPreferences.getBool("favorite/${widget.folders.title}") ??
                false;
      });
    });
  }

  void handleTap() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    new Future.delayed(Duration.zero, () {
      final favBloc = FavoritesProvider.of(context);
      final homeBloc = BlocProvider.of(context);

      favBloc.setIsFav(_isFav);

      if (homeBloc.connectionStatus.contains('none'))
        homeBloc.errorDialog("Sem acesso a Internet", context);
      else {
        if (_isFav) {
          favBloc.remFavorites(widget.folders.id, favBloc.paeUser.session);
          //todo
          print("Favorito: '${widget.folders.title}' --> Removido");
          setState(() {
            _isFav = false;
          });
          sharedPreferences.setBool("favorite/${widget.folders.isFav}", _isFav);
        } else {
          favBloc
              .addFavorites(widget.folders.id, favBloc.paeUser.session)
              .then((map) {
            //todo
            print("Favorito: '${widget.folders.title}' --> Adicionado");

            /// Caso esta situaçao se verifique..muito raro acontecer
            if (map['response']['fail'] == 'alreadyExist') {
              favBloc.remFavorites(widget.folders.id, favBloc.paeUser.session);
              //todo
              print(
                  "Favorito: '${widget.folders.title}' adicionado e removido");
              setState(() {
                _isFav = false;
              });
              sharedPreferences.setBool(
                  "favorite/${widget.folders.isFav}", _isFav);
            }
          });
          setState(() {
            _isFav = true;
          });
          sharedPreferences.setBool("favorite/${widget.folders.isFav}", _isFav);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ScaleTransition(
            scale: CurvedAnimation(
                parent: widget.controller.view,
                curve: Interval(0.0, 0.5, curve: Curves.easeOut)),
            child: new IconButton(
                icon: !_isFav ? _favRem : _favAdd, onPressed: handleTap),
            alignment: FractionalOffset.center));
  }
}
