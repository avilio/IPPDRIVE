import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../blocs/bloc.dart';
import '../../blocs/bloc_provider.dart';
import '../../common/permissions.dart';
import '../../common/themes/colorsThemes.dart';

class SyncCloudOffline extends StatefulWidget {
  final AnimationController controller;
  final Map content;
  final int parentId;

  SyncCloudOffline({this.controller, this.content, this.parentId});

  @override
  _SyncCloudOfflineState createState() => _SyncCloudOfflineState();
}

class _SyncCloudOfflineState extends State<SyncCloudOffline> {
  bool _cloudFlag = false;
  bool _isModified = false;
  bool _isNew = false;
  bool _isLocalBigger = false;
  String connectStatus = "";

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      final bloc = BlocProvider.of(context);

      bloc.checkOnlineIsGreaterThanLocal(widget.content, context);
      print(widget.content['path']);

      setState(() {
        _cloudFlag = bloc.sharedPrefs.getBool("cloud/${widget.content['path']}/${widget.content['title']}") ?? false;
        _isModified = bloc.sharedPrefs.getBool("isModify/${widget.content['path']}/${widget.content['id']}") ?? false;
        _isNew = bloc.sharedPrefs.getBool("newFile/${widget.content['id']}")  ??  false;
        _isLocalBigger = bloc.sharedPrefs.get("localFile/${widget.content['path']}/${widget.content['id']}") ?? false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of(context);

    bloc.onConnectionChange();
    setState(() {
      connectStatus = bloc.connectionStatus;
    });

    Widget cloud = widget.controller != null
        ? Container(
            child: ScaleTransition(
              scale: CurvedAnimation(
                  parent: widget.controller.view,
                  curve: Interval(0.0, 1.0, curve: Curves.easeOut)),
              child: IconButton(
                  icon: iconBuilder(connectStatus), onPressed: _onTap),
              alignment: FractionalOffset.center,
            ),
          )
        : IconButton(icon: iconBuilder(connectStatus), onPressed: _onTap);

    return cloud;
  }

  Icon iconBuilder(String connectStatus) {

    if (_cloudFlag) {
      if (_isModified)
        return Icon(Icons.warning, color: cAppYellowish);
      if(_isLocalBigger)
        //return Icon(Icons.warning, color: cAppYellowish)
        return Icon(Icons.cloud_upload, color: cAppYellowish);
      else
        return connectStatus.contains('none')
            ? Icon(Icons.cloud,color: Colors.green,)
            : Icon(Icons.cloud_done);
    } else
      return connectStatus.contains('none')
          ? Icon(Icons.cloud_off,color: Colors.red, )
          : Icon(Icons.cloud_download);
  }

  ///
  void _onTap() async {
    DevicePermissions permiss = DevicePermissions();
    await permiss.checkWriteExternalStorage();

    await _onOrOff();
  }

  ///
  Future _onOrOff() async {
    final bloc = BlocProvider.of(context);

    if (!bloc.connectionStatus.contains('none')) {
      if (!_cloudFlag) {
        await _addFilesToOffline(bloc, bloc.sharedPrefs);
      //await _cloudAddOfflineDialog(bloc, bloc.sharedPrefs);
        if (_isNew || _isLocalBigger) {
        questionOffOnFileDialog(
            "Este ficheiro é recente.\nDeseja fazer upload do ficheiro ${widget
                .content['title']} para o PAE?", context, widget.content, bloc,
            bloc.fileOfflineToOnline(bloc, widget.content));
      }
      else if (_isModified) {
        questionOffOnFileDialog(
            "Deseja substituir o ficheiro ${widget.content['title']}", context,
            widget.content, bloc,
            bloc.fileOnlineToOffline(bloc, widget.content));
      }
    }else
        await _cloudDeleteOfflineDialog(bloc, bloc.sharedPrefs);
    }
  }

