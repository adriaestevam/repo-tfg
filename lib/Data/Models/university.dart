class University {
  int id;      
  final String name;   // Nombre de la universidad

  University({
    required this.id,
    required this.name,
  });

  // Convierte un objeto University a un Map. Útil para insertar en la base de datos
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  // Crea un objeto University a partir de un Map. Útil para leer de la base de datos
  factory University.fromMap(Map<String, dynamic> map) {
    return University(
      id: map['id'],
      name: map['name'],
    );
  }
}
