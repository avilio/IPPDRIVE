
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/permissions.dart';
import '../../common/themes/colorsThemes.dart';
import '../../models/folders.dart';


class SyncCloudOffline extends StatefulWidget {

  final AnimationController controller;
  final Map content;
  final Folders folders;

  SyncCloudOffline({this.controller, this.content,this.folders});

  @override
  _SyncCloudOfflineState createState() => _SyncCloudOfflineState();
}

class _SyncCloudOfflineState extends State<SyncCloudOffline> {

  bool _cloudFlag = false;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((sharedPreferences){
      setState(() {
        _cloudFlag = sharedPreferences.getBool("cloud/${widget.folders.title}") ?? false;
      });
    });
  }

  void _onTap()async {
    DevicePermissions permissions = DevicePermissions();
   // await permissions.checkWriteExternalStorage();
   // print((await getExternalStorageDirectory()).path);
    //print((await getApplicationDocumentsDirectory()).path);
    //print(widget.folders.path.substring(5));
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    //todo ja cria e apaga da root do telemovel ainda nao sei se cria o ficheiros mesmo mas em principio sim, falta é criar a view para essa diretoria recursiva
    if(!_cloudFlag) {
      String direct = (await getExternalStorageDirectory()).path +
          widget.folders.path;
    Directory directory = await Directory(direct).create(recursive: true);
      print(directory.path);
      setState(() {
        _cloudFlag = true;
      });
      sharedPreferences.setBool("cloud/${widget.folders.title}", _cloudFlag);

    }
    else
      new Future.delayed(Duration.zero, (){
        showDialog(context: context,
          builder: (context)=>AlertDialog(
            title: Text(
              'IppDrive',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Text(
              'Tem a certeza que que deixar de ver o conteudo offline??',
              textAlign: TextAlign.justify,
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () async{
                    String direct = (await getExternalStorageDirectory()).path +
                    widget.folders.path;
                    Directory directory = await Directory(direct).delete(recursive: true);
                    print(directory.path + "deleted");
                    setState(() {
                      _cloudFlag = false;
                    });

                    sharedPreferences.setBool("cloud/${widget.folders.title}", _cloudFlag);
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
      });

   // print(widget.content['path']);
  }


  @override
  Widget build(BuildContext context) {

    return Container(
      child: ScaleTransition(
        scale: CurvedAnimation(
            parent: widget.controller.view,
            curve: Interval(0.0, 1.0, curve: Curves.easeOut)),
        child: IconButton(
            icon: _cloudFlag ? Icon(Icons.cloud) :Icon(Icons.cloud_off),
            onPressed: _onTap),
        alignment: FractionalOffset.center,
      ),
    );

  }
}
