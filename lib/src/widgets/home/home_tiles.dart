import 'package:flutter/material.dart';

import '../../models/folders.dart';
import '../../common/themes/colorsThemes.dart';
import '../../common/trailing.dart';
import '../../common/list_item_builder.dart';
import '../../screens/content.dart';


class HomeExpansionTiles extends StatelessWidget {
  final List child;

  HomeExpansionTiles({Key key,this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title;

    if(child[0]['pathParent'] != '/root')
      title = child[0]['courseUnitsList'][0]['semestre'] == "S1"
          ? 'Semestre 1'
          : 'Semestre 2';
    
    return new ExpansionTile(
      key: PageStorageKey('${child.map((units) => units['id'])}'),
      title: new Text(
        title ?? 'ROOT',
        textScaleFactor: 1.5,
      ),
      children: child.map((courseUnits) {
        ///
        Folders folder = Folders.fromJson(courseUnits);
        return new ListTile(
          title: Container(
            decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border.all(style: BorderStyle.solid, color: cAppBlackish),
                color: cAppBlueAccent),
            child: new ListTile(
              trailing: Trailing(folder: folder,canAdd: courseUnits['clearances']['addFiles']),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                  new Content(unitContent: courseUnits))),
              title: new Text(courseUnits['title'].toString().split('-').first,
                  textScaleFactor: 0.95),
            ),
          ),
        );
      }).toList(),
    );

  }
}
