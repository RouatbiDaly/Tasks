import 'package:flutter/material.dart';
import 'package:tasks/app/utils/styles/constant_color.dart';

ThemeData lightTheme = ThemeData(
  colorScheme: const ColorScheme.light(
    primary: kPrimaryColor,
    secondary: kSecondaryColor,
    surface: kBackgroundColor,
    inversePrimary: Colors.black,
    error: kRedColor,
  ),
);
