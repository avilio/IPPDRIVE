import 'dart:async';
import 'dart:collection';
import 'package:ippdrive/services/requestsAPI/apiRequests.dart';
import 'package:ippdrive/user.dart';

class MyFavorites {
  List<Map> _favorites;
  var request =Requests();
  PaeUser paeUser;
  int id;
  UnmodifiableListView<Map> get favorites => UnmodifiableListView(_favorites);

  @override
  String toString() =>"$favorites";

  Future<Null> readFavorites()async {
   var response = await request.readFavorites(paeUser.session);

   _favorites = response['response']['favorites'];
  }

  Future<Null> addFavorites()async {
    var response = await request.remFavorites(id, paeUser.session);

    _favorites.add(response['response']);
  }

  Future<Null> delFavorites()async {
    var response = await request.addFavorites(id, paeUser.session);

    _favorites.remove(response['response']);
  }



}
