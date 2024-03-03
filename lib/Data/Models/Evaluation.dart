class Evaluation {
  final int evaluationId; // Identificador único de la evaluación
  final DateTime date;    // Fecha de la evaluación
  final double grade;     // Nota o calificación de la evaluación

  Evaluation({
    required this.evaluationId,
    required this.date,
    required this.grade,
  });

  // Convierte un objeto Evaluation a un Map. Útil para insertar en la base de datos
  Map<String, dynamic> toMap() {
    return {
      'evaluationId': evaluationId,
      'date': date.toIso8601String(), // Convertir DateTime a String
      'grade': grade,
    };
  }

  // Crea un objeto Evaluation a partir de un Map. Útil para leer de la base de datos
  factory Evaluation.fromMap(Map<String, dynamic> map) {
    return Evaluation(
      evaluationId: map['evaluationId'],
      date: DateTime.parse(map['date']), // Convertir String a DateTime
      grade: map['grade'],
    );
  }
}
