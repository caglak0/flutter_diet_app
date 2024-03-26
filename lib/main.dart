import 'package:flutter/material.dart';
import 'package:flutter_diet_app/pages/home_screen.dart';
import 'package:flutter_diet_app/theme/light_tema.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: LighTema().theme,
        home: const NavbarTheme());
  }
}
