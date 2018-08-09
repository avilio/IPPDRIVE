import 'package:flutter/material.dart';

import '../permissions.dart';
import '../../blocs/home_provider.dart';

class TrailingRemoveButton extends StatelessWidget {
  final content;
  final parentId;
  final canRemove;

  TrailingRemoveButton({this.content, this.parentId, this.canRemove});

  @override
  Widget build(BuildContext context) {
    final homeBloc = HomeProvider.of(context);
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
              if (homeBloc.connectionStatus.contains('none'))
                homeBloc.errorDialog("Sem acesso a Internet", context);
              else {
                DevicePermissions permiss = DevicePermissions();
                bool permit = false;
                permit = await permiss.checkWriteExternalStorage();
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
                                  homeBloc
                                      .removeFile(content, parentId,
                                          homeBloc.paeUser.session)
                                      .then((resp) {
                                    ///
                                    if (resp.containsKey("ok")) {
                                      print(resp);
                                      Navigator.pop(context);
                                      homeBloc.errorDialog(
                                          'Ficheiro Apagado!', context);
                                    } else {
                                      print(resp);
                                      Navigator.pop(context);
                                      homeBloc.errorDialog(
                                          'Erro ao tentar apagar o ficheiro!\n ERRO: ${resp['exception']}',
                                          context);
                                    }

                                    ///TODO fazer de forma a ter o path parent ou forma de fazer refresh depois de apagar
                                    //Navigator.push(context, MaterialPageRoute(builder: (context)=> Content(unitContent: content,)));
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