import 'package:flutter/material.dart';
import 'ColorsThemes.dart';

ThemeData buildAppTheme(){

  final ThemeData base = ThemeData.light();

  return base.copyWith(
    accentColor: kDriveBlack,
    primaryColor: kDriveYellow600,
    buttonColor: kDriveYellow600,
    scaffoldBackgroundColor: kDriveWhite400,
    textSelectionColor: kDriveYellow300,
    errorColor: Colors.redAccent,
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder()
    ),
    buttonTheme: ButtonThemeData(
      textTheme: ButtonTextTheme.accent
    ),
    primaryIconTheme: base.iconTheme,
    textTheme: buildAppTextTheme(base.textTheme),
    primaryTextTheme: buildAppTextTheme(base.primaryTextTheme),
    accentTextTheme: buildAppTextTheme(base.accentTextTheme),
    hintColor: Colors.black,

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
      fontSize: 16.0,
    ),
  ).apply(
    fontFamily: 'Exo2',
  );
}