import 'package:flutter/material.dart';

import 'package:async_loader/async_loader.dart';
import 'package:ippdrive/pages/layouts/components/ucContentPageComponents.dart';

import 'package:ippdrive/security/verifications/display.dart';
import 'package:ippdrive/services/requestsAPI/apiRequests.dart';
import 'package:ippdrive/drawer.dart';
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

  Requests request = Requests();

  @override
  Widget build(BuildContext context) {


   // print('DATA UC PAGE >>>>>>>>>>> ${widget.content['response'] ['childs']}');

    var bodyList = new AsyncLoader(
        initState: () async =>
        await request.courseUnitsFoldersContents(widget.content, widget.paeUser.session),
        renderLoad: () => new CircularProgressIndicator(),
        renderError: ([error]) => new Text('ERROR LOANDING DATA'),
        renderSuccess: ({data}) {
         // print(data);
          //print('DATA UC PAGE >>>>>>>>>>> ${data['response']['childs']}');
          List a = data['response']['childs'];
          if (a.isNotEmpty)
            return createList(data, widget.paeUser,widget.school,widget.course,context);
          else
           return buildDialog('Data is Empty', context);
        });

    return new Scaffold(
        drawer: new MyDrawer(widget.school, widget.course,widget.paeUser),
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
