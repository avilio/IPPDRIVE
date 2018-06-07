import 'package:flutter/material.dart';

import 'package:ippdrive/pages/layouts/components/drawer.dart';
import 'package:ippdrive/pages/layouts/components/homePageComponents.dart';
import 'package:ippdrive/user.dart';

class HomePage extends StatefulWidget {
  final Map json;
  final PaeUser paeUser;
  HomePage([this.json, this.paeUser,Key key]) : super(key: key);

  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
//todo por a lista para ler os favoritos
  @override
  Widget build(BuildContext context) {
    List list = widget.json['response']['childs'];
    String school = list[0]['path'].split('/')[3];
    String course = list[0]['path'].split('/')[5];
   // String year = list[0]['path'].split('/')[6].toString().split('.')[0] +' '+list[0]['path'].split('/')[6].toString().split('.')[1];
   // print(year);
//todo por o ano no titulo ou por baixo do titulo
    return WillPopScope(
      onWillPop: () async => false,
      child: new Scaffold(
        drawer: new MyDrawer(school,course , widget.paeUser),
          appBar: new AppBar(
            title: new Text(
              'Unidades Curricuares ${list[0]['path'].split('/')[6].toString().split('.')[1]}',
              //textScaleFactor: 1.5,
              style: new TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: semestres(list, widget.paeUser, context, school, course)
          ),
    );
  }
}
//todo adicionar a estrelinha para por como favorito usar os servicos 40000 do baco
//todo no back do telefone fazer com que apenas minimize
