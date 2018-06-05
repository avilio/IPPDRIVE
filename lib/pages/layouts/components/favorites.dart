

import 'package:async_loader/async_loader.dart';
import 'package:flutter/material.dart';
import 'package:ippdrive/Services/requestsAPI/requestsPhases.dart';

class Favorite extends StatefulWidget {
  final session;
  final id;

  Favorite(this.id, this.session, {Key key}) : super(key: key);

  @override
  _FavoriteState createState() => new _FavoriteState(id, session);
}

class _FavoriteState extends State<Favorite> {
  var _favRem = new Icon(Icons.star_border);
  var _favAdd = new Icon(Icons.star, color: Colors.yellow,);
  int id;
  String session;

  _FavoriteState(this.id, this.session);

  bool isFav = false;

  void _handleTap() {
    //  var swFav =_favRem;
    var swFav = new List();
    /*  new FutureBuilder(
        future: readFavorites(session),
        builder: (context, response) {
        /*    List fav = response.data['favorites'];
            Iterator i = fav.iterator;
            while (i.moveNext()) {
              if (id == i.current['pageContentId'])
                return _favAdd;
              else
                return _favRem;
            }*/
          swFav.add(response.data['favorites']);
           // print(response.data['favorites']);
            //return response.data['favorites'];
    });*/

    new AsyncLoader(
      initState: () async => await readFavorites(session),
      renderLoad: () => new CircularProgressIndicator(),
      renderError: ([error]) => new Text('ERROR LOANDING DATA') ,
      renderSuccess: ({data}) {

          swFav = data['response']['childs'];
        }
    );


 //todo adicionar e ler favoritos de seguida

   /* var resp = readFavorites(session);
//todo later , on readFavorites esta sempre a devolver todos os conteudos
    //mas o idd para adicionar esta a passar o correto
    resp.then((onValue){
      print('id: $id');
      //print(onValue['response']['favorites'][2]['pageContentId']);
      swFav = onValue['response']['favorites'];
      print(swFav[2]);

    });*/
    setState(() {
      //  print(isFav);
      if(isFav) {
        remFavorites(id, session);
        //  print('premovi');
      }else {
        addFavorites(id, session);
        //  print('passei aqui');
      }

      //   _favRem = _favAdd;
      //  _favAdd = swFav;

    });


/*
    Iterator fav = swFav.iterator;
    while(fav.moveNext()) {
      if (fav.current['pageContentId'] == id)
        isFav = true;
    }*/


  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: isFav ? _favAdd : _favRem,
      onTap: _handleTap,
    );
  }
}