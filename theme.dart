import 'package:flutter/material.dart';

final ThemeData themeData = ThemeData(
  primarySwatch: Colors.blue,
  //accentColor: Colors.orange,
  fontFamily: 'Roboto', // Change to your preferred font family
  textTheme: TextTheme(
    headline1: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
    headline2: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
    // Add more text styles as needed
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.orange,
    textTheme: ButtonTextTheme.primary,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      primary: Colors.blue,
      onPrimary: Colors.white,
      textStyle: TextStyle(fontSize: 18),
    ),
  ),
  appBarTheme: AppBarTheme(
    color: Colors.blue,
    //textTheme: TextTheme(
      //headline6: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    //),
  ),
);
