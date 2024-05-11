class Subject {
  int id;           // Identificador único de la asignatura   
  final int universityId;
  final String name;      //Nombre de la asignatura
  final int credits;      // Número de créditos de la asignatura
  final String formula;   // Fórmula asociada a la asignatura, representada como texto

  Subject({
    required this.id,
    required this.universityId,
    required this.name,
    required this.credits,
    required this.formula,
  });

  // Convierte un objeto Subject a un Map. Útil para insertar en la base de datos
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'universityId':universityId,
      'name':name,
      'credits': credits,
      'formula': formula,
    };
  }

  // Crea un objeto Subject a partir de un Map. Útil para leer de la base de datos
  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      id: map['id'],
      universityId: map['universityId'],
      name: map['name'],
      credits: map['credits'],
      formula: map['formula'],
    );
  }
}
