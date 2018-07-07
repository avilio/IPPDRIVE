import 'package:flutter/material.dart';

class AddFiles extends StatefulWidget {
  @override
  _AddFilesState createState() => _AddFilesState();
}

class _AddFilesState extends State<AddFiles> {

  _openFilePicker(BuildContext context){
    showModalBottomSheet(context: context, builder: (BuildContext context){
      return Container(padding: EdgeInsets.all(55.0),
        //decoration: BoxDecoration(border: Border.all()),
        height: 150.0,
        child: FlatButton(onPressed: (){},
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
    return new IconButton(onPressed: (){
      print("ADD FILE");
      _openFilePicker(context);
      //showDialog(context: context,child: buildDialog('TESTE ADD FILE BUTTON',context));
    } ,icon: Icon(Icons.add),);
  }
}
