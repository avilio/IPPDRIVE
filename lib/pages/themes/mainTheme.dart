import 'package:flutter/material.dart';
import 'colorsThemes.dart';

ThemeData buildAppTheme(){

  final ThemeData base = ThemeData.light();

  return base.copyWith(
    accentColor: cAppBlackish,
    primaryColor: cAppYellowish,
    buttonColor: cAppYellowish,
    scaffoldBackgroundColor: cAppYellowishAccent,
    textSelectionColor: cAppYellowish,
    errorColor: Colors.redAccent,
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder()
    ),
    buttonTheme: ButtonThemeData(
      textTheme: ButtonTextTheme.normal
    ),
    primaryIconTheme: base.iconTheme,
    textTheme: buildAppTextTheme(base.textTheme),
    primaryTextTheme: buildAppTextTheme(base.primaryTextTheme),
    accentTextTheme: buildAppTextTheme(base.accentTextTheme),
    hintColor: cAppBlackish,
    dialogBackgroundColor: cAppYellowishAccent,
  );
}

TextTheme buildAppTextTheme(TextTheme base) {
  return base.copyWith(
    headline: base.headline.copyWith(
      fontWeight: FontWeight.w500,
    ),
    title: base.title.copyWith(
        fontSize: 18.0
    ),
    caption: base.caption.copyWith(
      fontWeight: FontWeight.w400,
      fontSize: 14.0,
    ),
    body2: base.body2.copyWith(
      fontWeight: FontWeight.w500,
      fontSize: 11.0,
    ),
  ).apply(
    fontFamily: 'Exo2',
    bodyColor: cAppBlackish
  );
}