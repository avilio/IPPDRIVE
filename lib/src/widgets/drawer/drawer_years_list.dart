import 'package:async_loader/async_loader.dart';
import 'package:flutter/material.dart';

import '../../blocs/bloc.dart';
import '../../blocs/bloc_provider.dart';
import '../../common/widgets/progress_indicator.dart';
import '../../screens/home.dart';


class DrawerYearsList extends StatelessWidget {

  DrawerYearsList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeBloc = BlocProvider.of(context);

    return new ExpansionTile(
      leading: new Icon(Icons.school),
      title: new Text(' Ano Lectivo',
        style: new TextStyle(fontWeight: FontWeight.bold),
      ),
      children: <Widget>[yearList(homeBloc)],
    );
  }

  Widget yearList(Bloc homeBloc) => new AsyncLoader(
    initState: () async => await homeBloc.getYears(homeBloc.paeUser.session),
    renderLoad: () => new AdaptiveProgressIndicator(),
    renderError: ([error]) => new Text('ERROR LOANDING DATA'),
    renderSuccess: ({data}) {
      List yearsList = List();
      yearsList.add(data['response']['importYear']);
      yearsList.add(data['response']['previousImportYear']);
      yearsList.add(data['response']['previous2ImportYear']);

      return new ListView.builder(
        physics: PageScrollPhysics(),
        shrinkWrap: true,
        itemCount: yearsList.length,
        itemBuilder: (context, index) {
          return new ListTile(
            dense: true,
            title: new Text(yearsList[index].toString().substring(0, 4) + '-20' + yearsList[index].toString().substring(4),
              style: new TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () async {
              Map units = await homeBloc.wsYearsCoursesUnitsFolders(
                  homeBloc.paeUser.session, yearsList[index]);
              if (units['response']['childs'].isNotEmpty) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => new HomePage(paeUser: homeBloc.paeUser, unitsCourseList: units['response']['childs'])),
                        (Route<dynamic> route) => false);
              } else
                homeBloc.errorDialog('No Data to Display', context);
            },
          );
        },
      );
    },
  );
}
