
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../common/permissions.dart';
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


  void _onTap()async {
    DevicePermissions permissions = DevicePermissions();
   // await permissions.checkWriteExternalStorage();
   // print((await getExternalStorageDirectory()).path);
    //print((await getApplicationDocumentsDirectory()).path);
    //print(widget.folders.path.substring(5));
    String direct = (await getExternalStorageDirectory()).path +widget.folders.path;
  //  print(direct);

   Directory directory =  await Directory(direct).create(recursive: true);


    print(directory.path);

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
            icon: Icon(Icons.cloud_off), onPressed: _onTap),
        alignment: FractionalOffset.center,
      ),
    );
  }
}
