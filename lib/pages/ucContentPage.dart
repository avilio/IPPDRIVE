import 'package:flutter/material.dart';

import 'package:async_loader/async_loader.dart';

import 'package:ippdrive/security/verifications/display.dart';
import 'package:ippdrive/services/requestsAPI/requestsPhases.dart';
import 'package:ippdrive/pages/layouts/components/drawer.dart';
import 'package:ippdrive/pages/themes/colorsThemes.dart';
import 'package:ippdrive/user.dart';

class UcContent extends StatefulWidget {
  final Map content;
  final PaeUser paeUser;
  final String school;
  final String course;
  UcContent([this.content, this.paeUser, this.school, this.course]);

  @override
  State<StatefulWidget> createState() =>
      new UcContentState(content, paeUser, school, course);
}

class UcContentState extends State<UcContent> {
  Map content;
  PaeUser paeUser;
  String school;
  String course;

  UcContentState([this.content, this.paeUser, this.school, this.course]);

  @override
  Widget build(BuildContext context) {
    var bodyList = new AsyncLoader(
        initState: () async =>
            await courseUnitsContents(content, paeUser.session),
        renderLoad: () => new CircularProgressIndicator(),
        renderError: ([error]) => new Text('ERROR LOANDING DATA'),
        renderSuccess: ({data}) {
          List a = data['response']['childs'];
          print(data['response']['childs']);
          if (a.isNotEmpty)
            return createList(data, paeUser.session);
          else
            return buildDialog('Data is Empty', context);
        });

    return new Scaffold(
        drawer: new MyDrawer(school, course, paeUser.username),
        appBar: new AppBar(
          title: new Text(
            content['title'].toString().split('-')[0],
            //textScaleFactor: 0.7,
            style: new TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: bodyList);
  }

  Widget createList(Map response, session) {
    Iterator items = response['response']['childs'].iterator;
    List files = new List();

    while (items.moveNext()) {
      if (items.current != null) files.add(items.current);
    }

    Iterator i = files.iterator;

    String pathBuilder(String parent){

      List fields = parent.split('/');
      String path = '';
      for (var j = 0; j < fields.length; j++) {
        if(j>6)
          path+=stringSplitter(fields[j], '.')+' / ';
      }
      return path;
    }

    while (i.moveNext()) {
      return new Column(children: <Widget>[
        new GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: new Text(
            pathBuilder(i.current['pathParent']),
            style: new TextStyle(fontWeight: FontWeight.bold, color: cAppBlue),
          ),
        ),
        new Divider(),
        new Expanded(
          child: new ListView.builder(
              itemCount: files.length,
              shrinkWrap: true,
              itemBuilder: (context, i) {
                if (files[i]['title'] != null) {
                  if (files[i]['directory']) {
                    return new ListTile(
                      dense: true,
                      title: new Text(files[i]['title']),
                      leading: new Icon(Icons.folder_open),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => new UcContent(
                                files[i], paeUser, school, course)));
                      },
                    );
                  } else
                    return new ListTile(
                      onTap: () async {
                        await getFiles(
                            session, files[i]['repositoryId'].toString());
                      },
                      // dense: true,
                      title: new Text(files[i]['title']),
                      leading: new Icon(Icons.description),
                    );
                } else
                  return new ListTile(
                    title: new Text('No title found'),
                  );
              }),
        ),
      ]);
    }
    return new Container();
  }
}
