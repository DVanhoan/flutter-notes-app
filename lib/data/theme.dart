import 'package:flutter/material.dart';

const Color primaryColor = Color.fromARGB(255, 58, 149, 255);

final Color reallyLightGrey = Colors.grey.withAlpha(25);

/// Chủ đề sáng
final ThemeData appThemeLight = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
    ),
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.white,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
    ),
    appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
    ),
);

/// Chủ đề tối
final ThemeData appThemeDark = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
    ),
    primaryColor: Colors.white,
    scaffoldBackgroundColor: const Color(0xFF121212),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
    ),
    appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
    ),
);
