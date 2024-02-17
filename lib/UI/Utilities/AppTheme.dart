import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData getAppTheme() {
    final Color primaryColor = Color.fromARGB(255, 4, 112, 98); 
    final Color accentColor = Color.fromARGB(255, 128, 168, 151); 

    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: Color(0xFFF5F5F5), // Gris claro
      fontFamily: 'Montserrat', // Fuente elegante
      textTheme: TextTheme(
        headline1: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        headline2: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        bodyText1: TextStyle(
          fontSize: 16,
          color: Colors.black54,
        ),
        bodyText2: TextStyle(
          fontSize: 14,
          color: Colors.black45,
        ),
      ),
      appBarTheme: AppBarTheme(
        color: Colors.white,
        elevation: 0, // Sin sombra
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.black87,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: primaryColor, // Marrón
          onPrimary: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          textStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: primaryColor, 
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: accentColor),
    );
  }
}
