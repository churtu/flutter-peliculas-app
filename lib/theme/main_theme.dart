import 'package:flutter/material.dart';

class MainTheme {
  static const Color primary = Colors.indigo;
  static final ThemeData lightTheme = ThemeData.light().copyWith(
    appBarTheme: const AppBarTheme(
      color: primary,
      elevation: 0
    )
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(

  );
}