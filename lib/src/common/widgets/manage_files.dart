import 'package:flutter/material.dart';

import '../../common/widgets/trailing_remove_button.dart';
import '../../common/widgets/trailing_add_button.dart';
import '../../blocs/home_provider.dart';


class ManageFiles extends StatefulWidget {
  final Map content;
  final AnimationController controller;
  final int parentId;

  ManageFiles({this.content, this.controller, this.parentId});

  @override
  _ManageFilesState createState() => _ManageFilesState();
}

class _ManageFilesState extends State<ManageFiles> {
 
///
  _openFilePicker() {
    final homeBloc = HomeProvider.of(context);

    if(homeBloc.connectionStatus.contains('none'))
      homeBloc.errorDialog("Sem acesso a Internet", context);
    else {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(50.0),
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                   TrailingAddButton(content: widget.content,),
                    SizedBox(
                      height: 5.0,
                    ),
                    TrailingRemoveButton(content: widget.content,parentId: widget.parentId,canRemove: true,)
                  ],
                ),
              ],
            );
          });
    }
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
