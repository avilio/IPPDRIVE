import 'dart:async';

import 'package:async_loader/async_loader.dart';
import 'package:flutter/material.dart';
import 'package:ippdrive/services/requestsAPI/apiRequests.dart';
import 'package:ippdrive/user.dart';

class Favorites extends StatefulWidget {
  final PaeUser paeUser;
  final id;

  Favorites(this.id, this.paeUser, {Key key}) : super(key: key);

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
  Iterator favorites;
  List myfavorites;
  //bool haveChanges = true;
  bool isFav = false;

//todo REBENTA SE ENTRAR E SAIR MUITAS VEZES DE UMA PASTA QUE ESTEJA A CHAMAR OS READFAVORITES

  void _handleTap() {
    if (isFav) {
      request
          .remFavorites(widget.id, widget.paeUser.session)
          .then((_) => setState(() {
                isFav = false;
              }));
      //print(rem);

    } else {

      request.addFavorites(widget.id, widget.paeUser.session).then((map) {
        //print(map);
        setState(() {
          isFav = true;
        });
        if (map['response']['fail'] == 'alreadyExist') {
          request.remFavorites(widget.id, widget.paeUser.session);
          print('adicionei e removi');
        }
      });
      //print(add);
    }
   // haveChanges = true;
  }

  Future<bool> getFavorites() async {

   /// if(haveChanges) {
      var fav = await request.readFavorites(widget.paeUser.session);

      myfavorites = fav['response']['favorites'];
     // print('tenho mudanças');
   //

    favorites = myfavorites.iterator;
    var flag = false;
    while (favorites.moveNext()) {
    //  print(favorites.current);
      if (favorites.current['pageContentId'] == widget.id) {
        flag = true;
        //break;
      }
    }

   // haveChanges = false;

    return flag;
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getFavorites().asStream(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? new IconButton(
                icon: !snapshot.data ? _favRem : _favAdd, onPressed: _handleTap)
            : new CircularProgressIndicator();
      },
    );
  }


}
