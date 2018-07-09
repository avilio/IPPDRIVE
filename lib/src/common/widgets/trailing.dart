import 'package:flutter/material.dart';

import '../../models/folders.dart';
import '../../common/widgets/favorites.dart';
import '../../common/widgets/add_files.dart';

class Trailing extends StatelessWidget {
  final bool canAdd;
  final Folders folder;

  Trailing({this.canAdd, this.folder, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    if(canAdd){
      return new Row(mainAxisSize: MainAxisSize.min,children: <Widget>[
        new AddFiles(),
        new Favorites(folders: folder,) ]);
    }
    else
      return new Favorites(folders: folder,);
  }
}
