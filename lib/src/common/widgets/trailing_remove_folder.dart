import 'package:flutter/material.dart';

import '../../blocs/bloc.dart';
import '../../blocs/bloc_provider.dart';
import '../../common/permissions.dart';
import '../../resources/apiCalls.dart';
import '../permissions.dart';

class RemoveFolder extends StatefulWidget {

  final content;
  final canRemove;

  RemoveFolder(
      {this.content,this.canRemove});
  @override
  _RemoveFolderState createState() => _RemoveFolderState();
}

class _RemoveFolderState extends State<RemoveFolder> {

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
            Text("Adicionar Pasta",textScaleFactor: 1.75),
          ],
        ),
      ),
    );
  }

  Future _removeFolderOnline(String text, Bloc bloc) async{

    Requests request = Requests();

    //todo no futuro, porque nao tenho maneira de saber aqui o parent id
  }
}
