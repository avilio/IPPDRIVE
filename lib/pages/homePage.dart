import 'package:flutter/material.dart';

import 'package:ippdrive/pages/layouts/components/drawer.dart';
import 'package:ippdrive/pages/layouts/components/homePageComponents.dart';
import 'package:ippdrive/user.dart';

class HomePage extends StatefulWidget {
  final Map json;
  final PaeUser paeUser;
  HomePage([this.json, this.paeUser,Key key]) : super(key: key);

  @override
  HomePageState createState() => new HomePageState(json, paeUser);
}

class HomePageState extends State<HomePage> {
  HomePageState(this.json, this.paeUser);
  Map json;
  PaeUser paeUser;

  @override
  Widget build(BuildContext context) {
    List list = json['response']['childs'];
    String school = list[0]['path'].split('/')[3];
    String course = list[0]['path'].split('/')[5];

    return WillPopScope(
      onWillPop: () async => false,
      child: new Scaffold(
        drawer: new MyDrawer(school,course , paeUser.username),
          appBar: new AppBar(
            title: new Text(
              'Unidades Curricuares',
              textScaleFactor: 1.5,
              style: new TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: semestres(list, paeUser, context, school, course)
          ),
    );
  }
}
//todo adicionar a estrelinha para por como favorito usar os servicos 40000 do baco
//todo no back do telefone fazer com que apenas minimize
