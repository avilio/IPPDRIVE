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
      final bloc = BlocProvider.of(context);
      bloc.onConnectionChange();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of(context);
    final favBloc = FavoritesProvider.of(context);
    favBloc.setPaeUser(bloc.paeUser);
    bloc.onConnectionChange();

    if (!bloc.isNumeric(bloc.paeUser.username) && widget.unitsCourseList.length<=1) {
      return funcionarios(context, bloc);
    } else
      return discentesDocentes(context, bloc);
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
        child:HomeStructure(
          anoCorrente: bloc.paeUser.anoCorrente,
          unitsCourseList: widget.unitsCourseList,
          children: <Widget>[
            new Padding(padding: EdgeInsets.all(0.5)),
           semestres.semester1.length > 1? new Container(
                decoration: new BoxDecoration(
                  shape: BoxShape.rectangle,
                  border:
                      Border.all(style: BorderStyle.solid, color: cAppBlackish),
                ),
                child: HomeExpansionTiles(child: semestres.semester1)) :
           Column(
             mainAxisAlignment: MainAxisAlignment.center,
             crossAxisAlignment: CrossAxisAlignment.center,
             mainAxisSize: MainAxisSize.min,
             children: <Widget>[
               Icon(Icons.warning,color: Colors.red,size: 50.0,),
               Padding(
                 padding: const EdgeInsets.all(20.0),
                 child: Text("Nao tem conteudos disponiveis",textScaleFactor: 1.5),
               ),
             ],
           ),
            semestres.semester2.length> 1 ? new Container(
                decoration: new BoxDecoration(
                  shape: BoxShape.rectangle,
                  border:
                      Border.all(style: BorderStyle.solid, color: cAppBlackish),
                ),
                child: HomeExpansionTiles(child: semestres.semester2)): Container()
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
          //anoCorrente: bloc.paeUser.anoCorrente,
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
