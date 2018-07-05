import 'package:flutter/material.dart';

import '../common/semesters_item_builder.dart';
import '../common/themes/colorsThemes.dart';
import '../models/user.dart';
import '../blocs/home_provider.dart';
import '../blocs/favorites_provider.dart';
import '../blocs/home_bloc.dart';
import '../widgets/home/home_tiles.dart';
import '../widgets/home/home_structure.dart';

class HomePage extends StatelessWidget {
  final List unitsCourseList;
  final PaeUser paeUser;
  HomePage({this.unitsCourseList, this.paeUser, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeBloc = HomeProvider.of(context);
    final favBloc = FavoritesProvider.of(context);
    favBloc.setPaeUser(homeBloc.paeUser);

    if (unitsCourseList.length > 1) {
      return discentesDocentes(context, homeBloc);
    } else
      return funcionarios(context, homeBloc);
  }
  ///
  Widget discentesDocentes(BuildContext context, HomeBloc bloc) {
    var semestres = SemestersBuilder.fromList2List(unitsCourseList);

    return WillPopScope(
        onWillPop: () async {
          bloc.quitDialog(context);
        },
        child: HomeStructure(
          unitsCourseList: unitsCourseList,
          children: <Widget>[
            new Padding(padding: EdgeInsets.all(0.5)),
            new Container(
                decoration: new BoxDecoration(
                  shape: BoxShape.rectangle,
                  border:
                      Border.all(style: BorderStyle.solid, color: cAppBlackish),
                ),
                child: HomeExpansionTiles(child: semestres.semester1)),
            new Container(
                decoration: new BoxDecoration(
                  shape: BoxShape.rectangle,
                  border:
                      Border.all(style: BorderStyle.solid, color: cAppBlackish),
                ),
                child: HomeExpansionTiles(child: semestres.semester2))
          ],
        ));
  }

  ///
  Widget funcionarios(BuildContext context, HomeBloc bloc) {

    return WillPopScope(
        onWillPop: () async {
          bloc.quitDialog(context);
        },
        child: HomeStructure(
          appBarTitle: '${unitsCourseList[0]['title']}',
          unitsCourseList: unitsCourseList,
          children: <Widget>[
            new Padding(padding: EdgeInsets.all(0.5)),
            new Container(
                decoration: new BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(
                      style: BorderStyle.solid, color: cAppBlackish),
                ),
                child: HomeExpansionTiles(child: unitsCourseList)),
          ])
        );
  }

}
