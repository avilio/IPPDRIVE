import 'package:flutter/material.dart';

import '../../blocs/home_provider.dart';
import '../../common/drawer.dart';
import '../../blocs/drawer_bloc.dart';
import '../../blocs/drawer_provider.dart';

class HomeStructure extends StatelessWidget {
  final List unitsCourseList;
  final String appBarTitle;
  final List<Widget> children;

  HomeStructure(
      {this.unitsCourseList, this.children,String appBarTitle, Key key})
      : appBarTitle = appBarTitle ?? 'Unidades Curricuares ${unitsCourseList[0]['path'].split('/')[6].toString().split('.')[1]}',
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeBloc = HomeProvider.of(context);

    final drawerBloc = DrawerProvider.of(context);

    final deviceWidth = MediaQuery.of(context).size.width;
    final targetWidth = deviceWidth > 550 ? 500 : deviceWidth * 0.99;
    final paddingDevice = (deviceWidth - targetWidth);

    if (unitsCourseList[0]['courseUnitsList'].isNotEmpty) {
      drawerBloc.setSchool( unitsCourseList[0]['courseUnitsList'][0]['course']['schoolInitials']);
      drawerBloc.setCourse( unitsCourseList[0]['courseUnitsList'][0]['course']['name']);
    }else{
      drawerBloc.setCourse('Funcionario/a');
      drawerBloc.setSchool('');
    }

    return new Scaffold(
        drawer: new MyDrawer(paeUser: homeBloc.paeUser, courseUnits: unitsCourseList),
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
