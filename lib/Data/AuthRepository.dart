import 'package:meta/meta.dart';

class AuthRepository {
  Future<void> lookForEmail(String email) async {
    // Simular la búsqueda de correo electrónico
    // Aquí puedes agregar la lógica de simulación necesaria
    await Future.delayed(Duration(seconds: 1));
    return emailNotFound();
  }

  Future<void> registerUser(String email, String password) async {
    // Simular el registro de usuario
    // Aquí puedes agregar la lógica de simulación necesaria
    await Future.delayed(Duration(seconds: 1));
    return userRegisteredSuccessfully();
  }

  // Respuestas
  Future<void> emailNotFound() async {
    // Devuelve un resultado cuando el correo electrónico no se encuentra
    print('Email not found');
  }

  Future<void> emailFound() async {
    // Devuelve un resultado cuando el correo electrónico se encuentra
    print('Email found');
  }

  Future<void> userRegisteredSuccessfully() async {
    // Devuelve un resultado cuando el usuario se registra con éxito
    print('User registered successfully');
  }

  Future<void> userRegistrationError() async {
    // Devuelve un resultado cuando ocurre un error durante el registro del usuario
    print('User registration error');
  }
}
