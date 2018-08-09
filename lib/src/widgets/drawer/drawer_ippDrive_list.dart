import 'package:flutter/material.dart';

import 'package:async_loader/async_loader.dart';

import '../../common/widgets/dialog.dart';
import '../../common/widgets/progress_indicator.dart';
import '../../screens/content.dart';
import '../../blocs/home_bloc.dart';
import '../../blocs/home_provider.dart';

class IppDriveList extends StatelessWidget {

  String school;
  String course;

  IppDriveList({this.school, this.course, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeBloc = HomeProvider.of(context);

    return new ExpansionTile(
      leading: Image(image: AssetImage("assets/images/ipp.png"),width: 40.0,), //ImageIcon(AssetImage("assets/images/ipp.png"))
      title: new Text('IppDrive',
        style: new TextStyle(fontWeight: FontWeight.bold),
      ),
      children: <Widget>[ippDriveRoot(homeBloc)],
    );
  }

  Widget ippDriveRoot(HomeBloc homeBloc)=> new AsyncLoader(
      initState: () async => await homeBloc.courseUnitsFoldersContents( 5, homeBloc.paeUser.session),
      renderLoad: () => AdaptiveProgressIndicator(),
      renderError: ([error]) => new Text('ERROR LOANDING DATA'),
      renderSuccess: ({data}) {
        List ippDriveRootList = data['response']['childs'];

        return new ListView.builder(
          physics: PageScrollPhysics(),
          shrinkWrap: true,
          itemCount: ippDriveRootList.length ?? 0,
          itemBuilder: (context, index) {
            return new ListTile(
              dense: true,
              leading: homeBloc.imageSchoolLeading(ippDriveRootList[index]['title']),
              title: new Text(
                ippDriveRootList[index]['title'],
                style: new TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                if (ippDriveRootList.isNotEmpty) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => new Content(unitContent: ippDriveRootList[index],school: school,course: course,)));
                } else
                  showDialog(context: context,builder: (context )=> new DialogAlert(message: 'Sem dados para mostrar') );
              },
            );
          },
        );
      },
    );
}
