

import 'dart:async';

import 'package:async_loader/async_loader.dart';
import 'package:flutter/material.dart';
import 'package:ippdrive/Services/requestsAPI/requestsPhases.dart';

class Favorite extends StatefulWidget {
  final session;
  final id;

  Favorite(this.id, this.session,{Key key}) : super(key: key);

  @override
  _FavoriteState createState() => new _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  var _favRem = new Icon(Icons.star_border);
  var _favAdd = new Icon(Icons.star, color: Colors.yellow,);

  bool isFav = false;

  void _handleTap() async {

    Map fav = await readFavorites(widget.session);
   // widget.list = fav['response']['favorites'];
    //print('FAVORITOS  $widget.list\n');

    if(fav.isNotEmpty) {
      if (isFav) {
        var rem = await remFavorites(widget.id, widget.session);
        //favoritos.remove(rem);
        print(rem);
        setState(() {
          isFav = false;
        });
        await readFavorites(widget.session);
      } else {
        var add = await addFavorites(widget.id, widget.session);
        //favoritos.add(add);
        /*add.forEach((k,v){
          if(v is Map){
            Map f = v;

            f.forEach((a,b){
              print('$a  $b');
            });
          }

        });*/
        setState(() {
          isFav = true;
        });
        await readFavorites(widget.session);
        if (add['response']['fail'] == 'alreadyExist') {
          await remFavorites(widget.id, widget.session);
          print('adicionei e removi');
        }
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return new IconButton(
        icon: isFav ? _favAdd : _favRem,
        onPressed: _handleTap
    );
  }
}