  ///
  Future _cloudAddOfflineDialog(
      Bloc bloc, SharedPreferences sharedPreferences) async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                'IppDrive',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Text(
                'Tem a certeza que quer ver o conteudo offline??',
                textAlign: TextAlign.justify,
              ),
              actions: <Widget>[
                FlatButton(
                    onPressed: () async {
                      await _addFilesToOffline(bloc, sharedPreferences);
                      Navigator.pop(context);
                    },
                    child: Text('Sim'),
                    color: cAppYellowish,
                    shape: BeveledRectangleBorder(
                        borderRadius: new BorderRadius.circular(3.0))),
                FlatButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Nao'),
                    color: cAppYellowish,
                    shape: BeveledRectangleBorder(
                        borderRadius: new BorderRadius.circular(3.0)))
              ],
            ));
  }

  ///
  Future _cloudDeleteOfflineDialog(
      Bloc bloc, SharedPreferences sharedPreferences) async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                'IppDrive',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Text(
                'Tem a certeza que quer deixar de ver o conteudo offline??',
                textAlign: TextAlign.justify,
              ),
              actions: <Widget>[
                FlatButton(
                    onPressed: () async {
                      await _deleteFilesFromOffline(bloc, sharedPreferences);
                      Navigator.pop(context);
                    },
                    child: Text('Sim'),
                    color: cAppYellowish,
                    shape: BeveledRectangleBorder(
                        borderRadius: new BorderRadius.circular(3.0))),
                FlatButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Nao'),
                    color: cAppYellowish,
                    shape: BeveledRectangleBorder(
                        borderRadius: new BorderRadius.circular(3.0)))
              ],
            ));
  }

  ///
  Future _addFilesToOffline(
      Bloc bloc, SharedPreferences sharedPreferences) async {
    File file = await bloc.getFiles(bloc.paeUser.session, widget.content);

    setState(() {
      _cloudFlag = true;
    });

    Map local =jsonDecode(sharedPreferences.get("${widget.content['path']}/${widget.content['title']}"));

    local['dateUpdateDate'] =file.lastModifiedSync().millisecondsSinceEpoch;
    //todo apagar
    print("JSON ${local['dateUpdateDate']}  -> LOCAL ${file.lastModifiedSync().millisecondsSinceEpoch};");

    sharedPreferences.remove("${widget.content['path']}/${widget.content['title']}");
    sharedPreferences.setString("${widget.content['path']}/${widget.content['title']}", jsonEncode(local));

    sharedPreferences.setBool(
        "cloud/${widget.content['path']}/${widget.content['title']}",
        _cloudFlag);

    Scaffold.of(context).showSnackBar(new SnackBar(
        content: Text(
          'Ficheiro ${widget.content['title']} adicionado!',
          style: TextStyle(color: cAppBlackish),
        ),
        duration: Duration(milliseconds: 1000),
        backgroundColor: cAppYellowish));
  }

  ///
  Future _deleteFilesFromOffline(
      Bloc bloc, SharedPreferences sharedPreferences) async {
    String dir = await bloc.buildFileDirectory(widget.content['path']);

    File file = await new File('$dir/${widget.content['title']}').delete(recursive: true);


    print(file.path + " deleted");
    setState(() {
      _cloudFlag = false;
    });

    bloc.sharedPrefs.setBool("cloud/${widget.content['path']}/${widget.content['title']}", _cloudFlag);
    bloc.sharedPrefs.remove("cloud/${widget.content['path']}/${widget.content['title']}");

    Scaffold.of(context).showSnackBar(new SnackBar(
        content: Text('Ficheiro ${widget.content['title']} apagado!',
            style: TextStyle(color: cAppBlackish)),
        duration: Duration(milliseconds: 1000),
        backgroundColor: cAppYellowish));
  }

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
                  if(_isNew && _isModified) {
                    setState(() {
                      _isNew = false;
                      _isModified = false;
                    });
                    bloc.sharedPrefs.remove(
                        "isModify/${items['path']}/${items['id']}");
                    bloc.sharedPrefs.remove("newFile/${items['id']}");
                  }
                  if(_isLocalBigger) {
                    setState(() {
                      _isLocalBigger = false;
                    });
                    bloc.sharedPrefs.remove("localFile/${widget.content['path']}/${widget.content['id']}");
                  }
                  Navigator.pop(context);
                  Scaffold.of(context).showSnackBar(new SnackBar(
                      content: Text( "O ficheiro ${items['title']} adicionado!",
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
