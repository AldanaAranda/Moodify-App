import 'package:flutter/material.dart';

class DefaultTheme {
  static const Color primaryLight = Color.fromARGB(255, 174, 42, 210);
  static const Color primaryDark = Color.fromARGB(255, 142, 49, 235);
  static const Color secondary = Colors.grey;
  static const Color formElementsColor = Colors.purple;
  static const Color primaryHover =  Color.fromARGB(255, 174, 42, 210);


  static final ThemeData lightTheme = ThemeData(
    fontFamily: 'Poppins',
    appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent, foregroundColor: Colors.black),
    elevatedButtonTheme: ElevatedButtonThemeData(style: TextButton.styleFrom(
      backgroundColor: primaryLight, foregroundColor: Colors.black)),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            backgroundColor: primaryLight, foregroundColor: Colors.black)),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryLight,
        foregroundColor: Colors.black,
      ),
      listTileTheme: const ListTileThemeData(iconColor: primaryLight), 
      inputDecorationTheme: InputDecorationTheme(
          floatingLabelStyle: const TextStyle(color: formElementsColor),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: formElementsColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: formElementsColor),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ))
    );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'Poppins', // Define la fuente aquí
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent, // Fondo transparente
      foregroundColor: Colors.white, // Color de texto e iconos
      elevation: 0, // Sin sombra
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: primaryDark, 
        foregroundColor: Colors.white,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: secondary, 
        foregroundColor: Colors.white,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryDark,
      foregroundColor: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      floatingLabelStyle: const TextStyle(color: formElementsColor),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: formElementsColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: formElementsColor),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );

}
