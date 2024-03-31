import 'package:flutter/material.dart';
import 'package:tfg_v1/UI/Utilities/widgets.dart';

class AppTheme {
  static ThemeData getAppTheme() {
    // Definiendo colores basados en la imagen proporcionada
    final Color primaryColor = Color.fromARGB(255, 68, 157, 122); // Verde claro para elementos destacados
    final Color accentColor = Color.fromARGB(255, 63, 67, 63); // Gris claro para acentos y fondos
    final Color primaryTextColor = Color(0xFF2D2D2D); // Casi negro para texto principal
    final Color secondaryTextColor = Color.fromARGB(255, 44, 71, 72); // Gris para texto secundario
    final Color cardBackgroundColor = Color(0xFFF0F0F0); // Color de fondo para tarjetas

    return ThemeData(
      primaryColor: primaryColor,
      hintColor: accentColor,
      scaffoldBackgroundColor: Colors.grey.shade300,
      fontFamily: 'Roboto',
      textTheme: TextTheme(
        headline1: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: primaryTextColor,
        ),
        headline2: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: primaryTextColor,
        ),
        bodyText1: TextStyle(
          fontSize: 16,
          color: secondaryTextColor,
        ),
        bodyText2: TextStyle(
          fontSize: 14,
          color: secondaryTextColor,
        ),
      ),
      appBarTheme: AppBarTheme(
        color: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: primaryTextColor,
        ),
      ),
      cardTheme: CardTheme(
        color: cardBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: primaryColor,
          onPrimary: Colors.white,
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: primaryColor,
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
      ),
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: primaryColor, // Your primary color
        onPrimary: Colors.white, // Color for text/icons on top of the primary color
        secondary: accentColor, // Your accent color
        onSecondary: primaryTextColor, // Color for text/icons on top of the secondary color
        error: Colors.redAccent, // Default color for error, like input validation errors
        onError: Colors.white, // Color for text/icons on top of the error color
        background: Colors.white, // Background color for widgets like Card
        onBackground: primaryTextColor, // Color for text/icons on top of the background color
        surface: cardBackgroundColor, // Color for surfaces like AppBar, Dialog, etc.
        onSurface: primaryTextColor, // Color for text/icons on top of the surface color
      ),
    );
  }
}

myBoxDecoration() {
  return BoxDecoration(
    color: backgroundColor,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.shade500,
        offset: Offset(4,4),
        blurRadius: 5,
        spreadRadius: 1
      ),
      BoxShadow(
        color: Colors.white,
        offset: Offset(-4,-4),
        blurRadius: 5,
        spreadRadius: 1
      )
    ]
  );       
}

myDayofCalendarDecoration() {
  return BoxDecoration(
    color: primaryColor,
    borderRadius: BorderRadius.circular(5),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.shade500,
        offset: Offset(2,2),
        blurRadius: 3,
        spreadRadius: 1
      ),
      BoxShadow(
        color: Colors.white,
        offset: Offset(-2,-2),
        blurRadius: 3,
        spreadRadius: 1
      )
    ]
  );       
}
currentDayDecoration() {
  return BoxDecoration(
    color: backgroundColor,
    borderRadius: BorderRadius.circular(5),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.shade500,
        offset: Offset(2,2),
        blurRadius: 3,
        spreadRadius: 1
      ),
      BoxShadow(
        color: Colors.white,
        offset: Offset(-2,-2),
        blurRadius: 3,
        spreadRadius: 1
      )
    ]
  );       
}

myAddEventButtonDecoration() {
  return BoxDecoration(
    color: backgroundColor,
    shape: BoxShape.circle,
    boxShadow: [
      BoxShadow(
        color: Colors.grey.shade500,
        offset: Offset(1,1),
        blurRadius: 2,
        spreadRadius: 1
      ),
      BoxShadow(
        color: Colors.white,
        offset: Offset(-1,-1),
        blurRadius: 2,
        spreadRadius: 1
      )
    ]
  );       
}

eventMarkerDecoration() {
  return BoxDecoration(
    color: backgroundColor,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.shade500,
        offset: Offset(1,1),
        blurRadius: 3,
        spreadRadius: 1
      ),
      BoxShadow(
        color: Colors.white,
        offset: Offset(-1,-1),
        blurRadius: 3,
        spreadRadius: 1
      )
    ]
  );       
}

myCircularDecoration() {
  return BoxDecoration(
    color: backgroundColor,
    borderRadius: BorderRadius.circular(50),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.shade500,
        offset: Offset(4,4),
        blurRadius: 5,
        spreadRadius: 1
      ),
      BoxShadow(
        color: Colors.white,
        offset: Offset(-4,-4),
        blurRadius: 5,
        spreadRadius: 1
      )
    ]
  );       
}