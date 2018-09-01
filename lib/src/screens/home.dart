import 'dart:async';

import 'package:flutter/material.dart';

import '../blocs/bloc.dart';
import '../blocs/bloc_provider.dart';
import '../blocs/favorites_provider.dart';
import '../common/themes/colorsThemes.dart';
import '../models/user.dart';
import '../widgets/home/home_structure.dart';
import '../widgets/home/home_tiles.dart';
import '../widgets/home/semesters_lists_builder.dart';

class HomePage extends StatefulWidget {
  final List unitsCourseList;
  final PaeUser paeUser;
  HomePage({this.unitsCourseList, this.paeUser, Key key}) : super(key: key);

  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {


  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      final homeBloc = BlocProvider.of(context);
      homeBloc.onConnectionChange();
      /* onConnectivityChanged.listen((ConnectivityResult result){
        loginBloc.setConnectionStatus(result.toString());
      });*/
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeBloc = BlocProvider.of(context);
    final favBloc = FavoritesProvider.of(context);
    favBloc.setPaeUser(homeBloc.paeUser);
    homeBloc.onConnectionChange();

    if (widget.unitsCourseList.length > 1) {
      return discentesDocentes(context, homeBloc);
    } else
      return funcionarios(context, homeBloc);
  }

  ///
  Widget discentesDocentes(BuildContext context, Bloc bloc) {
    var semestres = SemestersBuilder.fromList2List(widget.unitsCourseList);
    bloc.onConnectionChange();
    ///
    return WillPopScope(
        onWillPop: () async {
          bloc.quitDialog(context);
        },
        child: HomeStructure(
          unitsCourseList: widget.unitsCourseList,
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
  Widget funcionarios(BuildContext context, Bloc bloc) {

    return WillPopScope(
        onWillPop: () async {
          bloc.quitDialog(context);
        },
        child: HomeStructure(
          appBarTitle: '${widget.unitsCourseList[0]['title']}',
          unitsCourseList: widget.unitsCourseList,
          children: <Widget>[
            new Padding(padding: EdgeInsets.all(0.5)),
            new Container(
                decoration: new BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(
                      style: BorderStyle.solid, color: cAppBlackish),
                ),
                child: HomeExpansionTiles(child: widget.unitsCourseList)),
          ])
        );
  }
}
