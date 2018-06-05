import 'package:async_loader/async_loader.dart';
import 'package:flutter/material.dart';
import 'package:ippdrive/Services/requestsAPI/requestsPhases.dart';
import 'package:ippdrive/pages/layouts/components/drawer.dart';
import 'package:ippdrive/pages/themes/colorsThemes.dart';
import 'package:ippdrive/user.dart';

class UcContent extends StatefulWidget {
  final Map content;
  final PaeUser paeUser;
  final String school;
  final String course;
  UcContent([this.content, this.paeUser,this.school,this.course]);

  @override
  State<StatefulWidget> createState() =>
      new UcContentState(content, paeUser,school,course);
}

class UcContentState extends State<UcContent> {
  Map content;
  PaeUser paeUser;
  String school;
  String course;

  UcContentState([this.content, this.paeUser,this.school,this.course]);

  @override
  Widget build(BuildContext context) {
    var bList = new AsyncLoader(
        initState: () async => await courseUnitsContents(content, paeUser.session),
        renderLoad: () => new CircularProgressIndicator(),
        renderError: ([error]) => new Text('ERROR LOANDING DATA'),
        renderSuccess: ({data}) {
          List a =data['response']['childs'];
          print(data['response']['childs']);
          if(a.isNotEmpty)
            return createList(data, paeUser.session);
          else
            return new ListTile(
              title: new Text('Data is Empty'),
            ); //todo incluir na funçao de construçao da path
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
        body:  bList);
  }

  Widget createList(Map response, session) {
    Iterator items = response['response']['childs'].iterator;
    List files = new List();

    while (items.moveNext()) {
      // print(items.current);
      if (items.current != null) files.add(items.current);
    }
    Iterator i = files.iterator;
    while (i.moveNext()) {
      return new Column(
          children: <Widget>[
        new GestureDetector(
          onTap: ()=> Navigator.of(context).pop(),
          child: new Text(
            //todo arranjar maneira de mostrar o path bem, funçao para tratar disto
            i.current['pathParent'].toString().substring(76),
            style:  new TextStyle(fontWeight: FontWeight.bold,
                color: cAppBlue),
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
                            builder: (context) =>
                                new UcContent(files[i] ,paeUser, school, course)));
                      },
                    );
                  } else
                    return new ListTile(
                      onTap: () async {
                       // print(files[i]['repositoryId']);
                          await getFiles(session,files[i]['repositoryId'].toString());
                          //print(resp);
                        },
                      // dense: true,
                      //todo ficha curricular e sumarios arrasa
                      title: new Text(files[i]['title']),
                      leading: new Icon(Icons.description),
                    );
                }
                else
                  return new ListTile(
                    title:  new Text('No title found' ),
                  );
              }),
        ),
      ]);
    }
    return new Container();
  }
}
