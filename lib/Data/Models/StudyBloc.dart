import 'package:flutter/material.dart';

class StudyBlock {
  int id;           // Identificador único del bloque de estudio
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
      startTime: _parseTime(map['startTime']),
      endTime: _parseTime(map['endTime']),
    );
  }
  
  static TimeOfDay _parseTime(String timeString) {
    try {
      // Assuming the format is 'TimeOfDay(HH:mm)'
      final timeMatch = RegExp(r'TimeOfDay\((\d{2}):(\d{2})\)').firstMatch(timeString);
      if (timeMatch != null) {
        final hour = int.parse(timeMatch.group(1)!);
        final minute = int.parse(timeMatch.group(2)!);
        return TimeOfDay(hour: hour, minute: minute);
      } else {
        throw FormatException("Invalid time format");
      }
    } catch (e) {
      print('Error parsing time: $e');
      rethrow;
    }
  }
  


}



