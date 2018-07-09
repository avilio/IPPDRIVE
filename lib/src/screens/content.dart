import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../common/widgets/drawer.dart';
import '../blocs/home_provider.dart';
import '../blocs/drawer_bloc.dart';
import '../blocs/drawer_provider.dart';
import '../widgets/content/contet_body.dart';

class Content extends StatelessWidget {
  final Map unitContent;
  final String school;
  final String course;
  final TapGestureRecognizer tapGestureRecognizer;

  Content({this.unitContent, this.school, this.course, TapGestureRecognizer tapGestureRecognizer, Key key})
      : tapGestureRecognizer = tapGestureRecognizer ?? new TapGestureRecognizer(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeBloc = HomeProvider.of(context);
    final drawerBloc = DrawerProvider.of(context);

    homeBloc.onConnectionChange();

    tapGestureRecognizer ..onTap = _handlePress;

    int unitID = unitContent['id'] ?? unitContent['pageContentId'];

    return new Scaffold(
        drawer: new MyDrawer(courseUnits: unitContent,paeUser: homeBloc.paeUser),
        appBar: new AppBar(
          title: new Text(
            unitContent['title'].toString().split('-')[0],
            style: new TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: ContentBody(tapGestureRecognizer: tapGestureRecognizer,school: school,course: course,id: unitID));
  }

  void _handlePress() {
    HapticFeedback.vibrate();
  }
}


