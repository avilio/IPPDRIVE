import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:async_loader/async_loader.dart';
import 'package:flutter/services.dart';
import 'package:ippdrive/common/list_item_builder.dart';
import 'package:ippdrive/favorites.dart';
import 'package:ippdrive/folders.dart';
import 'package:ippdrive/views/themes/colorsThemes.dart';

import 'package:ippdrive/security/verifications/display.dart';
import 'package:ippdrive/services/apiRequests.dart';
import 'package:ippdrive/drawer.dart';
import 'package:ippdrive/user.dart';
import 'package:share/share.dart';
import 'package:android_intent/android_intent.dart';

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
  TapGestureRecognizer _tapGestureRecognizer;
  List _listPath = List();

  @override
  void initState() {
    super.initState();
    _tapGestureRecognizer = new TapGestureRecognizer()
    ..onTap = _handlePress;
  }

  @override
  void dispose() {
    _tapGestureRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

   // print('DATA UC PAGE >>>>>>>>>>> ${widget.content['response'] ['childs']}');
    var bodyList = new AsyncLoader(
        initState: () async =>
        await request.courseUnitsFoldersContents(widget.content, widget.paeUser.session),
        renderLoad: () => Center(child: new CircularProgressIndicator()),
        renderError: ([error]) => new Text('ERROR LOANDING DATA'),
        renderSuccess: ({data}) {
          List checker = data['response']['childs'];
          if (checker.isNotEmpty)
            return createList(data, widget.paeUser,widget.school,widget.course,context,_tapGestureRecognizer, _listPath);
          else
           return buildDialog('Data is Empty', context);
        });
//todo arranjar maneira de nao voltar atras caso a rota anterior seja login page
    return new Scaffold(
        drawer: new MyDrawer(widget.paeUser,school: widget.school, course: widget.course,json: widget.content,),
        appBar: new AppBar(
          title: new Text(
            widget.content['title'].toString().split('-')[0],
            //textScaleFactor: 0.7,
            style: new TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: bodyList);
  }


  void _handlePress() {
    HapticFeedback.vibrate();
  }
}

Widget createList(response, paeUser, school, course, context, TapGestureRecognizer tapGestureRecognizer, List listPath) {
  Iterator items = response['response']['childs'].iterator;
  List files = new List();
  Requests req = Requests();
  Folders folder;
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
         TextSpan(text: pathBuilder(i.current, listPath),recognizer: tapGestureRecognizer ).text,
          style: new TextStyle(fontWeight: FontWeight.bold, color: cAppBlue),
        ),
      ),
      new Divider(),
      new Expanded(
        child: ListItemsBuilder<dynamic>(
          items: files,
          itemBuilder: (context, items){
            if (items['directory']) {
              folder = Folders.fromJson(items);
              return new ListTile(
                dense: true,
                title: new Text(items['title']),
                leading: new Icon(Icons.folder_open),
                trailing: trailing(folder, paeUser, items['clearances']['addFiles'],context),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                      new UcContent(items, paeUser, school, course)));
                },
              );
            } else
              return new ListTile(
                onTap: () async {
                  bool can = await req.checkPermissions();
                  print(can);
                    File file = await req.getFiles(paeUser.session, items);
                  print(file);
                /*  req.launchInBrowser(
                      paeUser.session, items['repositoryId'].toString());*/
                  //storage.writeFile(file);
                  //File file = await storage.downloadFile(url,files[i]['title']);
                  // print(file.path);
                  // final RenderBox box = context.findRenderObject();
/*                  if (Platform.isAndroid) {
                    AndroidIntent intent = new AndroidIntent(
                      action: 'action_view',
                      data: Uri.file(file).,
                    );
                    await intent.launch();
                  }
                  file.openSync(mode: FileMode.read);*/
                  //Share.share(file.readAsBytesSync().toString());
                  //var args = {'url': file.path};
                  //await platform.invokeMethod('viewPdf', args);
                },
                // dense: true,
                title: new Text(items['title'] ??
                    items['repositoryFile4JsonView']['name']),
                leading: new Icon(Icons.description),
              );
          },
        ),
        /*child: new ListView.builder(
            itemCount: files.length,
            shrinkWrap: true,
            itemBuilder: (context, i) {
              if (files[i]['directory']) {
                folder = Folders.fromJson(files[i]);
                return new ListTile(
                  dense: true,
                  title: new Text(files[i]['title']),
                  leading: new Icon(Icons.folder_open),
                  trailing: trailing(folder, paeUser, files[i]['clearances']['addFiles'],context),
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
            }),*/
      ),
    ]);
  }

  return bodyList;
}
//files[i]['title']['clearances']['addFiles']
Widget trailing(Folders folder, PaeUser paeUser,bool canAdd, BuildContext context){

  if(canAdd){
    return new Row(mainAxisSize: MainAxisSize.min,children: <Widget>[new IconButton(onPressed: (){
      print("ADD FILE");
      showDialog(context: context,child: buildDialog('TESTE ADD FILE BUTTON',context));
    } ,icon: Icon(Icons.add),),new Favorites(folder, paeUser) ]);
  }
  else
    return new Favorites(folder, paeUser);


}

String pathBuilder(Map parent,List listPath) {
  print(parent);
  parent['pathParent'];
  if (parent != null) {

    if ( parent['pathParent'].split('/').length > 7) {
      List fields =  parent['pathParent'].split('/');
      String path = '';
      for (var j = 7; j < fields.length; j++) {
         path += stringSplitter(fields[j], '.') + ' / ';
      }
      listPath.add(parent);
      return path;
    }else{
      List fields =  parent['pathParent'].split('/');
      String path = '';
      for (var j = 0; j < fields.length; j++) {
       path += stringSplitter(fields[j], '.') + ' / ';
      }
      print(path);
      listPath.add(parent);
      return path;
    }
  }
  return "";
}

