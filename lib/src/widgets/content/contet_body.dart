import 'dart:convert';
import 'dart:io';

import 'package:async_loader/async_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../../blocs/home_bloc.dart';
import '../../blocs/home_provider.dart';
import '../../common/error401.dart';
import '../../common/permissions.dart';
import '../../common/widgets/dialog.dart';
import '../../common/widgets/list_item_builder.dart';
import '../../common/widgets/progress_indicator.dart';
import '../../common/widgets/trailing.dart';
import '../../common/widgets/trailing_remove_button.dart';
import '../../models/folders.dart';
import '../../screens/content.dart';
import '../../widgets/content/content_pathBuilder.dart';
//import 'package:slugify/slugify.dart';


class ContentBody extends StatelessWidget {
  final String course, school;
  final TapGestureRecognizer tapGestureRecognizer;
  final int id;

  ContentBody({this.course, this.school, this.tapGestureRecognizer, this.id,Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeBloc = HomeProvider.of(context);
    homeBloc.onConnectionChange();
    Error401 error401 = Error401();

    if(homeBloc.connectionStatus.contains('none') && (homeBloc.sharedPrefs.get(id.toString()) != null)){

          homeBloc.sharedPrefs.getStringList(id.toString());

          List newList = new List();
          homeBloc.sharedPrefs.getStringList(id.toString()).forEach((value) {
                    newList.add(jsonDecode(value));
                  });

          return createList(newList, context, homeBloc);

    }else if(!homeBloc.connectionStatus.contains('none'))
        return new AsyncLoader(
        initState: () async => await homeBloc.courseUnitsFoldersContents(id, homeBloc.paeUser.session),
        renderLoad: () => Center(child: AdaptiveProgressIndicator()),
        renderError: ([error]) {
          if(error == 401)
            error401.error401(context);

          return new Text('ERROR LOANDING DATA');
        },
        renderSuccess: ({data}) {
          List checker = data['response']['childs'];
          if (checker.isNotEmpty) {

            ///
            homeBloc.saveListLocally(this.id.toString(), checker, homeBloc.sharedPrefs);

            return createList(checker, context, homeBloc);
          }else
            return DialogAlert(message: 'Pasta vazia');
        });
   else
     return Center(
       child: Container(
         child: Column(
           mainAxisSize: MainAxisSize.min,
           crossAxisAlignment: CrossAxisAlignment.center,
           children: <Widget>[
             Text("Sem Informação Disponivel",textScaleFactor: 1.5,),
           ],
         )
       ),
     );

  }

  Widget createList(List courseUnitsContent,context, HomeBloc homeBloc) {

    Folders folder;
    Widget bodyList;

      bodyList = new Column(children: <Widget>[
        new ContentPathBuilder(tapGestureRecognizer: tapGestureRecognizer,courseUnitsContent: courseUnitsContent,),
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
                  trailing: Trailing(canAdd: items['clearances']['addFiles'],folder: folder, content: items, parentId: id),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                        new Content(unitContent: items,
                            course: course,
                            school: school)))
                );
              } else {
                folder = homeBloc.sharedPrefs.getString("${items['title']}") ?? Folders.fromJson(items);
                return new ListTile(
                  onTap: () async {
                    DevicePermissions permiss = DevicePermissions();
                    bool permit = false;
                    permit = await permiss.checkWriteExternalStorage();
                    if(!homeBloc.connectionStatus.contains('none')) {
                      File file = await homeBloc.getFiles(
                          homeBloc.paeUser.session, items);
                      print(file.path);
                      OpenFile.open(file.path);
                    }else {

                      var lastIndex = items['path'].lastIndexOf("/");
                      String dir = (await getExternalStorageDirectory()).path + items['path'].substring(0,lastIndex);

                      File file = new File('$dir/${items['title']}');
                      print(file.path);
                      OpenFile.open(file.path);
                    }

                    //final AndroidIntent intent = new AndroidIntent(action: 'action_view');
                    //intent.launch();
                   /* homeBloc.connectionStatus.contains('none')
                    ?  homeBloc.errorDialog("Sem acesso a Internet", context)
                    : homeBloc.launchFilesInBrowser(homeBloc.paeUser.session, items['repositoryId'].toString());*/
                  },
                  title: new Text(items['title'] ??
                      items['repositoryFile4JsonView']['name']),
                  leading: new Icon(Icons.description),
                  trailing: TrailingRemoveButton(content: items, parentId: id, canRemove: items['clearances']['removeFiles'], ) ///Trailing(canAdd: items['clearances']['addFiles'], folder: folder, content: items, parentId: id,),
                );
              }
            },
          ),
        ),
      ]);

    return bodyList;
  }

}
