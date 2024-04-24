import 'package:flutter/material.dart';
import 'package:flutter_diet_app/pages/home_screen.dart';
import 'package:flutter_diet_app/screens/welcome_page.dart';
import 'package:flutter_diet_app/theme/light_tema.dart';
import 'package:provider/provider.dart';

class ThemeProvider extends ChangeNotifier {
  late ThemeData _currentTheme;

  ThemeProvider() {
    // Başlangıçta varsayılan tema olarak LighTema'yı kullan
    _currentTheme = LighTema().theme;
  }

  ThemeData get currentTheme => _currentTheme;

  void toggleTheme() {
    _currentTheme =
        _currentTheme == LighTema().theme ? ThemeData.dark() : LighTema().theme;
    notifyListeners();
  }

  // Özel LighTema'yı kullanarak temayı ayarla
  void setCustomTheme() {
    _currentTheme = LighTema().theme;
    notifyListeners();
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: themeProvider._currentTheme,
        home: const WelcomePage());
  }
}
