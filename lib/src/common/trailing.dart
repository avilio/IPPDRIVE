import 'package:flutter/material.dart';
import '../models/folders.dart';

import '../common/favorites.dart';
import '../common/add_files.dart';
import '../blocs/favorites_provider.dart';

class Trailing extends StatelessWidget {
  final bool canAdd;
  final Folders folder;

  Trailing({this.canAdd, this.folder, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   //final homeBloc = HomeProvider.of(context);
   //final favBloc = FavoritesProvider.of(context);
   //favBloc.setFolders(folder);
  // favBloc.setIsFav(folder.isFav);

    if(canAdd){
      return new Row(mainAxisSize: MainAxisSize.min,children: <Widget>[
        new AddFiles(),
        new Favorites(folders: folder,) ]);
    }
    else
      return new Favorites(folders: folder,);
  }
}
