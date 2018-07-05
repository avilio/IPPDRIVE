import 'package:async_loader/async_loader.dart';
import 'package:flutter/material.dart';

import '../../screens/content.dart';
import '../../blocs/home_bloc.dart';
import '../../blocs/home_provider.dart';

class DrawerFavoritesList extends StatelessWidget {

  final String school;
  final String course;

  DrawerFavoritesList({ this.course, this.school, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeBloc = HomeProvider.of(context);

    return new ExpansionTile(
      leading: new Icon(Icons.star),
      title: new Text(
        'Favoritos',
        style: new TextStyle(fontWeight: FontWeight.bold),
      ),
      children: <Widget>[favorites(homeBloc)],
    );
  }

  Widget favorites(HomeBloc bloc) =>
      new AsyncLoader(
        initState: () async => await bloc.readFavorites(bloc.paeUser.session),
        renderLoad: () => new CircularProgressIndicator(),
        renderError: ([error]) => new Text('ERROR LOANDING DATA'),
        renderSuccess: ({data}) {
          List favoritesList = data['response']['favorites'];
          return new ListView.builder(
            physics: PageScrollPhysics(),
            shrinkWrap: true,
            itemCount: favoritesList.length ?? 0,
            itemBuilder: (context, index) {
              return new ListTile(
                dense: true,
                title: new Text(
                  favoritesList[index]['title'],
                  style: new TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: new Text(
                  bloc.subtitleSplitter(favoritesList[index]['path'].split('/')[8]),
                  softWrap: true,
                ),
                onTap: () {

                  if (favoritesList.isNotEmpty) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => new UcContent(unitContent: favoritesList[index],course: course,school: school)));
                  } else
                    bloc.errorDialog('No Data to Display', context);
                },
              );
            },
          );
        },
      );
}
