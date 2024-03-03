class UserSubjectEvent {
  final int userId;    // Clave foránea del usuario
  final int subjectId; // Clave foránea de la asignatura
  final int eventId;   // Clave foránea del evento

  UserSubjectEvent({
    required this.userId,
    required this.subjectId,
    required this.eventId,
  });

  // Convierte un objeto UserSubjectEvent a un Map. Útil para insertar en la base de datos
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'subjectId': subjectId,
      'eventId': eventId,
    };
  }

  // Crea un objeto UserSubjectEvent a partir de un Map. Útil para leer de la base de datos
  factory UserSubjectEvent.fromMap(Map<String, dynamic> map) {
    return UserSubjectEvent(
      userId: map['userId'],
      subjectId: map['subjectId'],
      eventId: map['eventId'],
    );
  }
}
