class Plan {
  final int userId;
  final DateTime initialDate;  // Clave foránea de la asignatura y parte de la clave primaria
   // Clave foránea de la sesión y parte de la clave primaria

  Plan({
    required this.userId,
    required this.initialDate,
  });

  // Convierte un objeto Plan a un Map. Útil para insertar en la base de datos
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'initialDate': initialDate,
    };
  }

  // Crea un objeto Plan a partir de un Map. Útil para leer de la base de datos
  factory Plan.fromMap(Map<String, dynamic> map) {
    return Plan(
      userId: map['userId'],
      initialDate: map['initialDate'],
    );
  }
}
