import 'dart:async';

import 'package:flutter/material.dart';

import '../../common/widgets/progress_indicator.dart';
import '../../screens/content.dart';
import '../../blocs/bloc.dart';
import '../../blocs/bloc_provider.dart';
import '../../common/permissions.dart';
import '../../common/slugify.dart';
import '../../resources/apiCalls.dart';
import '../permissions.dart';

class AddFolders extends StatefulWidget {

  final Map content;

  AddFolders({this.content});


  @override
  _AddFoldersState createState() => _AddFoldersState();
}

class _AddFoldersState extends State<AddFolders> {

  final _folderController = new TextEditingController();
  bool textVisible = false;

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
      onTap: ()async {
        _showDialog(bloc);
      },
      child: Center(
        child: Row(
          children: <Widget>[
            IconButton(
              iconSize: 25.0,
              onPressed: () async {},
              icon: Icon(
                Icons.add,
                color: Colors.green,
              ),
            ),
            Text("Adicionar Pasta",textScaleFactor: 1.75,),
          ],
        ),
      ),
    );
  }


  _showDialog(Bloc bloc) async {

    await showDialog(context: context,
    child: AlertDialog(
      contentPadding: const EdgeInsets.all(16.0),
     content: Row(
       children: <Widget>[
         Expanded(
             child: TextField(
               controller: _folderController,
         decoration: InputDecoration(
        hintText: 'Nome da Pasta',
        labelText: 'Adicionar Pasta'),
          )
         )
       ],
     ),
      actions: <Widget>[
        new FlatButton(
            child: const Text('Cancelar'),
            onPressed: () {
              Navigator.pop(context);
            }),
        new FlatButton(
            child: const Text('Gravar'),
            onPressed: () async{
              Navigator.pop(context);
              DevicePermissions permiss = DevicePermissions();
              await permiss.checkWriteExternalStorage();

              Map resp = await _addFolderOnline(_folderController.text, bloc);

              if(resp!=null) {
                Future.delayed(Duration(seconds: 1), () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Content(
                                unitContent: !bloc.connectionStatus.contains(
                                    'none')
                                    ? resp['response']
                                    : bloc.sharedPrefs.get(resp['response']['id'].toString()),
                              )));
                });
              }
            })
      ],
    )
    );
  }

  Future _addFolderOnline(String text, Bloc bloc) async{

    Slugify slug = Slugify();
    Requests request = Requests();

    Map folder = {
      "@class": "pt.estgp.estgweb.domain.PageSectionImpl",
      "id": 0,
      "visible": true,
      "modeImage": false,
      "sectionTitleVisible": true,
      "cols": 12,
      "topLayoutSection": false,
      "title": text,
      "modified": "true",
      "slug": slug.slugGenerator(text),
    };

    Map map  = await request.addFolder(
        folder, widget.content['id'], bloc.paeUser.session);

    return map;
  }
}
