import 'package:flutter/material.dart';
import 'package:flutter_restaurant/utils/text_theme.dart';

ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.amber,
    primaryColor: Colors.grey[200],
    accentColor: Colors.amberAccent,
    backgroundColor: Colors.grey[200],
    indicatorColor: Colors.grey[900],
    buttonColor: Colors.amberAccent,
    hintColor: Colors.grey[900],
    splashColor: Colors.amberAccent,
    textTheme: poppinsLight,
    textSelectionTheme: TextSelectionThemeData(
        cursorColor: Colors.grey[900], selectionColor: Colors.grey[900]),
    canvasColor: Colors.white,
    cardColor: Colors.grey[200],
    brightness: Brightness.light,
    appBarTheme: AppBarTheme(elevation: 0.0));

ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.amber,
    primaryColor: Colors.grey[900],
    accentColor: Colors.grey[850],
    backgroundColor: Colors.grey[900],
    indicatorColor: Colors.amberAccent,
    buttonColor: Colors.amberAccent,
    hintColor: Colors.white,
    splashColor: Colors.grey[900],
    textTheme: poppinsDark,
    cardColor: Colors.grey[850],
    textSelectionTheme: TextSelectionThemeData(
        cursorColor: Colors.grey[900], selectionColor: Colors.grey[900]),
    canvasColor: Colors.grey[900],
    brightness: Brightness.dark,
    appBarTheme: AppBarTheme(elevation: 0.0));

MaterialBasedCupertinoThemeData myMaterialBasedCupertinoThemeData =
    MaterialBasedCupertinoThemeData(
  materialTheme: lightTheme,
);
