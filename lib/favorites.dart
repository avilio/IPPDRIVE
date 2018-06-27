import 'dart:async';

import 'package:async_loader/async_loader.dart';
import 'package:flutter/material.dart';
import 'package:ippdrive/services/requestsAPI/apiRequests.dart';
import 'package:ippdrive/user.dart';

class Favorites extends StatefulWidget {
  final PaeUser paeUser;
  final Map json;

  Favorites(this.json, this.paeUser, {Key key}) : super(key: key);

  @override
  _FavoriteState createState() => new _FavoriteState();
}

class _FavoriteState extends State<Favorites> {
  var _favRem = new Icon(Icons.star_border);
  var _favAdd = new Icon(
    Icons.star,
    color: Colors.yellow,
  );
  Requests request = Requests();
  bool isFav = false;


  @override
  void initState() {
    super.initState();
    print('${widget.json['title']} : ${widget.json['favorite']}');

    isFav = widget.json['favorite'];
  }

  void _handleTap() {

    if (isFav) {
      request.remFavorites(widget.json['id'], widget.paeUser.session);
      print("Favorito: '${widget.json['title']}' Removido");
      setState(() {
        isFav = false;
      });

    } else {
      request.addFavorites(widget.json['id'], widget.paeUser.session)
          .then((map) {
        print("Favorito: '${widget.json['title']}' Adicionado");

        ///Caso esta situaçao se verifique..muito raro acontecer
        if (map['response']['fail'] == 'alreadyExist') {
          request.remFavorites(widget.json['id'], widget.paeUser.session);
          print('adicionei e removi');
          setState(() {
            isFav = false;
          });
        }
      });
      setState(() {
        isFav = true;
      });
      //print(add);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new IconButton(
        icon: !isFav ? _favRem : _favAdd, onPressed: _handleTap);
  }
}
