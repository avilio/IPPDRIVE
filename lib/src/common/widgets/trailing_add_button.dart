
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:documents_picker/documents_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../blocs/bloc.dart';
import '../../blocs/bloc_provider.dart';
import '../../common/permissions.dart';
import '../../common/slugify.dart';
import '../../resources/apiCalls.dart';
import '../permissions.dart';


class TrailingAddButton extends StatefulWidget {
  final Map content;
  final AnimationController controller;

  TrailingAddButton({this.content, this.controller});

  @override
  TrailingAddButtonState createState() {
    return new TrailingAddButtonState();
  }
}

class TrailingAddButtonState extends State<TrailingAddButton> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async
    {
      final bloc = BlocProvider.of(context);
      bloc.onConnectionChange();
      DevicePermissions permiss = DevicePermissions();
      await permiss.checkWriteExternalStorage();
    });
  }

  @override
  Widget build(BuildContext context) {
  final bloc = BlocProvider.of(context);

  return  Container(
    child: ScaleTransition(
      scale: CurvedAnimation(
          parent: widget.controller.view,
          curve: Interval(0.0, 1.0, curve: Curves.easeOut)),
      child:  IconButton(
        onPressed: () async {
          DevicePermissions permiss = DevicePermissions();
          bool permit = false;
          permit = await permiss.checkWriteExternalStorage();
          _filePicker(bloc);
        },
        icon: Icon(
          Icons.add,
          color: Colors.green,
        ),
      ),
      alignment: FractionalOffset.center,
    ),
  );
/*
   return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            onPressed: () async {
              DevicePermissions permiss = DevicePermissions();
              bool permit = false;
              permit = await permiss.checkWriteExternalStorage();
              _filePicker(bloc);
            },
            icon: Icon(
              Icons.add,
              color: Colors.green,
            ),
          )
        ],
    );*/
}

   _filePicker(Bloc bloc) async {
     List<dynamic> docPaths;

     try {
       docPaths = await DocumentsPicker.pickDocuments;
     } on PlatformException {
       print(PlatformException);
     }
     if (!mounted) return;

     File file;

     docPaths.forEach((data) async {
       file = File(data);

       //todo fazer caso offline
       if (!bloc.connectionStatus.contains('none'))
         await _addFilesOnline(file, bloc);
       else
         await _addFilesOffline(file, bloc);
     });

       //Navigator.pop(context);

       // bloc.errorDialog("Ficheiro ${widget.content['title']} adicionado!", context);
       /* showDialog(context: context,
        barrierDismissible: false,
        child: SafeArea(
          child: AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Ficheiro ${widget.content['title']} adicionado!')
              ],
            ),
          ),
        )
    );*/

       //todo fazer apenas o sucesso no ficheiro adicionado
       //  Navigator.pop(context);
       /*Navigator.push(
           context,
           MaterialPageRoute(
               builder: (context) =>
                   Content(
                     unitContent: !bloc.connectionStatus.contains('none') ? widget.content  :  bloc.sharedPrefs.getStringList(widget.content['id'].toString()),
                   )));*/
     }

     Future _addFilesOnline(File file, Bloc bloc) async {
      Requests request = Requests();

      await request.uploadFile(file, bloc.paeUser.session).then((resp) async {
        Slugify slug = Slugify();

        print(resp);

        Map object = {
          "@class": "pt.estgp.estgweb.domain.PageRepositoryFileImpl",
          "id": 0,
          "tmpFile": resp['uploadedFiles'][0],
          //"repositoryId": 0,
          "title": resp['uploadedFiles'][0]['fileName'],
          "slug": slug.slugGenerator(resp['uploadedFiles'][0]['fileName']),
          "repositoryFile4JsonView": null,
          "visible": true,
          "cols": 12
        };
        print(widget.content);

        Map map  = await request.addFile(
            object, widget.content['id'], bloc.paeUser.session);

       // map['response'].forEach((key,value)=>  print("$key : $value"));

        return map;
      });
  }

  _addFilesOffline(File file, Bloc bloc) async{

    String dir = (await getExternalStorageDirectory()).path  +  widget.content['path'];

    File localfile = await new File('$dir/${p.context.basename(file.path)}').create(recursive: true);

    Map localNewFile = {
      "@class": "pt.estgp.estgweb.domain.PageRepositoryFileImpl",
      "id": 0,
      "repositoryId": 0,
      "title": p.context.basename(file.path),
      "dateSaveDate": DateTime.now().millisecondsSinceEpoch,
      "dateUpdateDate": DateTime.now().millisecondsSinceEpoch,
      "path": localfile.path,
      "clearances": widget.content['clearances'],
      "directory": false,
      "file": true
    };
    //todo  apagar print
    print("NEW  FILE  --> "+file.path);
    print("LOCAL  FILE  --> "+localNewFile['path']);
    print(dir);
    //print(widget.content['id']);
    bloc.sharedPrefs.getStringList(widget.content['id'].toString()).add( jsonEncode(localNewFile));
    bloc.sharedPrefs.setString("${localNewFile['path']}/${localNewFile['title']}", jsonEncode(localNewFile));

    //bloc.sharedPrefs.setBool("cloud/${widget.content['path']}/${localNewFile['title']}", true);
    //bloc.sharedPrefs.setBool("newFile/${localNewFile['id']}", true);
  }

}




