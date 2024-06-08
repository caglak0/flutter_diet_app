import 'package:flutter/material.dart';
import 'package:flutter_diet_app/screens/welcome_page.dart';
import 'package:flutter_diet_app/theme/light_tema.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

class ThemeProvider extends ChangeNotifier {
  late ThemeData _currentTheme;

  ThemeProvider() {
    _currentTheme = LighTema().theme;
  }

  ThemeData get currentTheme => _currentTheme;

  void toggleTheme() {
    _currentTheme = _currentTheme == LighTema().theme ? ThemeData.dark() : LighTema().theme;
    notifyListeners();
  }

  void setCustomTheme() {
    _currentTheme = LighTema().theme;
    notifyListeners();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    Builder(
      builder: (context) => ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Healt +',
      theme: themeProvider._currentTheme,
      home: const WelcomePage(),
    );
  }
}
