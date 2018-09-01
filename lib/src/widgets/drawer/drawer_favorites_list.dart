import 'package:async_loader/async_loader.dart';
import 'package:flutter/material.dart';

import '../../blocs/bloc.dart';
import '../../blocs/bloc_provider.dart';
import '../../common/widgets/progress_indicator.dart';
import '../../screens/content.dart';


class DrawerFavoritesList extends StatelessWidget {

  final String school;
  final String course;

  DrawerFavoritesList({ this.course, this.school, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeBloc = BlocProvider.of(context);

    return new ExpansionTile(
      leading: new Icon(Icons.star),
      title: new Text(
        'Favoritos',
        style: new TextStyle(fontWeight: FontWeight.bold),
      ),
      children: <Widget>[favorites(homeBloc)],
    );
  }

  Widget favorites(Bloc bloc) =>
      new AsyncLoader(
        initState: () async => await bloc.readFavorites(bloc.paeUser.session),
        renderLoad: () => AdaptiveProgressIndicator(),
        renderError: ([error]) => new Text('ERROR LOANDING DATA'),
        renderSuccess: ({data}) {
          List favoritesList = data['response']['favorites'];

            favoritesList.length ?? 0;

          return new ListView.builder(
            physics: PageScrollPhysics(),
            shrinkWrap: true,
            itemCount: favoritesList.length,
            itemBuilder: (context, index) {
              return new ListTile(
                dense: true,
                title: new Text(
                  favoritesList[index]['title'].contains('-')
                      ? favoritesList[index]['title'].split('-').first
                      : favoritesList[index]['title'],
                  style: new TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: new Text(
                  bloc.subtitleSplitter(favoritesList[index]['path']),
                  softWrap: true,
                ),
                onTap: () {

                  if (favoritesList.isNotEmpty) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => new Content(unitContent: favoritesList[index],course: course,school: school)));
                  } else
                    bloc.errorDialog('No Data to Display', context);
                },
              );
            },
          );
        },
      );
}
