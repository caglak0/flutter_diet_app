import 'package:flutter/material.dart';

class LighTema {
  final _lightColor = _LightColor();
  late ThemeData theme;

  LighTema() {
    theme = ThemeData(
        appBarTheme: const AppBarTheme(
            color: Color.fromARGB(222, 154, 184, 255),
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(20)))),
        scaffoldBackgroundColor: const Color.fromARGB(222, 154, 184, 255),
        checkboxTheme: const CheckboxThemeData(
            fillColor: MaterialStatePropertyAll(Colors.green),
            side: BorderSide(color: Colors.green)),
        colorScheme: const ColorScheme.light(),
        textTheme: ThemeData.light().textTheme.copyWith(
            displayMedium:
                TextStyle(fontSize: 25, color: _lightColor._textColor)));
  }
}

class _LightColor {
  final Color _textColor = const Color.fromARGB(255, 210, 93, 84);
  final Color blueMenia = const Color.fromARGB(84, 59, 63, 190);
}
