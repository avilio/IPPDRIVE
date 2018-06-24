
import 'package:flutter/material.dart';
import 'package:ippdrive/services/requestsAPI/apiRequests.dart';
import 'package:ippdrive/user.dart';

class Favorites extends StatefulWidget {
  final PaeUser paeUser;
  final id;

  Favorites(this.id, this.paeUser,{Key key}) : super(key: key);

  @override
  _FavoriteState createState() => new _FavoriteState();
}

class _FavoriteState extends State<Favorites> {
  var _favRem = new Icon(Icons.star_border);
  var _favAdd = new Icon(Icons.star, color: Colors.yellow,);
  Requests request = Requests();

  bool isFav = false;


  @override
  void initState() {
    super.initState();


    request.readFavorites(widget.paeUser.session).then((fav){
      if (fav.isNotEmpty) {
        Iterator favorito = fav['response']['favorites'].iterator;

        while (favorito.moveNext()) {
          if (favorito.current['pageContentId'] == widget.id) {
            setState(() {
              isFav = true;
            });
            break;
          }
        }
      }
    });
  }

  void _handleTap() async {

    if (isFav) {
      var rem = await request.remFavorites(widget.id, widget.paeUser.session);
      print(rem);
      setState(() {
        isFav = false;
      });

    } else {
      var add = await request.addFavorites(widget.id, widget.paeUser.session);
      print(add);
      setState(() {
        isFav = true;
      });
      if (add['response']['fail'] == 'alreadyExist') {
        await request.remFavorites(widget.id, widget.paeUser.session);
        print('adicionei e removi');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return new IconButton(
        icon: !isFav ? _favRem: _favAdd,
        onPressed: _handleTap
    );
  }
}