import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../common/widgets/list_item_builder.dart';
import '../../common//themes/colorsThemes.dart';

import '../../blocs/home_provider.dart';

class ContentPathBuilder extends StatelessWidget {
  final List courseUnitsContent;
  final List listPath = List();
  final TapGestureRecognizer tapGestureRecognizer;

  ContentPathBuilder({this.courseUnitsContent, this.tapGestureRecognizer,Key key}) :super(key:key);

  @override
  Widget build(BuildContext context) {
    final homeBloc = HomeProvider.of(context);
      Iterator units = courseUnitsContent.iterator;

      while(units.moveNext()) {
        return new GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: new Text(
            TextSpan(text: homeBloc.pathBuilder(units.current, listPath),
                recognizer: tapGestureRecognizer).text,
            style: new TextStyle(fontWeight: FontWeight.bold, color: cAppBlue),
          ),
        );
      }
      return Container();
  }



}
