
import 'dart:io';

import 'package:documents_picker/documents_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../blocs/bloc.dart';
import '../../blocs/bloc_provider.dart';
import '../../common/permissions.dart';
import '../../common/slugify.dart';
import '../../resources/apiCalls.dart';
import '../../screens/content.dart';


class TrailingAddButton extends StatefulWidget {
  final Map content;

  TrailingAddButton({this.content});

  @override
  TrailingAddButtonState createState() {
    return new TrailingAddButtonState();
  }
}

class TrailingAddButtonState extends State<TrailingAddButton> {
  @override
  Widget build(BuildContext context) {
  final bloc = BlocProvider.of(context);

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
   
    docPaths.forEach((data) => file = File(data));
    //todo fazer caso offline
    Requests request = Requests();

     await request.uploadFile(file, bloc.paeUser.session).then((resp) async {
      Slugify slug = Slugify();

      print(resp);
 
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
      print(widget.content);
      return await request.addFile(object, widget.content['id'], bloc.paeUser.session);
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

  //  Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Content(
                  unitContent: widget.content,
                )));
  }
}