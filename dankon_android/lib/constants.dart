import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFFFFD500);
const kSecondaryColor = Color(0xFFFFFDF2);
const kTextColor = Color(0xFF2E2E2E);

ThemeData kThemeData = ThemeData(
  primaryColor: kPrimaryColor,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: kPrimaryColor,
    foregroundColor: kTextColor,
    elevation: 0,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: kPrimaryColor,
    elevation: 0,
    titleTextStyle: TextStyle(
      color: kTextColor,
      fontSize: 18
    ),
    iconTheme: IconThemeData(
      color: kTextColor
    )
  )
);