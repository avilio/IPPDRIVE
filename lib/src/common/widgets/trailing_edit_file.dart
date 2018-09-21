
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:documents_picker/documents_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../common/themes/colorsThemes.dart';
import '../../common/widgets/progress_indicator.dart';
import '../../screens/content.dart';
import '../../blocs/bloc.dart';
import '../../blocs/bloc_provider.dart';
import '../../common/permissions.dart';
import '../../common/slugify.dart';
import '../../resources/apiCalls.dart';
import '../permissions.dart';

class EditFile extends StatefulWidget {

  final Map content;

  const EditFile({Key key, this.content}) : super(key: key);


  @override
  _EditFileState createState() => _EditFileState();
}

class _EditFileState extends State<EditFile> {
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
                Icons.edit,
                color: cAppBlue,
              ),
            ),
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
      file = File(data);

      if (!bloc.connectionStatus.contains('none'))
        resp = await _editFilesOnline(file, bloc);
    });



    if(resp!=null) {
      Future.delayed(Duration(seconds:1), ()async {
        Navigator.pop(context);

     /*   Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Content(
                      unitContent: !bloc.connectionStatus.contains('none')
                          ? widget.content
                          : bloc.sharedPrefs.get(
                          widget.content['id'].toString()),
                    )));*/
      });
    }
  }

  Future _editFilesOnline(File file, Bloc bloc) async {

    Requests request = Requests();

        request.uploadFile(file, bloc.paeUser.session).then((resp) async {
                Slugify slug = Slugify();
                //todo o objeto a enviar é o que vem do upload ou sej ao resp
               /* Map object = {
                  "@class": "pt.estgp.estgweb.domain.PageRepositoryFileImpl",
                  "id": 0,
                  "tmpFile": resp['uploadedFiles'][0],
                  "title": resp['uploadedFiles'][0]['fileName'],
                  "slug": slug.slugGenerator(resp['uploadedFiles'][0]['fileName']),
                  "repositoryFile4JsonView": null,
                  "visible": true,
                  "cols": 12
                };*/
                Map object = widget.content;
                object["tmpFile"] = resp['uploadedFiles'][0];
                Map map  = await request.editFile(
                    object, widget.content['nowParentId'], bloc.paeUser.session);

                print("TITULO "+widget.content["title"]);
                bloc.sharedPrefs.remove("cloud/${widget.content['path']}/${widget.content['title']}");
                bloc.sharedPrefs.remove("${widget.content['path']}/${widget.content['title']}");

                bloc.sharedPrefs.setBool("cloud/${widget.content['path']}/${object['title']}", true);
                bloc.sharedPrefs.setString("${widget.content['path']}/${object['title']}", jsonEncode(map));

                Map edit = jsonDecode(bloc.sharedPrefs.get("${widget.content['path']}/${object['title']}"));

                print(edit['title']);

                return map;
              });

  }
}

