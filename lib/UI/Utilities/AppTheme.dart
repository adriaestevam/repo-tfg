import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData getAppTheme() {
    final Color primaryColor = Color(0xFF6200EE); // Deep Purple
    final Color secondaryColor = Color(0xFFFF4081); // Pink

    return ThemeData(
      primaryColor: primaryColor,
      secondaryHeaderColor: secondaryColor,
      scaffoldBackgroundColor: Colors.white,
      fontFamily: 'Montserrat', // Elegant font family
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
        elevation: 0, // No shadow
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.black87,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: primaryColor, // Deep Purple
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
          primary: primaryColor, // Deep Purple
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
