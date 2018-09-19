import 'package:flutter/material.dart';

import '../../blocs/bloc.dart';
import '../../blocs/bloc_provider.dart';
import '../permissions.dart';

class RemoveFile extends StatefulWidget {
  final content;
  final parentId;
  final canRemove;
  final AnimationController controller;

  RemoveFile(
      {this.content, this.parentId, this.canRemove, this.controller});

  @override
  RemoveFileState createState() {
    return new RemoveFileState();
  }
}

class RemoveFileState extends State<RemoveFile> {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of(context);
    if (widget.canRemove) {
      Widget remove = widget.controller != null
          ? Container(
              child: ScaleTransition(
                scale: CurvedAnimation(
                    parent: widget.controller.view,
                    curve: Interval(0.0, 1.0, curve: Curves.easeOut)),
                child: IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                  ),
                  onPressed: () async {
                    if (bloc.connectionStatus.contains('none'))
                      bloc.errorDialog("Sem acesso a Internet", context);
                    else {
                      DevicePermissions permiss = DevicePermissions();
                      await permiss.checkWriteExternalStorage();
                      dialogFileRemove(context, bloc);
                    }
                  },
                ),
                alignment: FractionalOffset.center,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                  ),
                  onPressed: () async {
                    if (bloc.connectionStatus.contains('none'))
                      bloc.errorDialog("Sem acesso a Internet", context);
                    else {
                      DevicePermissions permiss = DevicePermissions();
                      await permiss.checkWriteExternalStorage();
                      dialogFileRemove(context, bloc);
                    }
                  },
                ),
              ],
            );

      return remove;
    } else
      return SizedBox();
  }

  void dialogFileRemove(BuildContext context, Bloc bloc) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Icon(
                Icons.info,
                color: Colors.yellow,
              ),
              content: Text("Tem a certeza que quer apagar o ficheiro?"),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {

                      //todo remover de todo o lado nao so do pae remover local se for o caso
                      bloc
                          .removeFile(widget.content, widget.parentId,
                              bloc.paeUser.session)
                          .then((resp) {
                        ///
                        if (resp.containsKey("service") && resp['service'].toString().contains("ok")) {
                          print(resp);
                          Navigator.pop(context);
                          bloc.errorDialog('Ficheiro Apagado!', context);
                        } else {
                          print(resp);
                          Navigator.pop(context);
                          bloc.errorDialog(
                              'Erro ao tentar apagar o ficheiro!\n ERRO: ${resp['exception']}',
                              context);
                        }
                      });

                      bloc.sharedPrefs.remove("cloud/${widget.content['path']}/${widget.content['title']}");
                      bloc.sharedPrefs.remove(widget.content['id'].toString());
                    },
                    child: Text('Sim')),
                FlatButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Nao')),
              ],
            ));
  }
}
