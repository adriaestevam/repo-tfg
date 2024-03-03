import 'package:flutter/material.dart';

class StudyBlock {
  final int id;           // Identificador único del bloque de estudio
  final int userId;       // Clave foránea del usuario
  final String day;       // Día de la semana (Lunes, Martes, etc.)
  final TimeOfDay startTime; // Hora de inicio
  final TimeOfDay endTime;   // Hora de finalización

  StudyBlock({
    required this.id,
    required this.userId,
    required this.day,
    required this.startTime,
    required this.endTime,
  });

  // Convierte un objeto StudyBlock a un Map. Útil para insertar en la base de datos
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'day': day,
      'startTime': startTime.toString(), // Convertir TimeOfDay a String
      'endTime': endTime.toString(),     // Convertir TimeOfDay a String
    };
  }

  // Crea un objeto StudyBlock a partir de un Map. Útil para leer de la base de datos
  factory StudyBlock.fromMap(Map<String, dynamic> map) {
    return StudyBlock(
      id: map['id'],
      userId: map['userId'],
      day: map['day'],
      startTime: _convertStringToTimeOfDay(map['startTime']), // Convertir String a TimeOfDay
      endTime: _convertStringToTimeOfDay(map['endTime']),     // Convertir String a TimeOfDay
    );
  }
  
  // Convierte un String en formato HH:mm a un TimeOfDay
  static TimeOfDay _convertStringToTimeOfDay(String timeString) {
    List<String> parts = timeString.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }
}
