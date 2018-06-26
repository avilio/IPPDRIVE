import 'dart:async';

import 'package:ippdrive/services/requestsAPI/apiRequests.dart';

class MyFavorites {
  List<Map> favorites;
  var request =Requests();


  Future<Null> readFavorites(String session)async {
   var response = await request.readFavorites(session);

   favorites = response['response']['favorites'];
  }

  Future<Null> addFavorites(int id, String session)async {
    var response = await request.remFavorites(id, session);

    favorites.add(response['response']);
  }

  Future<Null> delFavorites(int id, String session)async {
    var response = await request.addFavorites(id, session);

    favorites.remove(response['response']);
  }
}
