import 'package:flutter/material.dart';

import '../../blocs/bloc_provider.dart';
import '../../common/themes/colorsThemes.dart';
import '../../common/widgets/trailing.dart';
import '../../models/folders.dart';
import '../../screens/content.dart';


class HomeExpansionTiles extends StatelessWidget {
  final List child;

  HomeExpansionTiles({Key key,this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title;
    final homeBloc = BlocProvider.of(context);
    homeBloc.onConnectionChange();


      if (child[0]['pathParent'] != '/root')
        title = child[0]['courseUnitsList'][0]['semestre'] == "S1"
            ? 'Semestre 1'
            : 'Semestre 2';

      return new ExpansionTile(
        // key: PageStorageKey('${child.map((units) => units['id'])}'),
        title: new Text(
          title ?? 'ROOT',
          textScaleFactor: 1.5,
        ),
        children: child.map((courseUnits) {

          Folders folder = Folders.fromJson(courseUnits);
          return new ListTile(
            title: Container(
              decoration: new BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(
                      style: BorderStyle.solid, color: cAppBlackish),
                  color: cAppBlueAccent),
              child: new ListTile(
                trailing: Trailing(folder: folder,
                  clearances: courseUnits['clearances'],
                  content: courseUnits,),
                onTap: () {
                  if (!homeBloc.connectionStatus.contains('none') ||
                      (homeBloc.connectionStatus.contains('none') &&
                          (homeBloc.sharedPrefs.get(
                              courseUnits['id'].toString()) != null)))
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                        new Content(unitContent: courseUnits)));
                  else
                    homeBloc.errorDialog('Sem acesso a Internet', context);
                },
                title: new Text(courseUnits['title']
                    .toString()
                    .split('-')
                    .first,
                    textScaleFactor: 0.95),
              ),
            ),
          );
        }).toList(),
      );

  }
}
