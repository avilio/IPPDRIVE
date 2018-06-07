import 'package:flutter/material.dart';

import 'package:async_loader/async_loader.dart';
import 'package:ippdrive/pages/layouts/components/ucContentPageComponents.dart';

import 'package:ippdrive/security/verifications/display.dart';
import 'package:ippdrive/services/requestsAPI/requestsPhases.dart';
import 'package:ippdrive/pages/layouts/components/drawer.dart';
import 'package:ippdrive/user.dart';

class UcContent extends StatefulWidget {
  final Map content;
  final PaeUser paeUser;
  final String school;
  final String course;
  UcContent([this.content, this.paeUser, this.school, this.course]);

  @override
  State<StatefulWidget> createState() => new UcContentState();
}

class UcContentState extends State<UcContent> {

  List favorites = new List();

  @override
  Widget build(BuildContext context) {

    var bodyList = new AsyncLoader(
        initState: () async =>
        await courseUnitsContents(widget.content, widget.paeUser.session),
        renderLoad: () => new CircularProgressIndicator(),
        renderError: ([error]) => new Text('ERROR LOANDING DATA'),
        renderSuccess: ({data}) {
          List a = data['response']['childs'];
          print(data['response']['childs']);
          if (a.isNotEmpty)
            return createList(data, widget.paeUser,widget.school,widget.course,context);
          else
            return buildDialog('Data is Empty', context);
        });

    return new Scaffold(
        drawer: new MyDrawer(widget.school, widget.course,widget. paeUser),
        appBar: new AppBar(
          title: new Text(
            widget.content['title'].toString().split('-')[0],
            //textScaleFactor: 0.7,
            style: new TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: bodyList);
  }

}
