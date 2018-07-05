import 'package:flutter/material.dart';
import 'package:ippdrive/folders.dart';
import 'package:ippdrive/views/themes/colorsThemes.dart';

import '../../common/trailing.dart';
import '../../screens/content.dart';


class HomeExpansionTiles extends StatelessWidget {
  final List child;

  HomeExpansionTiles({Key key,this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title;

    if(child[0]['indexInParent'] != 0)
      title = child[0]['courseUnitsList'][0]['semestre'] == "S1"
          ? 'Semestre 1'
          : 'Semestre 2';

    return new ExpansionTile(
      title: new Text(
        title ?? 'ROOT',
        textScaleFactor: 1.5,
      ),
      children: child.map((val) {
        Folders folder = Folders.fromJson(val);
        return new ListTile(
          title: Container(
            decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border.all(style: BorderStyle.solid, color: cAppBlackish),
                color: cAppBlueAccent),
            child: new ListTile(
              trailing: Trailing(folder: folder,canAdd: val['clearances']['addFiles']),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                  new UcContent(unitContent: val))),
              title: new Text(val['title'].toString().split('-')[0],
                  textScaleFactor: 0.95),
            ),
          ),
        );
      }).toList(),
    );

  }
}
