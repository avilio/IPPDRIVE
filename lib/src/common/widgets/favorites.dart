import 'package:flutter/material.dart';

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
    // print('${widget.folders.title} : ${widget.folders.isFav}');
    _isFav = widget.folders.isFav;
  }

  //todo tentar com que  funcione  como a  icon  da  clou no  expand
  @override
  Widget build(BuildContext context) {
    final favBloc = FavoritesProvider.of(context);
    final bloc = BlocProvider.of(context);

    favBloc.setIsFav(_isFav);
    void handleTap() {
      if(bloc.connectionStatus.contains('none'))
        bloc.errorDialog("Sem acesso a Internet", context);
      else {
        if (_isFav) {
          favBloc.remFavorites(widget.folders.id, favBloc.paeUser.session);
          //todo
          print("Favorito: '${widget.folders.title}' --> Removido");
          setState(() {
            _isFav = false;
          });
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
            }
          });
          setState(() {
            _isFav = true;
          });
        }
      }
    }

   Widget fav =widget.controller != null
        ? Container(
        child: ScaleTransition(
            scale: CurvedAnimation(
                parent: widget.controller.view,
                curve: Interval(0.0, 0.5, curve: Curves.easeOut)),
            child: new IconButton(
                icon: !favBloc.isFav ? _favRem : _favAdd, onPressed: handleTap),
            alignment: FractionalOffset.center))
        :  new IconButton(
             icon: !favBloc.isFav ? _favRem : _favAdd, onPressed: handleTap);

    return fav;
  }
}