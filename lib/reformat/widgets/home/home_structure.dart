import 'package:flutter/material.dart';

import '../../blocs/home_provider.dart';
import '../../common/drawer.dart';

class HomeStructure extends StatelessWidget {
  final List unitsCourseList;
  final String appBarTitle;
  final List<Widget> children;
  final bool isFuncionario;

  HomeStructure(
      {this.unitsCourseList, this.children, bool isFuncionario,String appBarTitle, Key key})
      : appBarTitle = appBarTitle ?? 'Unidades Curricuares ${unitsCourseList[0]['path'].split('/')[6].toString().split('.')[1]}',
        isFuncionario = isFuncionario ?? false,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeBloc = HomeProvider.of(context);
    final deviceWidth = MediaQuery.of(context).size.width;
    final targetWidth = deviceWidth > 550 ? 500 : deviceWidth * 0.99;
    final paddingDevice = (deviceWidth - targetWidth);

    Widget drawer = !isFuncionario
        ? new MyDrawer(paeUser: homeBloc.paeUser, courseUnits: unitsCourseList)
        : new MyDrawer(paeUser: homeBloc.paeUser, courseUnits: unitsCourseList);

    return new Scaffold(
        drawer: drawer,
        appBar: new AppBar(
          title: new Text(
            appBarTitle,
            style: new TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.all(paddingDevice),
            child: Wrap(
              runSpacing: 8.0,
              children: children,
            )));
  }
}
