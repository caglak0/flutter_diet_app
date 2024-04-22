import 'package:flutter/material.dart';

class ThemeModePage extends StatefulWidget {
  const ThemeModePage({super.key});

  @override
  _ThemeModePageState createState() => _ThemeModePageState();
}

class _ThemeModePageState extends State<ThemeModePage> {
  bool _darkThemeEnabled = false;
  bool _lightThemeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Görünüm'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CheckboxListTile(
              title: const Text(
                'Koyu Tema',
                style: TextStyle(fontSize: 20),
              ),
              value: _darkThemeEnabled,
              onChanged: (bool? value) {
                setState(() {
                  _darkThemeEnabled = value ?? false;
                  if (_darkThemeEnabled) {
                    _lightThemeEnabled = false;
                  }
                });
                // Koyu tema seçildiğinde yapılacak işlemler buraya gelecek
              },
              controlAffinity: ListTileControlAffinity.trailing,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CheckboxListTile(
              title: const Text(
                'Açık Tema',
                style: TextStyle(fontSize: 20),
              ),
              value: _lightThemeEnabled,
              onChanged: (bool? value) {
                setState(() {
                  _lightThemeEnabled = value ?? false;
                  if (_lightThemeEnabled) {
                    _darkThemeEnabled = false;
                  }
                });
                // Açık tema seçildiğinde yapılacak işlemler buraya gelecek
              },
              controlAffinity: ListTileControlAffinity.trailing,
            ),
          ),
        ],
      ),
    );
  }
}
