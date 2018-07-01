import 'package:flutter/material.dart';
import 'package:ippdrive/common/list_item_builder.dart';
import 'package:ippdrive/common/semesters_item_builder.dart';
import 'package:ippdrive/folders.dart';
import 'package:ippdrive/drawer.dart';

import 'package:ippdrive/views/themes/colorsThemes.dart';
import 'package:ippdrive/views/ucContentPage.dart';
import 'package:ippdrive/user.dart';

class HomePage extends StatelessWidget {
  final Map json;
  final PaeUser paeUser;
  HomePage([this.json, this.paeUser, Key key]) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List list = json['response']['childs'];
    print(json['response']);

    if(list.length>1) {
      return discentesDocentes(list, context);
    }else
      return funcionarios(list, context);
  }

  ///
  Widget myExpandTile(List list, BuildContext context,) {

    String title;

    if(list[0]['indexInParent'] != 0) {
      title = list[0]['courseUnitsList'][0]['semestre'] == "S1"
          ? 'Semestre 1'
          : 'Semestre 2';
    }

    return new ExpansionTile(
      // leading: new Icon(Icons.list),
      title: new Text(
        title ?? 'ROOT',
        textScaleFactor: 1.5,
      ),
      children: list.map((val) {
        Folders folder = Folders.fromJson(val);
        return new ListTile(
          title: Container(
            decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
                //  borderRadius: new BorderRadius.circular(50.0),
                border:
                Border.all(style: BorderStyle.solid, color: cAppBlackish),
                color: cAppBlueAccent),
            child: new ListTile(
              trailing: trailing(
                  folder, paeUser, val['clearances']['addFiles'], context),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                  new UcContent(val, paeUser, '', ''))),
              title: new Text(val['title'].toString().split('-')[0],
                  textScaleFactor: 0.95),
            ),
          ),
        );
      }).toList(),
    );
  }
  ///
  Widget discentesDocentes(List list, BuildContext context) {
    var semestres = SemestersBuilder.fromList2List(list);
    //semestres.fromResponse2Lists();

    return WillPopScope(
        onWillPop: () async => false,
        child: new Scaffold(
          drawer: new MyDrawer(paeUser, json: json['response']),
          appBar: new AppBar(
            title: new Text(
              'Unidades Curricuares ${list[0]['path'].split('/')[6]
                  .toString()
                  .split('.')[1]}',
              //textScaleFactor: 1.5,
              style: new TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: SingleChildScrollView(
            child: Wrap(
              runSpacing: 8.0,
              children: <Widget>[
                new Padding(padding: EdgeInsets.all(1.0)),
                new Container(
                    decoration: new BoxDecoration(
                      shape: BoxShape.rectangle,
                      //  borderRadius: new BorderRadius.only(topRight:Radius.circular(20.0),bottomLeft: Radius.circular(20.0)),
                      border: Border.all(
                          style: BorderStyle.solid, color: cAppBlackish),
                      //  color: cAppBlue
                    ),
                    child: myExpandTile(
                        semestres.semester1, context)),
                // new Padding(padding: EdgeInsets.all(1.0)),
                new Container(
                    decoration: new BoxDecoration(
                      shape: BoxShape.rectangle,
                      // borderRadius: new BorderRadius.only(topRight:Radius.circular(20.0),bottomLeft: Radius.circular(20.0)),
                      border: Border.all(
                          style: BorderStyle.solid, color: cAppBlackish),
                    ),
                    child: myExpandTile(
                        semestres.semester2, context))
              ],
            ),
          ),
        )
      // body: semestres(list, context, school, course)),
    );
  }
  ///
  Widget funcionarios(List list, BuildContext context){
    return WillPopScope(
        onWillPop: () async => false,
        child: new Scaffold(
          drawer: new MyDrawer(paeUser, json: json['response'], course: 'Funcionario/a', school: '',),
          appBar: new AppBar(
            title: new Text(
              /* '${list[0]['pathParent']
                  .toString().split('/')[1].toUpperCase()}',*/
              '${list[0]['title']}',
              //textScaleFactor: 1.5,
              style: new TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: SingleChildScrollView(
            child: Wrap(
              runSpacing: 8.0,
              children: <Widget>[
                new Padding(padding: EdgeInsets.all(1.0)),
                new Container(
                    decoration: new BoxDecoration(
                      shape: BoxShape.rectangle,
                      //  borderRadius: new BorderRadius.only(topRight:Radius.circular(20.0),bottomLeft: Radius.circular(20.0)),
                      border: Border.all(
                          style: BorderStyle.solid, color: cAppBlackish),
                      //  color: cAppBlue
                    ),
                    child: myExpandTile(
                        list, context)),
                // new Padding(padding: EdgeInsets.all(1.0)),
              ],
            ),
          ),
        )
      // body: semestres(list, context, school, course)),
    );

  }

}
