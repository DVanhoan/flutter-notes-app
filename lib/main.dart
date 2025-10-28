import 'package:flutter/material.dart';
import 'package:flutter_notes_app/services/theme_preference.dart';
import 'screens/home.dart';
import 'data/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeData theme = appThemeLight;

  @override
  void initState() {
    super.initState();
    _updateThemeFromSharedPref();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes App',
      theme: theme,
      home: MyHomePage(
        title: 'My Notes',
        changeTheme: _setTheme,
      ),
    );
  }

  void _setTheme(Brightness brightness) {
    if (brightness == Brightness.dark) {
      setState(() {
        theme = appThemeDark;
      });
      ThemePreference.setTheme('dark');
    } else {
      setState(() {
        theme = appThemeLight;
      });
      ThemePreference.setTheme('light');
    }
  }

  Future<void> _updateThemeFromSharedPref() async {
    final themeText = await ThemePreference.getTheme();
    if (themeText == 'dark') {
      _setTheme(Brightness.dark);
    } else {
      _setTheme(Brightness.light);
    }
  }
}
