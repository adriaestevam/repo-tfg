import 'package:tfg_v1/Data/Models/university.dart';

class User {
  final int id;       // Asumiendo que el id es un entero
  final int universityId;
  final String name;
  final String email;
  final String password;

  User({
    required this.id,
    required this.universityId,
    required this.name,
    required this.email,
    required this.password,
  });

  // Convierte un objeto User a un Map. Útil para insertar en la base de datos
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'universityId':universityId,
      'name': name,
      'email': email,
      'password': password,
    };
  }

  // Crea un objeto User a partir de un Map. Útil para leer de la base de datos
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      universityId: map['universityId'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
    );
  }
}
