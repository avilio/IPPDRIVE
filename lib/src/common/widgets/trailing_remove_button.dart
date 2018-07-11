import 'package:flutter/material.dart';
import '../permissions.dart';
import '../themes/colorsThemes.dart';
import '../../blocs/home_provider.dart';

class TrailingRemoveButton extends StatelessWidget {
  final content;
  final parentId;

  TrailingRemoveButton({this.content, this.parentId});

  @override
  Widget build(BuildContext context) {
    final homeBloc = HomeProvider.of(context);

    return Container(
      decoration:
      new BoxDecoration(color: cAppBlueAccent, border: Border.all()),
      alignment: FractionalOffset.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            child: Text('Remover Ficheiro',
                style: TextStyle(
                    color: Colors.redAccent, fontWeight: FontWeight.bold),
                softWrap: true),
            onTap: () async {
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
                                .removeFile(
                                content,
                                parentId,
                                homeBloc.paeUser.session)
                                .then((resp) {
                              print(resp);
                              Navigator.pop(context);
                            });
                          },
                          child: Text('Sim')),
                      FlatButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Nao')),
                    ],
                  ));
            },
          ),
          FloatingActionButton(
            onPressed: () async {
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
                                .removeFile(
                                content,
                                parentId,
                                homeBloc.paeUser.session)
                                .then((resp) {
                              print(resp);
                              Navigator.pop(context);
                            });
                          },
                          child: Text('Sim')),
                      FlatButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Nao')),
                    ],
                  ));
            },
            backgroundColor: Theme.of(context).buttonColor,
            foregroundColor: Theme.of(context).accentColor,
            shape: OutlineInputBorder(
                borderSide: BorderSide(),
                borderRadius: BorderRadius.circular(10.0)),
            materialTapTargetSize: MaterialTapTargetSize.padded,
            child: Icon(
              Icons.remove,
              color: Colors.redAccent,
            ),
            mini: true,
            elevation: 0.0,
            heroTag: "Remove",
          )
        ],
      ),
    );
  }
}
