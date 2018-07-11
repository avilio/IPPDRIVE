import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../../models/folders.dart';
import '../../common/widgets/favorites.dart';
import '../../common/widgets/manage_files.dart';

class Trailing extends StatefulWidget {
  final bool canAdd;
  final Folders folder;
  final Map content;
  final int parentId;

  Trailing({this.canAdd, this.folder, this.content,this.parentId,Key key}) : super(key: key);

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
    if (widget.canAdd) {
      return new Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
        new ManageFiles(content: widget.content,controller:_controller, parentId: widget.parentId ),
        new Favorites(folders: widget.folder, controller: _controller),
        IconButton(
            icon: AnimatedBuilder(
                animation: _controller.view,
                builder: (BuildContext context, Widget child) {
                  return Transform(
                      alignment: FractionalOffset.center,
                      transform:
                          Matrix4.rotationZ(_controller.value * 0.5 * math.pi),
                      child: Icon(
                        _controller.isDismissed
                            ? Icons.more_horiz
                            : Icons.close,
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
            })
      ]);
    } else
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            child: ScaleTransition(
              scale: CurvedAnimation(
                  parent: _controller.view,
                  curve: Interval(0.0, 1.0, curve: Curves.easeOut)),
              child: IconButton(icon: Icon(Icons.cloud_off), onPressed: ()=> print("TESTE")),
              alignment: FractionalOffset.center,
            ),
          ),
         new Favorites(folders: widget.folder,controller: _controller),
          IconButton(
              icon: AnimatedBuilder(
                  animation: _controller.view,
                  builder: (BuildContext context, Widget child) {
                    return Transform(
                        alignment: FractionalOffset.center,
                        transform:
                        Matrix4.rotationZ(_controller.value * 0.5 * math.pi),
                        child: Icon(
                          _controller.isDismissed
                              ? Icons.more_horiz
                              : Icons.close,
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
              })
        ],
      );
  }
}

/* Se ficar melhor subistituir pelo IconButton ///
FloatingActionButton(
backgroundColor: cAppYellowish,
foregroundColor: cAppBlackish,
heroTag: "Options",
elevation: 0.0,
mini: true,
child: Icon(Icons.more_horiz),
onPressed: () {
if (_controller.isDismissed) {
_controller.forward();
} else
_controller.reverse();
})*/
