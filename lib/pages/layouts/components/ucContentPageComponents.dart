import 'package:flutter/material.dart';

//import 'package:ippdrive/fileStorage.dart';
import 'package:ippdrive/favorites.dart';
import 'package:ippdrive/pages/themes/colorsThemes.dart';
import 'package:ippdrive/pages/ucContentPage.dart';
import 'package:ippdrive/security/verifications/display.dart';
import 'package:ippdrive/services/requestsAPI/apiRequests.dart';

//const platform = const MethodChannel('com.example.ippdrive/pdfViewer');

Widget createList(response, paeUser, school, course, context) {
  Iterator items = response['response']['childs'].iterator;
  List files = new List();
  Requests req = Requests();
 // FileStorage storage = FileStorage();

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
              //print(files[i]['title']);
              files[i].forEach(
                  (a,b){
                    print("$a : $b ");
                  }
              );
              if (files[i]['directory']) {
                return new ListTile(
                  dense: true,
                  title: new Text(files[i]['title']),
                  leading: new Icon(Icons.folder_open),
                  trailing: new Favorites(files[i]['id'], paeUser),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            new UcContent(files[i], paeUser, school, course)));
                  },
                );
              } else
                return new ListTile(
                  onTap: () async {
                    // var resp = await req.getFiles(
                    //    paeUser.session, files[i]['repositoryId'].toString());
                    //  print('RESP _>>>  $resp');
                    //var url = 'http://10.0.2.2:8080/baco/repositoryStream/${files[i]['repositoryId'].toString()}?BACOSESS=${paeUser.session}';
                    req.launchInBrowser(
                        paeUser.session, files[i]['repositoryId'].toString());
                    // print(files[i]['title']);
                    // print(files[i]['path']);
                    // File file = new File.fromRawPath(resp);
                    //print("FILE ------------"+ file.path);
                    //storage.writeFile(file);
                    //File file = await storage.downloadFile(url,files[i]['title']);
                    // print(file.path);
                    // final RenderBox box = context.findRenderObject();
                    // Share.share(file.readAsStringSync().toString());
                    //var args = {'url': file.path};
                    //await platform.invokeMethod('viewPdf', args);
                  },
                  // dense: true,
                  title: new Text(files[i]['title'] ??
                      files[i]['repositoryFile4JsonView']['name']),
                  leading: new Icon(Icons.description),
                );
            }),
      ),
    ]);
  }

  return bodyList;
}

String pathBuilder(String parent) {
  List fields = parent.split('/');
  String path = '';
  for (var j = 0; j < fields.length; j++) {
    if (j > 6) path += stringSplitter(fields[j], '.') + ' / ';
  }
  return path;
}
