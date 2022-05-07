import 'package:flutter/material.dart';
import 'package:flutter_app/components/custom_colors.dart';

class CustomThemes {

  static ThemeData get lightTheme => ThemeData(
    primarySwatch: CustomColors.primaryMeterialColor,
    fontFamily: 'GmarketSansTTF',
    scaffoldBackgroundColor: Colors.white,
    splashColor: Colors.white,
    textTheme: _textTheme,
    brightness: Brightness.light,
    appBarTheme: _appBarTheme,
  );

  static ThemeData get darkTheme => ThemeData(
    primarySwatch: CustomColors.primaryMeterialColor,
    fontFamily: 'GmarketSansTTF',
    splashColor: Colors.white,
    textTheme: _textTheme,
    brightness: Brightness.dark,
  );

  static const AppBarTheme _appBarTheme = AppBarTheme(
    backgroundColor: Colors.white,
    iconTheme: IconThemeData( color: CustomColors.primaryColor),
    elevation:  0,
  );


  static const TextTheme _textTheme = TextTheme(
    headline4: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w400,
    ),
    subtitle1: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    subtitle2: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    bodyText1: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w300,
    ),
    bodyText2: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w300,
    ),
    button: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w300,
    ),
  );

}