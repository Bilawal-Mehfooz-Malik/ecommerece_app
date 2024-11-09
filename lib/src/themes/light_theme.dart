import 'package:ecommerce_app/src/constants/app_sizes.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

const _lPrimaryColor = Color.fromARGB(255, 197, 44, 105);
const _lOnPrimaryColor = Colors.white;
const _lBackgroundColor = Colors.white;
const _lCardColor = Color.fromARGB(255, 255, 242, 247);

final _borderRadius =
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(Sizes.p8));

final flexColorScheme = const FlexColorScheme(
  brightness: Brightness.light,
  primary: _lPrimaryColor,
  onPrimary: _lOnPrimaryColor,
  appBarBackground: _lPrimaryColor,
  scaffoldBackground: _lBackgroundColor,
  appBarElevation: 0,
).toTheme.copyWith(
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: _borderRadius,
          backgroundColor: _lPrimaryColor,
          foregroundColor: _lOnPrimaryColor,
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(shape: _borderRadius),
      ),

      cardTheme: CardTheme(color: _lCardColor, shape: _borderRadius),
    );
