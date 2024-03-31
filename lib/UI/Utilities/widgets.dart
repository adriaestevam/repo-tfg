import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

final Color primaryColor = Color.fromARGB(255, 68, 157, 122); // Verde claro para elementos destacados
final Color accentColor = Color.fromARGB(255, 63, 67, 63); // Gris claro para acentos y fondos
final Color primaryTextColor = Color(0xFF2D2D2D); // Casi negro para texto principal
final Color secondaryTextColor = Color.fromARGB(255, 44, 71, 72); // Gris para texto secundario
final Color cardBackgroundColor = Color(0xFFF0F0F0); // Color de fondo para tarjetas
final Color backgroundColor = Colors.grey.shade300;

class myGreenButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final BoxDecoration decoration;
  final EdgeInsetsGeometry padding;
  final double height;
  final double width;

  myGreenButton({
    required this.onPressed,
    required this.child,
    required this.decoration,
    required this.height,
    required this.width,
    this.padding = const EdgeInsets.all(8.0),
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: IntrinsicHeight(
        child: Container(
          decoration: BoxDecoration(
            color: primaryColor,
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
          ),
          padding: padding,
          child: TextButton(
            onPressed: onPressed,
            child: child,
          ),
          height: height,
          width: width,
        ),
      ),
    );
  }
}



class myTransparentButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final BoxDecoration decoration;
  final EdgeInsetsGeometry padding;
  final double height;
  final double width;

  myTransparentButton({
    required this.onPressed,
    required this.child,
    required this.decoration,
    required this.height,
    required this.width,
    this.padding = const EdgeInsets.all(8.0),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color:Colors.grey.shade500,
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
      ),
      padding: padding,
      child: TextButton(
        onPressed: onPressed,
        child: child,
      ),
      height: height,
      width: width,
    );
  }
}

class myTransparentTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final String hintText;
  final String labelText;

  myTransparentTextField({
    required this.controller,
    required this.obscureText,
    required this.hintText,
    required this.labelText, required TextInputType keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade500,
            offset: Offset(4, 4),
            blurRadius: 5,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.white,
            offset: Offset(-4, -4),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent, 
        ),
      ),
    );
  }
}


class MyBottomBarIcon extends StatelessWidget {
  final IconData iconData;
  final double size;
  final Color color;

  MyBottomBarIcon({
    required this.iconData,
    this.size = 30.0, // Tamaño por defecto
    this.color = Colors.black, // Color por defecto
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 50,
        minWidth: 50
      ),
      
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade500,
            offset: Offset(2, 2),
            blurRadius: 5,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.white,
            offset: Offset(-2, -2),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Icon(
        iconData,
        size: size,
        color: color,
      ),
    );
  }
}













