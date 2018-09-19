import 'package:flutter/material.dart';

import '../../blocs/bloc_provider.dart';
import '../../blocs/drawer_provider.dart';
import '../../common/widgets/drawer.dart';

class HomeStructure extends StatelessWidget {
  final List unitsCourseList;
  final String appBarTitle;
  final List<Widget> children;
  final String anoCorrente;

  HomeStructure(
      {this.unitsCourseList, this.children,this.anoCorrente,String appBarTitle, Key key})
      : appBarTitle = appBarTitle ?? unitsCourseList.length >= 1 ? 'Unidades Curricuares ${unitsCourseList[0]['path'].split('/')[6].toString().split('.')[1]}':
        "Ano Lectivo $anoCorrente",
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeBloc = BlocProvider.of(context);

    final drawerBloc = DrawerProvider.of(context);

    final deviceWidth = MediaQuery.of(context).size.width;
    final targetWidth = deviceWidth > 550 ? 500 : deviceWidth * 0.99;
    final paddingDevice = (deviceWidth - targetWidth);

    if(unitsCourseList.length>=1) {
      if (unitsCourseList[0]['courseUnitsList'].isNotEmpty) {
        drawerBloc.setSchool(
            unitsCourseList[0]['courseUnitsList'][0]['course']['schoolInitials']);
        drawerBloc.setCourse(
            unitsCourseList[0]['courseUnitsList'][0]['course']['name']);
      } else {
        drawerBloc.setCourse('Funcionario/a');
        drawerBloc.setSchool('');
      }
    }else {
      drawerBloc.setSchool(homeBloc.paeUser.escola);
      drawerBloc.setCourse("");
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
