import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.all(Colors.white),
        trackColor: WidgetStateProperty.all(Colors.grey),
        trackOutlineWidth: WidgetStateProperty.all(0.0),
        trackOutlineColor: WidgetStateProperty.all(Colors.grey),
        overlayColor: WidgetStateProperty.all(Colors.blue[100]),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(Colors.blue),
        ),
      ),
      brightness: Brightness.light,
      primaryColor: Colors.purpleAccent,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        color: Colors.purple,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 4,
        shadowColor: Colors.purple,
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: Colors.blue,
        textTheme: ButtonTextTheme.primary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.purpleAccent),
          textStyle:
              WidgetStateProperty.all(const TextStyle(color: Colors.white)),
          padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0)),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
            fontSize: 72.0, fontWeight: FontWeight.bold, color: Colors.black),
        headlineMedium: TextStyle(
            fontSize: 36.0, fontStyle: FontStyle.italic, color: Colors.black),
        headlineSmall:
            TextStyle(fontSize: 14.0, fontFamily: 'Hind', color: Colors.black),
        titleLarge: TextStyle(
            fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black),
        titleMedium: TextStyle(
            fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
        titleSmall: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 90, 90, 90)),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(color: Colors.grey),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primaryTextTheme: const TextTheme(
        headlineLarge: TextStyle(
            fontSize: 72.0, fontWeight: FontWeight.bold, color: Colors.white),
        headlineMedium: TextStyle(
            fontSize: 36.0, fontStyle: FontStyle.italic, color: Colors.white),
        headlineSmall:
            TextStyle(fontSize: 14.0, fontFamily: 'Hind', color: Colors.white),
        titleLarge: TextStyle(
            fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
        titleMedium: TextStyle(
            fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
        titleSmall: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 90, 90, 90)),
        bodyLarge: TextStyle(fontSize: 16.0, color: Colors.white),
        bodyMedium: TextStyle(fontSize: 14.0, color: Colors.white),
        bodySmall: TextStyle(fontSize: 12.0, color: Colors.white),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.all(Colors.white),
        trackColor: WidgetStateProperty.all(Colors.grey),
        trackOutlineWidth: WidgetStateProperty.all(0.0),
        trackOutlineColor: WidgetStateProperty.all(Colors.grey),
        overlayColor: WidgetStateProperty.all(Colors.blue[100]),
      ),
      brightness: Brightness.dark,
      primaryColor: Colors.grey[900],
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: AppBarTheme(
        color: Colors.grey[850],
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.grey[800],
        textTheme: ButtonTextTheme.primary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.grey[800]),
          textStyle:
              WidgetStateProperty.all(const TextStyle(color: Colors.white)),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
            fontSize: 72.0, fontWeight: FontWeight.bold, color: Colors.white),
        headlineMedium: TextStyle(
            fontSize: 36.0, fontStyle: FontStyle.italic, color: Colors.white),
        headlineSmall:
            TextStyle(fontSize: 14.0, fontFamily: 'Hind', color: Colors.white),
        titleLarge: TextStyle(
            fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
        titleMedium: TextStyle(
            fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
        titleSmall: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 90, 90, 90)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.cyan),
        ),
        labelStyle: TextStyle(color: Colors.cyan[600]),
      ),
    );
  }
}
