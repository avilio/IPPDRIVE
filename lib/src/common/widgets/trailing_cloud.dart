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

  SyncCloudOffline({this.controller, this.content});

  @override
  _SyncCloudOfflineState createState() => _SyncCloudOfflineState();
}

class _SyncCloudOfflineState extends State<SyncCloudOffline> {
  bool _cloudFlag = false;
  bool _isModified = false;
  String connectStatus = "";

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      final bloc = BlocProvider.of(context);

      setState(() {
        _cloudFlag = bloc.sharedPrefs.getBool(
                "cloud/${widget.content['path']}/${widget.content['title']}") ??
            false;
        _isModified = bloc.sharedPrefs.getBool("cloud/${widget.content['path']}/${widget.content['id']}") ?? false;
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
      //todo caso o offline seja mais recente fazer o tap no botao para enviar para o online
      if (_isModified)
        return Icon(Icons.warning, color: cAppYellowish);
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
      if (!_cloudFlag)
        await _cloudAddOfflineDialog(bloc, bloc.sharedPrefs);
      else
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

    print(file.path);
    setState(() {
      _cloudFlag = true;
    });
    sharedPreferences.setBool(
        "cloud/${widget.content['path']}/${widget.content['title']}",
        _cloudFlag);

    bloc.sharedPrefs.setString(
        widget.content['id'].toString(), jsonEncode(widget.content));

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

    File file =
        await File('$dir/${widget.content['title']}').delete(recursive: true);

    print(file.path + " deleted");
    setState(() {
      _cloudFlag = false;
    });
    sharedPreferences.setBool(
        "cloud/${widget.content['path']}/${widget.content['title']}",
        _cloudFlag);

    bloc.sharedPrefs.remove(widget.content['id'].toString());

    Scaffold.of(context).showSnackBar(new SnackBar(
        content: Text('Ficheiro ${widget.content['title']} apagado!',
            style: TextStyle(color: cAppBlackish)),
        duration: Duration(milliseconds: 1000),
        backgroundColor: cAppYellowish));
  }
}
