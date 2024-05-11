import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:tfg_v1/Data/Models/StudyBloc.dart';

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
      child: Icon(
        iconData,
        size: size,
        color: color,
      ),
    );
  }
}

class TimeLinePainter extends CustomPainter {
  final List<StudyBlock> studyBlocks;
  final TextStyle textStyle = TextStyle(color: Colors.black, fontSize: 12);

  TimeLinePainter({required this.studyBlocks});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2;

    final blockPaint = Paint()
      ..color = primaryColor
      ..strokeWidth = 10;

    // Dibuja la línea principal horizontal
    canvas.drawLine(Offset(0, size.height / 2), Offset(size.width, size.height / 2), paint);

    // Etiquetas de tiempo inicial y final
    TextSpan startSpan = TextSpan(style: textStyle, text: "00:00");
    TextSpan endSpan = TextSpan(style: textStyle, text: "23:59");
    TextPainter startTextPainter = TextPainter(text: startSpan, textDirection: TextDirection.ltr)..layout();
    TextPainter endTextPainter = TextPainter(text: endSpan, textDirection: TextDirection.ltr)..layout();

    // Posición de texto a los extremos, fuera de la línea
    startTextPainter.paint(canvas, Offset(10 - startTextPainter.width / 2, size.height / 2 + 10));
    endTextPainter.paint(canvas, Offset(10 + size.width - endTextPainter.width / 2, size.height / 2 + 10));

    // Dibuja cada bloque de estudio como una línea horizontal
    studyBlocks.forEach((block) {
      double start = block.startTime.hour + block.startTime.minute / 60.0;
      double end = block.endTime.hour + block.endTime.minute / 60.0;
      double startX = start / 24 * size.width;
      double endX = end / 24 * size.width;

      // Línea para la duración del bloque de estudio
      canvas.drawLine(Offset(startX, size.height / 2), Offset(endX, size.height / 2), blockPaint);

      // Etiquetas para el inicio y fin de cada bloque de estudio
      String startTimeStr = "${block.startTime.hour.toString().padLeft(2, '0')}:${block.startTime.minute.toString().padLeft(2, '0')}";
      String endTimeStr = "${block.endTime.hour.toString().padLeft(2, '0')}:${block.endTime.minute.toString().padLeft(2, '0')}";
      TextSpan startTimeSpan = TextSpan(style: textStyle, text: startTimeStr);
      TextSpan endTimeSpan = TextSpan(style: textStyle, text: endTimeStr);
      TextPainter startTimeTextPainter = TextPainter(text: startTimeSpan, textDirection: TextDirection.ltr)..layout();
      TextPainter endTimeTextPainter = TextPainter(text: endTimeSpan, textDirection: TextDirection.ltr)..layout();

      // Posición de texto para las etiquetas de inicio y fin de los bloques de estudio
      startTimeTextPainter.paint(canvas, Offset(startX - startTimeTextPainter.width / 2, size.height / 2 - 20));
      endTimeTextPainter.paint(canvas, Offset(endX - endTimeTextPainter.width / 2, size.height / 2 - 20));
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}


Container buildDayStudyBlock(String day, List<StudyBlock> studyBlocks,Size size) {
  return Container(
    height: 100, // Set a fixed height for better control
    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(day),
        CustomPaint(
          size:size, // Full width and fixed height
          painter: TimeLinePainter(studyBlocks: studyBlocks.where((sb) => sb.day == day).toList()),
        ),
      ],
    )
  );
}















