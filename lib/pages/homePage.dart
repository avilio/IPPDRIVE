import 'package:flutter/material.dart';

import 'package:ippdrive/pages/layouts/components/homePageComponents.dart';
import 'package:ippdrive/user.dart';

class ListFolder extends StatefulWidget {
  final Map json;
  final PaeUser paeUser;
  ListFolder([this.json, this.paeUser,Key key]) : super(key: key);

  @override
  ListFolderState createState() => new ListFolderState(json, paeUser);
}

class ListFolderState extends State<ListFolder> {
  ListFolderState(this.json, this.paeUser);
  Map json;
  PaeUser paeUser;

  @override
  Widget build(BuildContext context) {
    List list = json['response']['childs'];

    return WillPopScope(
      onWillPop: () async => false,
      child: new Scaffold(
        drawer: myDrawer(context, list, paeUser.username),
          appBar: new AppBar(
            title: new Text(
              'Unidades Curricuares',
              textScaleFactor: 1.5,
              style: new TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: semestres(list, paeUser.session)
          ),
    );
  }
}
//todo adicionar a estrelinha para por como favorito usar os servicos 40000 do baco
//todo no back do telefone fazer com que apenas minimize



/*
*  myExpandTileRecursive(list, session, index).map((value)=> new ListTile(
          title: Container(
            decoration: new BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: new BorderRadius.circular(50.0),
              border: Border.all(style: BorderStyle.solid, color: cAppBlackish),
              color: cAppBlueAccent
          ),
            child: new ExpansionTile(
              title:GestureDetector(
                child: new Text(value['title'].toString().split('-')[0],textScaleFactor: 0.95,),
              ) ,
            ),
          ),
        )).toList()*/
