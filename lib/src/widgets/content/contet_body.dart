import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:async_loader/async_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

import '../../blocs/bloc.dart';
import '../../blocs/bloc_provider.dart';
import '../../common/error401.dart';
import '../../common/permissions.dart';
import '../../common/slugify.dart';
import '../../common/themes/colorsThemes.dart';
import '../../common/widgets/dialog.dart';
import '../../common/widgets/list_item_builder.dart';
import '../../common/widgets/progress_indicator.dart';
import '../../common/widgets/trailing.dart';
import '../../common/widgets/trailing_cloud.dart';
import '../../common/widgets/trailing_remove_button.dart';
import '../../models/folders.dart';
import '../../screens/content.dart';
import '../../widgets/content/content_pathBuilder.dart';
//import 'package:slugify/slugify.dart';

class ContentBody extends StatefulWidget {
  final String course, school;
  final TapGestureRecognizer tapGestureRecognizer;
  final int id;

  ContentBody(
      {this.course, this.school, this.tapGestureRecognizer, this.id, Key key})
      : super(key: key);

  @override
  ContentBodyState createState() {
    return new ContentBodyState();
  }
}

class ContentBodyState extends State<ContentBody>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      final bloc = BlocProvider.of(context);
      bloc.onConnectionChange();
    });

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    super.initState();


    
  }

  @override
  Widget build(BuildContext context) {

    final bloc = BlocProvider.of(context);

    Error401 error401 = Error401();

    if (bloc.connectionStatus.contains('none') &&
        (bloc.sharedPrefs.get(widget.id.toString()) != null)) {
      bloc.sharedPrefs.getStringList(widget.id.toString());

      List newList = new List();
      bloc.sharedPrefs
          .getStringList(widget.id.toString())
          .forEach((value) => newList.add(jsonDecode(value)));

      return createList(newList, context, bloc);
    } else if (!bloc.connectionStatus.contains('none'))
      return new AsyncLoader(
          initState: () async => await bloc.courseUnitsFoldersContents(
              widget.id, bloc.paeUser.session),
          renderLoad: () => Center(child: AdaptiveProgressIndicator()),
          renderError: ([error]) {
            if (error == 401) error401.error401(context);

            return new Text('ERROR LOANDING DATA');
          },
          renderSuccess: ({data}) {
            List checker = data['response']['childs'];
            if (checker.isNotEmpty) {
              ///
              bloc.saveListLocally(
                  this.widget.id.toString(), checker, bloc.sharedPrefs);

              return createList(checker, context, bloc);
            } else
              return DialogAlert(message: 'Pasta vazia');
          });
    else
      return Center(
        child: Container(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Sem Informação Disponivel",
              textScaleFactor: 1.5,
            ),
          ],
        )),
      );
  }

  Widget createList(List courseUnitsContent, context, Bloc bloc) {
    Folders folder;
    Widget bodyList;
    String status = bloc.connectionStatus;

    bodyList = new Column(children: <Widget>[
      new ContentPathBuilder(
        tapGestureRecognizer: widget.tapGestureRecognizer,
        courseUnitsContent: courseUnitsContent,
      ),
      new Divider(),
      new Expanded(
        child: ListItemsBuilder<dynamic>(
          items: courseUnitsContent,
          itemBuilder: (context, items) {
            if (items['directory']) {
              //todo diretorias nao podem ser apagadas
              folder = Folders.fromJson(items);
              return new ListTile(
                  dense: true,
                  title: new Text(items['title']),
                  leading: new Icon(Icons.folder_open),
                  trailing: Trailing(
                      canAdd: items['clearances']['addFiles'],
                      folder: folder,
                      content: items,
                      parentId: widget.id),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => new Content(
                          unitContent: items,
                          course: widget.course,
                          school: widget.school))));
            } else {
              folder = bloc.sharedPrefs.getString("${items['title']}") ??
                  Folders.fromJson(items);
              return new ListTile(
                onTap: () async {
                  DevicePermissions permiss = DevicePermissions();
                  await permiss.checkWriteExternalStorage();
                  if (!bloc.connectionStatus.contains('none')) {
                    //todo verificar se o que vem do online tem data maior que a do offline, se sim perguntar ao user se quer a versao  do offline ou online, o mesmo  se passa
                    //todo quando  o user  mudou algo offline e quando for  online se for diferente perguntar
                    
                   /* Map jsonFile = jsonDecode(bloc.sharedPrefs.get(items['id'].toString()));
                    
                    if(jsonFile!= null)
                      if (jsonFile['dateSaveDate'] < items['dateSaveDate'] ||
                          jsonFile['dateUpdateDate'] < items['dateUpdateDate']){
                      
                        bloc.questionDialog("Deseja substituir o ficheiro ${items['title']} que tem disponivel offline?", context, );
                      }*/

                   //todo arranjar maneira de fazer refresh e ver se o conteudo foi mesmo modificado
                    //todo apenas mostar isto caso tenha permissao para enviar
                    File file = await bloc.getFiles(bloc.paeUser.session, items);
                    //todo a flag para dizer que algo tem data maior tem que ser posta tbm no caso de o ficheiro estar guardado local e o que  vem  online seja maior subistuir o local


                   await dialogOnlineModified(bloc, items, file, context);

                    if(items['clearances']['addFiles'])
                      await _dialogLocalFileModified(bloc, items, context, file);

                    print(file.path);
                    OpenFile.open(file.path);
                  } else {
                    //todo verificar se o ficheiro esta disponivel para abrir offline ou nao e usar uma flag como indicador de inco no trailing a indicar essa informaçao
                    //todo no caso de a pessoa editar o ficheiro,ver o last  modified e comparar com o local e alterar(caso esteja disponivel offline)
                    String dir = await bloc.buildFileDirectory(items['path']);

                    File file = new File('$dir/${items['title']}');

                    print(file.path);
                    OpenFile.open(file.path);
                  }
                },
                title: new Text(
                    items['title'] ?? items['repositoryFile4JsonView']['name']),
                leading: new Icon(Icons.description),
                trailing: status.contains('none')
                    ? SyncCloudOffline(content: items)
                    : canRemove(items),
              );
            }
          },
        ),
      ),
    ]);

    return bodyList;
  }


  Widget canRemove(items) {
    if(!items['clearances']['removeFiles'])
      return SyncCloudOffline(content: items);
    else
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SyncCloudOffline(
              controller: _controller, content: items),
          TrailingRemoveButton(
            controller: _controller,
              content: items,
              parentId: widget.id,
              canRemove: items['clearances']
              ['removeFiles']),
          _buildIconButton()
        ],
      );
  }

  IconButton _buildIconButton() {
    return IconButton(
        icon: AnimatedBuilder(
            animation: _controller.view,
            builder: (BuildContext context, Widget child) {
              return Transform(
                  alignment: FractionalOffset.center,
                  transform:
                  Matrix4.rotationZ(_controller.value * 0.5 * math.pi),
                  child: Icon(
                    _controller.isDismissed ? Icons.more_horiz : Icons.close,
                    color: _controller.isDismissed
                        ? Theme.of(context).accentColor
                        : Theme.of(context).errorColor,
                  ));
            }),
        onPressed: () {
          if (_controller.isDismissed) {
            _controller.forward();
          } else
            _controller.reverse();
        });
  }

  Future dialogOnlineModified(Bloc bloc, items, File file, BuildContext context) async {
      String dir = await bloc.buildFileDirectory(items['path']);

    if(FileSystemEntity.typeSync(dir) != FileSystemEntityType.NOT_FOUND) {

      DateTime dataModify = file.lastModifiedSync();
      //todo apagar prints
      print(dataModify.millisecondsSinceEpoch);
      print(items['dateSaveDate']);

      if (dataModify.millisecondsSinceEpoch < items['dateSaveDate'] ||
          dataModify.millisecondsSinceEpoch < items['dateUpdateDate']) {
        bloc.sharedPrefs.setBool("cloud/${items['path']}/${items['id']}", true);
        //todo mudar isto para o on tap no icon de alert
        questionOffOnFileDialog(
            "Deseja substituir o ficheiro ${items['title']} no dispositivo?", context, items, bloc, fileOnlineToOffline(bloc,file, items) );
      }
    }
  }

  Future _dialogLocalFileModified(Bloc bloc, items, BuildContext context, File file) async {


    String dir = await bloc.buildFileDirectory(items['path']);

    if(FileSystemEntity.typeSync(dir) != FileSystemEntityType.NOT_FOUND) {

      DateTime dataModify = file.lastModifiedSync();
      //todo apagar prints
      print(dataModify.millisecondsSinceEpoch);
      print(items['dateSaveDate']);

      if (dataModify.millisecondsSinceEpoch > items['dateSaveDate'] ||
          dataModify.millisecondsSinceEpoch > items['dateUpdateDate']) {
        bloc.sharedPrefs.setBool("cloud/${items['path']}/${items['id']}", true);
        //todo mudar isto para o on tap no icon de alert
        questionOffOnFileDialog(
            "Deseja substituir o ficheiro ${items['title']} no PAE?", context, items, bloc, fileOfflineToOnline(bloc, file, items));
      }
    }
  }

  ///
  Future fileOfflineToOnline(Bloc bloc, File localFile, items) async{
       bloc.uploadFile(localFile, bloc.paeUser.session).then((resp){

      Slugify slug = Slugify();

      Map object = {
        "@class": "pt.estgp.estgweb.domain.PageRepositoryFileImpl",
        "id": 0,
        "tempFile": resp['uploadedFiles'][0],
        "repositoryId": 0,
        "title": resp['uploadedFiles'][0]['fileName'],
        "slug": slug.slugGenerator(resp['uploadedFiles'][0]['fileName']),
        "repositoryFile4JsonView": null,
        "visible": true,
        "cols": 12
      };
      print(items);
      return bloc.editFile(object, items['id'], bloc.paeUser.session);
    });
  }


  Future fileOnlineToOffline(Bloc bloc, File file, items) async {

    File file = await bloc.getFiles(bloc.paeUser.session, items);

    print(file.path);
    bloc.sharedPrefs.remove(items['id'].toString());

    bloc.sharedPrefs.setString(items['id'].toString(), jsonEncode(items));
  }

  ///
  void questionOffOnFileDialog(String message, BuildContext context, items, Bloc bloc, Future function){

    showDialog(
        context: context,
        child: AlertDialog(
          title: Text(
            'IppDrive',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            message,
            textAlign: TextAlign.justify,
          ),
          actions: <Widget>[
            FlatButton(
                onPressed: () async {
                  await function;
                  bloc.sharedPrefs.setBool("cloud/${items['path']}/${items['id']}", false);
                  Navigator.pop(context);
                  Scaffold.of(context).showSnackBar(new SnackBar(
                      content: Text( "O ficheiro ${items['title']} substituido!",
                        style: TextStyle(color: cAppBlackish),
                      ),
                      duration: Duration(milliseconds: 1000),
                      backgroundColor: cAppYellowish));
                },
                child: Text('Sim'),
                color: cAppYellowish,
                shape: BeveledRectangleBorder(
                    borderRadius: new BorderRadius.circular(3.0))),
            FlatButton(
                onPressed: () {

                    Navigator.pop(context);
                  },
                child: Text('Nao'),
                color: cAppYellowish,
                shape: BeveledRectangleBorder(
                    borderRadius: new BorderRadius.circular(3.0)))
          ],
        ));
  }

}
