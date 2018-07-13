
import 'dart:io';

import 'package:documents_picker/documents_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import '../../screens/content.dart';
import '../../common/slugify.dart';
import '../../common/permissions.dart';
import '../../blocs/home_provider.dart';
import '../../resources/apiCalls.dart';


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
  final homeBloc = HomeProvider.of(context);

   return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            onPressed: () async {
              DevicePermissions permiss = DevicePermissions();
              bool permit = false;
              permit = await permiss.checkWriteExternalStorage();
              _filePicker(homeBloc.paeUser.session);
            },
            icon: Icon(
              Icons.add,
              color: Colors.green,
            ),
          )
        ],
    );
  }

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

    Requests request = Requests();

     await request.uploadFile(file, session).then((resp) {
      Slugify slug = Slugify();
 
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
      return request.addFile(object, widget.content['id'], session);
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Content(
                  unitContent: widget.content,
                )));
  }
}