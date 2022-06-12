import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFFFFC300);
const kPinkColor = Color(0xFFFF69FC);
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
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: kPrimaryColor
  ),
  snackBarTheme: const SnackBarThemeData(
    behavior: SnackBarBehavior.floating
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
    )
  )
);