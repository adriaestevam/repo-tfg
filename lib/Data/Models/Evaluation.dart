class Evaluation {

  int id; // Identificador único de la evaluación
  final DateTime date;    // Fecha de la evaluación
  final double grade; 
      // Nota o calificación de la evaluación

  Evaluation({
    required this.id,
    required this.date,
    required this.grade,
  });

  // Convierte un objeto Evaluation a un Map. Útil para insertar en la base de datos
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(), // Convertir DateTime a String
      'grade': grade,
    };
  }

  // Crea un objeto Evaluation a partir de un Map. Útil para leer de la base de datos
  factory Evaluation.fromMap(Map<String, dynamic> map) {
    return Evaluation(
      id: map['id'],
      date: DateTime.parse(map['date']), // Convertir String a DateTime
      grade: map['grade'],
    );
  }
}
