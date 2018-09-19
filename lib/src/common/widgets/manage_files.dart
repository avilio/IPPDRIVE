import 'dart:async';

import 'package:flutter/material.dart';

import '../../common/widgets/trailling_add_folders.dart';
import '../../blocs/bloc_provider.dart';
import '../../common/widgets/trailing_add_files.dart';


class ManageFiles extends StatefulWidget {
  final Map content;
  final AnimationController controller;
  final int parentId;

  ManageFiles({this.content, this.controller, this.parentId});

  @override
  _ManageFilesState createState() => _ManageFilesState();
}

class _ManageFilesState extends State<ManageFiles> {

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      final bloc = BlocProvider.of(context);
      bloc.onConnectionChange();
      /* onConnectivityChanged.listen((ConnectivityResult result){
        loginBloc.setConnectionStatus(result.toString());
      });*/
    });
  }
 
///
  _openFilePicker() {
    final bloc = BlocProvider.of(context);
    //todo alterar isto pois o modo de fazer isto offline vai ser diferente
   /* if(bloc.connectionStatus.contains('none'))
      bloc.errorDialog("Sem acesso a Internet", context);*/
//    else {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(50.0),
              children: <Widget>[
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                     Container(child: AddFiles(content: widget.content),decoration: BoxDecoration(border:Border.all()),),
                     SizedBox(height: 5.0,),
                     Container(child: AddFolders(content:widget.content),decoration: BoxDecoration(border:Border.all()),),

                      SizedBox(
                        height: 5.0,
                      ),
                     //todo comentado mas mudar apenas para mostrar o add buton
                     // TrailingRemoveButton(content: widget.content,parentId: widget.parentId,canRemove: true,)
                    ],
                  ),
                ),
              ],
            );
          });
    //}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ScaleTransition(
        scale: CurvedAnimation(
            parent: widget.controller,
            curve: Interval(0.0, 1.0, curve: Curves.easeOut)),
        child: new IconButton(
          onPressed: () async {
            _openFilePicker();

            //showDialog(context: context,child: buildDialog('TESTE ADD FILE BUTTON',context));
          },
          icon: Icon(Icons.edit),
        ),
        alignment: FractionalOffset.center,
      ),
    );
  }
}

