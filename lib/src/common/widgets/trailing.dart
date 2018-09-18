import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:ippdrive/src/common/permissions.dart';

import '../../blocs/bloc_provider.dart';
import '../../common/widgets/favorites.dart';
import '../../common/widgets/manage_files.dart';
import '../../models/folders.dart';
import '../../common/widgets/trailing_add_button.dart';

class Trailing extends StatefulWidget {
  final bool canAdd;
  final Folders folder;
  final Map content;
  final int parentId;
  final AnimationController controller;

  Trailing({this.canAdd, this.folder, this.content, this.parentId,this.controller, Key key})
      : super(key: key);

  @override
  TrailingState createState() {
    return new TrailingState();
  }
}

class TrailingState extends State<Trailing> with TickerProviderStateMixin {


  @override
  void initState() {
    Future.delayed(Duration.zero,()async{
      DevicePermissions permiss = DevicePermissions();
      await permiss.checkWriteExternalStorage();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of(context);
    bloc.onConnectionChange();
    String status = bloc.connectionStatus;

    if (status.contains('none')) {
      if (widget.canAdd) {
        return new Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
          TrailingAddButton(content: widget.content,controller: widget.controller,),

          /*ManageFiles(
              content: widget.content,
              controller: _controller,
              parentId: widget.parentId),*/
          _buildIconButton()
        ]);
      } else
        return Row(mainAxisSize: MainAxisSize.min);
    } else {
      if (widget.canAdd) {
        return new Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
          /*SyncCloudOffline(controller: _controller,
            content: widget.content,
            folders: widget.folder,),*/
          /* ManageFiles(
              content: widget.content,
              controller: _controller,
              parentId: widget.parentId),*/
          TrailingAddButton(content: widget.content,controller: widget.controller,),
          status.contains('none')
              ? null
              : Favorites(folders: widget.folder, controller: widget.controller),
          _buildIconButton()
        ]);
      } else
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            status.contains('none') ? null : Favorites(folders: widget.folder),
          ],
        );
    }
  }

  IconButton _buildIconButton() {
    return IconButton(
        icon: AnimatedBuilder(
            animation: widget.controller.view,
            builder: (BuildContext context, Widget child) {
              return Transform(
                  alignment: FractionalOffset.center,
                  transform:
                      Matrix4.rotationZ(widget.controller.value * 0.5 * math.pi),
                  child: Icon(
                    widget.controller.isDismissed ? Icons.more_horiz : Icons.close,
                    color: widget.controller.isDismissed
                        ? Theme.of(context).accentColor
                        : Theme.of(context).errorColor,
                  ));
            }),
        onPressed: () {
          if (widget.controller.isDismissed) {
            widget.controller.forward();
          } else
            widget.controller.reverse();
        });
  }
}
