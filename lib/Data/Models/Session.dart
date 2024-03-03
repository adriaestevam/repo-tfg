class Session {
  final int id;           // Identificador único de la sesión
  final DateTime startTime; // Fecha y hora de inicio
  final DateTime endTime;   // Fecha y hora de finalización

  Session({
    required this.id,
    required this.startTime,
    required this.endTime,
  });

  // Convierte un objeto Session a un Map. Útil para insertar en la base de datos
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(), // Convertir DateTime a String
      'endTime': endTime.toIso8601String(),     // Convertir DateTime a String
    };
  }

  // Crea un objeto Session a partir de un Map. Útil para leer de la base de datos
  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      id: map['id'],
      startTime: DateTime.parse(map['startTime']), // Convertir String a DateTime
      endTime: DateTime.parse(map['endTime']),     // Convertir String a DateTime
    );
  }
}
