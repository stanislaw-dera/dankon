import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFFFFD500);
const kSecondaryColor = Color(0xFFFFFDF2);
const kDarkColor = Color(0xFF2E2E2E);

const smAvatarRadius = 10.0;

ThemeData kThemeData = ThemeData(
  primaryColor: kPrimaryColor,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: kPrimaryColor,
    foregroundColor: kDarkColor,
    elevation: 0,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: kDarkColor,
    centerTitle: true,
    elevation: 0,
  ),
  tabBarTheme: const TabBarTheme(
    unselectedLabelColor: Colors.white70,
    labelColor: kPrimaryColor,
  )
);