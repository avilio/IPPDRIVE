import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:documents_picker/documents_picker.dart';

import '../permissions.dart';
import '../../resources/apiCalls.dart';
import '../../blocs/home_provider.dart';

class AddFiles extends StatefulWidget {
  @override
  _AddFilesState createState() => _AddFilesState();
}

class _AddFilesState extends State<AddFiles> {


  _filePicker(String session)async {
    List<dynamic> docPaths;

    try {
      docPaths = await DocumentsPicker.pickDocuments;
    }on PlatformException {
      print(PlatformException);
    }
    if(!mounted) return;
    File file;
    docPaths.forEach((data) => file = File(data));

    print(file.path.split("/").last);
    Requests request = Requests();

    Map response = await request.uploadFile(file, session);
    //response.forEach((a,b)=> debugPrint('$a : $b'));
    print(response['uploadedFiles'][0]);
  }


  _openFilePicker(BuildContext context){
    final homeBloc = HomeProvider.of(context);

    showModalBottomSheet(context: context, builder: (BuildContext context){
      return Container(padding: EdgeInsets.all(55.0),
        //decoration: BoxDecoration(border: Border.all()),
        height: 150.0,
        child: FlatButton(onPressed: ()async {
          DevicePermissions permiss = DevicePermissions();
          bool permit = false;

            permit = await permiss.checkWriteExternalStorage();
            print(permit);
           // if(permit)
             _filePicker(homeBloc.paeUser.session);

        },
          textTheme: ButtonTextTheme.primary,
          shape: Border.all(width: 0.5),
          padding: EdgeInsets.all(2.0),
            child: Text('Adicionar Ficheiro',
            style: Theme.of(context).textTheme.title,),
        color: Theme.of(context).buttonColor,),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return new IconButton(onPressed: ()async {
      print("ADD FILE");
      _openFilePicker(context);

      //showDialog(context: context,child: buildDialog('TESTE ADD FILE BUTTON',context));
    } ,icon: Icon(Icons.add),);
  }
}
