import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:async_loader/async_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

import '../../blocs/bloc.dart';
import '../../blocs/bloc_provider.dart';
import '../../common/error401.dart';
import '../../common/permissions.dart';
import '../../common/widgets/dialog.dart';
import '../../common/widgets/list_item_builder.dart';
import '../../common/widgets/progress_indicator.dart';
import '../../common/widgets/trailing.dart';
import '../../common/widgets/trailing_cloud.dart';
import '../../common/widgets/trailing_remove_button.dart';
import '../../models/folders.dart';
import '../../screens/content.dart';
import '../../widgets/content/content_pathBuilder.dart';
//import 'package:slugify/slugify.dart';


class ContentBody extends StatefulWidget {
  final String course, school;
  final TapGestureRecognizer tapGestureRecognizer;
  final int id;

  ContentBody({this.course, this.school, this.tapGestureRecognizer, this.id,Key key}) : super(key: key);

  @override
  ContentBodyState createState() {
    return new ContentBodyState();
  }
}

class ContentBodyState extends State<ContentBody> with TickerProviderStateMixin  {
  AnimationController _controller;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final homeBloc = BlocProvider.of(context);
    homeBloc.onConnectionChange();
    Error401 error401 = Error401();

    if(homeBloc.connectionStatus.contains('none') && (homeBloc.sharedPrefs.get(widget.id.toString()) != null)){

          homeBloc.sharedPrefs.getStringList(widget.id.toString());

          List newList = new List();
          homeBloc.sharedPrefs.getStringList(widget.id.toString()).forEach((value) => newList.add(jsonDecode(value)));

          return createList(newList, context, homeBloc);

    }else if(!homeBloc.connectionStatus.contains('none'))
        return new AsyncLoader(
        initState: () async => await homeBloc.courseUnitsFoldersContents(widget.id, homeBloc.paeUser.session),
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
            homeBloc.saveListLocally(this.widget.id.toString(), checker, homeBloc.sharedPrefs);

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

  Widget createList(List courseUnitsContent,context, Bloc bloc) {

    Folders folder;
    Widget bodyList;
    String status = bloc.connectionStatus;

      bodyList = new Column(children: <Widget>[
        new ContentPathBuilder(tapGestureRecognizer: widget.tapGestureRecognizer,courseUnitsContent: courseUnitsContent,),
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
                  trailing: Trailing(canAdd: items['clearances']['addFiles'],folder: folder, content: items, parentId: widget.id),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                        new Content(unitContent: items,
                            course: widget.course,
                            school: widget.school)))
                );
              } else {
                folder = bloc.sharedPrefs.getString("${items['title']}") ?? Folders.fromJson(items);
                return new ListTile(
                  onTap: () async {
                    DevicePermissions permiss = DevicePermissions();
                    await permiss.checkWriteExternalStorage();
                    if(!bloc.connectionStatus.contains('none')) {

                      //todo verificar se o que vem do online tem data maior que a do offline, se sim perguntar ao user se quer a versao  do offline ou online, o mesmo  se passa
                      //todo quando  o user  mudou algo offline e quando for  online se for diferente perguntar
                      File file = await bloc.getFiles(
                          bloc.paeUser.session, items);
                      print(file.path);
                      OpenFile.open(file.path);
                    }else {
                      //todo verificar se o ficheiro esta disponivel para abrir offline ou nao e usar uma flag como indicador de inco no trailing a indicar essa informaçao
                      String dir = await bloc.buildFileDirectory(items['path']);

                      File file = new File('$dir/${items['title']}');
                      print(file.path);
                      OpenFile.open(file.path);
                    }
                  },
                  title: new Text(items['title'] ??
                      items['repositoryFile4JsonView']['name']),
                  leading: new Icon(Icons.description),
                  trailing: status.contains('none') ? null  : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      status.contains('none') ? null : SyncCloudOffline(
                        controller: _controller,
                        content: items),
                      TrailingRemoveButton(content: items, parentId: widget.id, canRemove: items['clearances']['removeFiles'], ),
                      _buildIconButton()
                    ],
                  )
                );
              }
            },
          ),
        ),
      ]);

    return bodyList;
  }

  IconButton _buildIconButton() {
    return IconButton(
        icon: AnimatedBuilder(
            animation: _controller.view,
            builder: (BuildContext context, Widget child) {
              return Transform(
                  alignment: FractionalOffset.center,
                  transform: Matrix4
                      .rotationZ(_controller.value * 0.5 * math.pi),
                  child: Icon(
                    _controller.isDismissed
                        ? Icons.more_horiz
                        : Icons.close,
                    color: _controller.isDismissed
                        ? Theme
                        .of(context)
                        .accentColor
                        : Theme
                        .of(context)
                        .errorColor,
                  ));
            }),
        onPressed: () {
          if (_controller.isDismissed) {
            _controller.forward();
          } else
            _controller.reverse();
        });
  }
}
