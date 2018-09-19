import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:ippdrive/src/common/permissions.dart';

import '../../blocs/bloc_provider.dart';
import '../../common/widgets/favorites.dart';
import '../../common/widgets/manage_files.dart';
import '../../models/folders.dart';
import '../../common/widgets/trailing_add_files.dart';

class Trailing extends StatefulWidget {
  final Map clearances;
  final Folders folder;
  final Map content;
  final int parentId;

  Trailing({this.clearances, this.folder, this.content, this.parentId, Key key})
      : super(key: key);

  @override
  TrailingState createState() {
    return new TrailingState();
  }
}

class TrailingState extends State<Trailing> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of(context);
    bloc.onConnectionChange();
    String status = bloc.connectionStatus;

    if (status.contains('none')) {
      if (widget.clearances.containsKey("add")) {
        return new Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
          ManageFiles(
              content: widget.content,
              controller: _controller,
              parentId: widget.parentId),
          _buildIconButton()
        ]);
      } else
        return Row(mainAxisSize: MainAxisSize.min);
    } else {
      if (widget.clearances.containsKey("add")) {
        return new Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
          /*SyncCloudOffline(controller: _controller,
            content: widget.content,
            folders: widget.folder,),*/
          ManageFiles(
              content: widget.content,
              controller: _controller,
              parentId: widget.parentId),
          status.contains('none')
              ? null
              : Favorites(folders: widget.folder, controller: _controller),
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
            animation: _controller.view,
            builder: (BuildContext context, Widget child) {
              return Transform(
                  alignment: FractionalOffset.center,
                  transform:
                      Matrix4.rotationZ(_controller.value * 0.5 * math.pi),
                  child: Icon(
                    _controller.isDismissed ? Icons.more_horiz : Icons.close,
                    color: _controller.isDismissed
                        ? Theme.of(context).accentColor
                        : Theme.of(context).errorColor,
                  ));
            }),
        onPressed: () {
          if (_controller.isDismissed) {
            _controller.forward();
          } else
            _controller.reverse();
        });
  }
}
