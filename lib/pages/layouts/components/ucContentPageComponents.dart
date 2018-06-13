

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ippdrive/fileStorage.dart';
import 'package:ippdrive/pages/layouts/components/favorites.dart';
import 'package:ippdrive/pages/themes/colorsThemes.dart';
import 'package:ippdrive/pages/ucContentPage.dart';
import 'package:ippdrive/security/verifications/display.dart';
import 'package:ippdrive/services/requestsAPI/requestsPhases.dart';
import 'package:path_provider/path_provider.dart';



Widget createList(response, paeUser, school, course,context) {
  Iterator items = response['response']['childs'].iterator;
  List files = new List();
  Requests req = Requests();
  FileStorage storage = FileStorage();

  while (items.moveNext()) {
    if (items.current != null) files.add(items.current);
  }

  Iterator i = files.iterator;
  Widget bodyList;

  while (i.moveNext()) {
   bodyList = new Column(children: <Widget>[
      new GestureDetector(
        //todo criar uma lista no onTap das directory's adicionar as paginas da rota para tentar ao clickar no path ir para o ligar especifico
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
                    trailing: new Favorite(files[i]['id'], paeUser.session),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => new UcContent(
                              files[i], paeUser, school, course)));
                    },
                  );
                } else
                  return new ListTile(
                    onTap: () async {
                      var resp = await req.getFiles(
                          paeUser.session, files[i]['repositoryId'].toString());
                      print(files[i]['title']);
                      print(files[i]['path']);
                      File file = new File.fromRawPath(resp);
                      print("FILE ------------"+ file.path);
                      storage.writeFile(file);
                      
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

  return bodyList;
}





String pathBuilder(String parent){

  List fields = parent.split('/');
  String path = '';
  for (var j = 0; j < fields.length; j++) {
    if(j>6)
      path+=stringSplitter(fields[j], '.')+' / ';
  }
  return path;
}