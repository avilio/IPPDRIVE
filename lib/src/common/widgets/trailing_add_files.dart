
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
import '../../screens/content.dart';
import '../permissions.dart';


class AddFiles extends StatefulWidget {
  final Map content;

  AddFiles({this.content});

  @override
  AddFileState createState() {
    return new AddFileState();
  }
}

class AddFileState extends State<AddFiles> {

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

   return GestureDetector(
     onTap: () async {
       DevicePermissions permiss = DevicePermissions();
       await permiss.checkWriteExternalStorage();
       _filePicker(bloc);
       },
     child: Center(
       child: Row(
         children: <Widget>[
           IconButton(
             iconSize: 25.0,
             onPressed: () async {
               DevicePermissions permiss = DevicePermissions();
               await permiss.checkWriteExternalStorage();
               _filePicker(bloc);
             },
             icon: Icon(
               Icons.add,
               color: Colors.green,
             ),
           ),
           Text("Adicionar ficheiro",textScaleFactor: 1.75,)
         ],
       ),
     ),
   );
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
     Map resp = new Map();

     docPaths.forEach((data) async {
       File file =  await new File(data).create(recursive: true);
       //file.copySync(data);
       print(file.path);
       print(file.lengthSync());

       //todo fazer caso offline
       if (!bloc.connectionStatus.contains('none'))
          resp = await _addFilesOnline(file, bloc);
       else
         resp = await _addFilesOffline(file, bloc);
     });

    if(resp!=null) {
      Future.delayed(Duration(seconds:2), () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Content(
                      unitContent: !bloc.connectionStatus.contains('none')
                          ? widget.content
                          : jsonDecode(bloc.sharedPrefs.get(
                          "${widget.content['path']}/${widget.content['title']}")),
                    )));
      });
    }
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
          "title": resp['uploadedFiles'][0]['fileName'],
          "slug": slug.slugGenerator(resp['uploadedFiles'][0]['fileName']),
          "repositoryFile4JsonView": null,
          "visible": true,
          "cols": 12
        };
        print(widget.content);
//todo bufg do adiciona ficheiros do offline para online
        Map map  = await request.addFile(
            object, widget.content['id'], bloc.paeUser.session);

        bloc.sharedPrefs.setBool("cloud/${widget.content['path']}/${object['title']}", true);
       // map['response'].forEach((key,value)=>  print("$key : $value"));

        return map;
      });
  }

  _addFilesOffline(File file, Bloc bloc) async{

    print(file.lengthSync());

    String dir = (await getExternalStorageDirectory()).path  +  widget.content['path'];
    file.copy('$dir/${p.context.basename(file.path)}');
    //File localfile = await new File('$dir/${p.context.basename(file.path)}').create(recursive: true);

    print(file.lengthSync());
    print(file.path);
    //print(localfile.lengthSync());

    Map localNewFile = {
      "@class": "pt.estgp.estgweb.domain.PageRepositoryFileImpl",
      "id": 0,
      "title": p.context.basename(file.path),
      "dateSaveDate": DateTime.now().millisecondsSinceEpoch,
      "dateUpdateDate": DateTime.now().millisecondsSinceEpoch,
      "path": file.path,
      "clearances": widget.content['clearances'],
     // "directory": false,
      "file": true,
      "nowParentId": widget.content['id']
    };
    //todo  apagar print
    print("NEW  FILE  --> "+file.path);
    print("LOCAL  FILE  --> "+localNewFile['path']);
    print(dir);

   // bloc.sharedPrefs.getStringList(widget.content['id'].toString());
    bloc.sharedPrefs.getStringList(widget.content['id'].toString()).add(jsonEncode(localNewFile));
    print(bloc.sharedPrefs.getStringList(widget.content['id'].toString()));
  //  bloc.sharedPrefs.setString("${localNewFile['path']}/${localNewFile['title']}", jsonEncode(localNewFile));

    bloc.sharedPrefs.setBool("newFile/${widget.content['id']}",true);
    bloc.sharedPrefs.setBool("cloud/${widget.content['path']}/${localNewFile['title']}",true);

  }


}




