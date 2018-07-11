import 'dart:convert';
import 'dart:io';

import 'package:async_loader/async_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:documents_picker/documents_picker.dart';

import '../../blocs/home_bloc.dart';
import '../themes/colorsThemes.dart';
import '../permissions.dart';
import '../error401.dart';
import '../../resources/apiCalls.dart';
import '../../blocs/home_provider.dart';
import '../../common/widgets/progress_indicator.dart';
import '../slugify.dart';
import '../../models/folders.dart';
import '../../screens/content.dart';

class ManageFiles extends StatefulWidget {
  final Map content;
  final AnimationController controller;
  final int parentId;

  ManageFiles({this.content, this.controller, this.parentId});

  @override
  _ManageFilesState createState() => _ManageFilesState();
}

class _ManageFilesState extends State<ManageFiles> {
  _filePicker(String session) async {
    List<dynamic> docPaths;

    try {
      docPaths = await DocumentsPicker.pickDocuments;
    } on PlatformException {
      print(PlatformException);
    }
    if (!mounted) return;

    File file;
    docPaths.forEach((data) => file = File(data));

    print(file.path.split("/").last);
    Requests request = Requests();

    Map response = await request.uploadFile(file, session).then((resp) {
      Slugify slug = Slugify();
      //print(slug.slugGenerator(file.path.split("/").last));
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
      return request.addFile(object, widget.content['id'], session);
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Content(
                  unitContent: widget.content,
                )));
    //response.forEach((a, b) => debugPrint('$a : $b'));
  }

  _openFilePicker(BuildContext context) {
    final homeBloc = HomeProvider.of(context);

    if(homeBloc.connectionStatus.contains('none'))
      homeBloc.errorDialog("Sem acesso a Internet", context);
    else {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(50.0),
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _addField(homeBloc),
                    SizedBox(
                      height: 5.0,
                    ),
                    _removeField(homeBloc)
                  ],
                ),
              ],
            );
          });
    }
  }

  Widget _addField(HomeBloc homeBloc) {
    return Container(
      decoration:
          new BoxDecoration(color: cAppBlueAccent, border: Border.all()),
      alignment: FractionalOffset.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            child: Text('Adicionar Ficheiro',
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                softWrap: true),
            onTap: () async {
              DevicePermissions permiss = DevicePermissions();
              bool permit = false;
              permit = await permiss.checkWriteExternalStorage();
              _filePicker(homeBloc.paeUser.session);
            },
          ),
          FloatingActionButton(
            onPressed: () async {
              DevicePermissions permiss = DevicePermissions();
              bool permit = false;
              permit = await permiss.checkWriteExternalStorage();
              // print(permit);
              _filePicker(homeBloc.paeUser.session);
            },
            backgroundColor: Theme.of(context).buttonColor,
            foregroundColor: Theme.of(context).accentColor,
            shape: OutlineInputBorder(
                borderSide: BorderSide(),
                borderRadius: BorderRadius.circular(10.0)),
            materialTapTargetSize: MaterialTapTargetSize.padded,
            child: Icon(
              Icons.add,
              color: Colors.green,
            ),
            mini: true,
            elevation: 0.0,
            heroTag: "Add",
          )
        ],
      ),
    );
  }

  Widget _removeField(HomeBloc homeBloc) {
    return Container(
      decoration:
          new BoxDecoration(color: cAppBlueAccent, border: Border.all()),
      alignment: FractionalOffset.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            child: Text('Remover Ficheiro',
                style: TextStyle(
                    color: Colors.redAccent, fontWeight: FontWeight.bold),
                softWrap: true),
            onTap: () async {
              DevicePermissions permiss = DevicePermissions();
              bool permit = false;
              permit = await permiss.checkWriteExternalStorage();
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Icon(
                          Icons.info,
                          color: Colors.yellow,
                        ),
                        content:
                            Text("Tem a certeza que quer apagar o ficheiro?"),
                        actions: <Widget>[
                          FlatButton(
                              onPressed: () {
                                homeBloc
                                    .removeFile(
                                        widget.content,
                                        widget.parentId,
                                        homeBloc.paeUser.session)
                                    .then((resp) {
                                    resp.forEach((a,b)=>print);
                                  Navigator.pop(context);
                                });
                              },
                              child: Text('Sim')),
                          FlatButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Nao')),
                        ],
                      ));
            },
          ),
          FloatingActionButton(
            onPressed: () async {
              DevicePermissions permiss = DevicePermissions();
              bool permit = false;
              permit = await permiss.checkWriteExternalStorage();
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Icon(
                          Icons.info,
                          color: Colors.yellow,
                        ),
                        content:
                            Text("Tem a certeza que quer apagar o ficheiro?"),
                        actions: <Widget>[
                          FlatButton(
                              onPressed: () {
                                homeBloc
                                    .removeFile(
                                        widget.content,
                                        widget.parentId,
                                        homeBloc.paeUser.session)
                                    .then((resp) {
                                   print(resp);
                                  Navigator.pop(context);
                                });
                              },
                              child: Text('Sim')),
                          FlatButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Nao')),
                        ],
                      ));
            },
            backgroundColor: Theme.of(context).buttonColor,
            foregroundColor: Theme.of(context).accentColor,
            shape: OutlineInputBorder(
                borderSide: BorderSide(),
                borderRadius: BorderRadius.circular(10.0)),
            materialTapTargetSize: MaterialTapTargetSize.padded,
            child: Icon(
              Icons.remove,
              color: Colors.redAccent,
            ),
            mini: true,
            elevation: 0.0,
            heroTag: "Remove",
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ScaleTransition(
        scale: CurvedAnimation(
            parent: widget.controller,
            curve: Interval(0.0, 1.0, curve: Curves.easeOut)),
        child: new IconButton(
          onPressed: () async {
            _openFilePicker(context);

            //showDialog(context: context,child: buildDialog('TESTE ADD FILE BUTTON',context));
          },
          icon: Icon(Icons.edit),
        ),
        alignment: FractionalOffset.center,
      ),
    );
  }
}
