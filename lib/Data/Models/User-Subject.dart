class UserSubject {
  final int userId;     // Clave foránea del usuario
  final int subjectId;  // Clave foránea de la asignatura
  final String objective;  // Objetivo
  final int priority;   // Prioridad
  final int feedback;   // Retroalimentación

  UserSubject({
    required this.userId,
    required this.subjectId,
    required this.objective,
    required this.priority,
    required this.feedback,
  });

  // Convierte un objeto UserSubject a un Map. Útil para insertar en la base de datos
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'subjectId': subjectId,
      'objective': objective,
      'priority': priority,
      'feedback': feedback,
    };
  }

  // Crea un objeto UserSubject a partir de un Map. Útil para leer de la base de datos
  factory UserSubject.fromMap(Map<String, dynamic> map) {
    return UserSubject(
      userId: map['userId'],
      subjectId: map['subjectId'],
      objective: map['objective'],
      priority: map['priority'],
      feedback: map['feedback'],
    );
  }
}
