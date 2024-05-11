class Event {
  int id;
  final String name;
  final bool isDone;

  Event({
    required this.id,
    required this.name,
    required this.isDone,
  });

  // Convierte un objeto Event a un Map. Útil para insertar en la base de datos
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'isDone': isDone ? 1 : 0, // SQLite no tiene un tipo de dato booleano, por lo que se usa 0 o 1
    };
  }

  // Crea un objeto Event a partir de un Map. Útil para leer de la base de datos
  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      name: map['name'],
      isDone: map['isDone'] == 1, // Convertir 0 o 1 de nuevo a booleano
    );
  }
}
