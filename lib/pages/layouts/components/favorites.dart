
import 'package:flutter/material.dart';
import 'package:ippdrive/services/requestsAPI/requestsPhases.dart';

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
  Requests requests = Requests();

  void _handleTap() async {

    Map fav = await requests.readFavorites(widget.session);
   // widget.list = fav['response']['favorites'];
    //print('FAVORITOS  $widget.list\n');

    if(fav.isNotEmpty) {
      if (isFav) {
        var rem = await requests.remFavorites(widget.id, widget.session);
        //favoritos.remove(rem);
        print(rem);
        setState(() {
          isFav = false;
        });
        await requests.readFavorites(widget.session);
      } else {
        var add = await requests.addFavorites(widget.id, widget.session);
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
        await requests.readFavorites(widget.session);
        if (add['response']['fail'] == 'alreadyExist') {
          await requests.remFavorites(widget.id, widget.session);
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