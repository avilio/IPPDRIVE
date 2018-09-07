import 'package:flutter/material.dart';

import '../../blocs/bloc_provider.dart';
import '../permissions.dart';

class TrailingRemoveButton extends StatelessWidget {
  final content;
  final parentId;
  final canRemove;

  TrailingRemoveButton({this.content, this.parentId, this.canRemove});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of(context);
    if (canRemove) {
      return Row(
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
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Icon(
                            Icons.info,
                            color: Colors.yellow,
                          ),
                          content:
                              Text("Tem a certeza que quer apagar o ficheiro?"),
                          actions: <Widget>[
                            FlatButton(
                                onPressed: () {
                                  bloc
                                      .removeFile(content, parentId,
                                          bloc.paeUser.session)
                                      .then((resp) {
                                    ///
                                    if (resp.containsKey("ok")) {
                                      print(resp);
                                      Navigator.pop(context);
                                      bloc.errorDialog(
                                          'Ficheiro Apagado!', context);
                                    } else {
                                      print(resp);
                                      Navigator.pop(context);
                                      bloc.errorDialog(
                                          'Erro ao tentar apagar o ficheiro!\n ERRO: ${resp['exception']}',
                                          context);
                                    }
                                  });
                                },
                                child: Text('Sim')),
                            FlatButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Nao')),
                          ],
                        ));
              }
            },
          ),
        ],
      );
    } else
      return SizedBox();
  }
}
