
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((sharedPreferences){
      setState(() {
        _cloudFlag = sharedPreferences.getBool("cloud/${widget.content['path']}/${widget.content['title']}") ?? false;
      });
    });
  }

  void _onTap()async {
    DevicePermissions permiss = DevicePermissions();
     await permiss.checkWriteExternalStorage();
     await _online();
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

  Future _online() async {
    new Future.delayed(Duration.zero, ()  async  {

      final bloc = BlocProvider.of(context);

      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

      if(!_cloudFlag) {

        String direct = await bloc.buildFileDirectory(widget.content['path']);

        File file = await  bloc.getFiles(bloc.paeUser.session, widget.content);

        //todo  o  wirte  do  file  mesmo em bytes
        print(file.path);
        setState(() {
          _cloudFlag = true;
        });
        sharedPreferences.setBool("cloud/${widget.content['path']}/${widget.content['title']}", _cloudFlag);

      }
      else
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

                      String dir = await bloc.buildFileDirectory(widget.content['path']);

                      File file = await File('$dir/${widget.content['title']}').delete(recursive: true);

                      print(file.path + "deleted");
                      setState(() {
                        _cloudFlag = false;
                      });
                      sharedPreferences.setBool("cloud/${widget.content['path']}/${widget.content['title']}", _cloudFlag);
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
  }

}
