import 'package:flutter/material.dart';

import '../../models/folders.dart';
import '../../blocs/favorites_bloc.dart';
import '../../blocs/favorites_provider.dart';


class Favorites extends StatefulWidget {
  final Folders folders;

  Favorites({this.folders, Key key}) : super(key: key);

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
   // print('${widget.folders.title} : ${widget.folders.isFav}');
    _isFav= widget.folders.isFav;
  }

  @override
  Widget build(BuildContext context) {
    final favBloc = FavoritesProvider.of(context);

    favBloc.setIsFav(_isFav);

    void handleTap() {

      if (_isFav) {
        favBloc.remFavorites(widget.folders.id, favBloc.paeUser.session);
        //todo
        print("Favorito: '${widget.folders.title}' --> Removido");
        setState(() {
          _isFav = false;
        });
      } else {
        favBloc.addFavorites(widget.folders.id,favBloc.paeUser.session)
            .then((map) {
            //todo
              print("Favorito: '${widget.folders.title}' --> Adicionado");
          /// Caso esta situaçao se verifique..muito raro acontecer
          if (map['response']['fail'] == 'alreadyExist') {
            favBloc.remFavorites(widget.folders.id, favBloc.paeUser.session);
            //todo
            print("Favorito: '${widget.folders.title}' adicionado e removido");
            setState(() {
              _isFav = false;
            });
          }
        });
        setState(() {
          _isFav = true;
        });
      }
    }

    return new IconButton(
        icon: !favBloc.isFav ? _favRem : _favAdd, onPressed: handleTap);
  }
}

