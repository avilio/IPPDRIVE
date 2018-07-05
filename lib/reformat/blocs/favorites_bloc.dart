import 'package:ippdrive/folders.dart';

import '../resources/apiCalls.dart';
import 'package:rxdart/rxdart.dart';

import '../models/user.dart';

class FavoritesBloc extends Object with Requests{

  final _paeUser = BehaviorSubject<PaeUser>();
  final _response = BehaviorSubject<dynamic>();
  final _isFav = BehaviorSubject<bool>();
  //final _folders = BehaviorSubject<Folders>();

  PaeUser get paeUser => _paeUser.value;
  bool get isFav => _isFav.value;
  //Folders get folders => _folders.value;

  Function(PaeUser) get setPaeUser => _paeUser.sink.add;
  Function(bool) get setIsFav => _isFav.sink.add;
  //Function(Folders) get setFolders => _folders.sink.add;


  dispose() {
    _response.close();
    _paeUser.close();
    _isFav.close();
  //  _folders.close();
  }
}