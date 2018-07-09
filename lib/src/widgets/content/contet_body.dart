import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:async_loader/async_loader.dart';

import '../../common/widgets/list_item_builder.dart';
import '../../models/folders.dart';
import '../../blocs/home_provider.dart';
import '../../blocs/home_bloc.dart';
import '../../common/widgets/trailing.dart';
import '../../screens/content.dart';
import '../../widgets/content/content_pathBuilder.dart';

class ContentBody extends StatelessWidget {
  final String course, school;
  final TapGestureRecognizer tapGestureRecognizer;
  final int id;

  ContentBody({this.course, this.school, this.tapGestureRecognizer, this.id,Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeBloc = HomeProvider.of(context);
    homeBloc.onConnectionChange();

    return new AsyncLoader(
        initState: () async => await homeBloc.courseUnitsFoldersContents(id, homeBloc.paeUser.session),
        renderLoad: () => Center(child: new CircularProgressIndicator()),
        renderError: ([error]) => new Text('ERROR LOANDING DATA'),
        renderSuccess: ({data}) {

          List checker = data['response']['childs'];
          if (checker.isNotEmpty)
            return createList(checker ,context, homeBloc);
          else
            homeBloc.errorDialog('Data is Empty', context);
        });
  }

  Widget createList(List courseUnitsContent,context, HomeBloc homeBloc) {

    Folders folder;
    Widget bodyList;

      bodyList = new Column(children: <Widget>[
        ContentPathBuilder(tapGestureRecognizer: tapGestureRecognizer,courseUnitsContent: courseUnitsContent,),
        new Divider(),
        new Expanded(
          child: ListItemsBuilder<dynamic>(
            items: courseUnitsContent,
            itemBuilder: (context, items){
              if (items['directory']) {
                folder = Folders.fromJson(items);
                return new ListTile(
                  dense: true,
                  title: new Text(items['title']),
                  leading: new Icon(Icons.folder_open),
                  trailing: Trailing(canAdd: items['clearances']['addFiles'],folder: folder,),
                  onTap: () => !homeBloc.connectionStatus.contains('none')
                      ? Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                            new Content(unitContent: items,course: course,school: school)))
                      :  homeBloc.errorDialog('Sem acesso a Internet', context),
                );
              } else
                return new ListTile(
                  onTap: () async {
                    /*    bool can = await checkPermissions();
                  print(can);
                  File file = await getFiles(paeUser.session, items);
                  print(file);*/
                    homeBloc.launchFilesInBrowser(homeBloc.paeUser.session, items['repositoryId'].toString());
                    //storage.writeFile(file);
                    //File file = await storage.downloadFile(url,files[i]['title']);
                    // print(file.path);
                    // final RenderBox box = context.findRenderObject();
                    //Share.share(file.readAsBytesSync().toString());
                    //var args = {'url': file.path};
                    //await platform.invokeMethod('viewPdf', args);
                  },
                  title: new Text(items['title'] ??
                      items['repositoryFile4JsonView']['name']),
                  leading: new Icon(Icons.description),
                );
            },
          ),
        ),
      ]);

    return bodyList;
  }

}
