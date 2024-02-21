import 'package:meta/meta.dart';
import 'DataService.dart';

class AuthRepository {
  final DataService _dataService;

  AuthRepository(this._dataService);

  // Método para buscar un usuario por email y password
  Future<bool> lookForUser(String email, String password) async {
    var users = await _dataService.obtainUsers();
    var userFound = users.any((user) => user['email'] == email && user['password'] == password);

    if (userFound) {
      return true;
    } else {
      return false;
    }
  }

  // Respuestas para el login
  Future<void> userNotFound() async {
    print('User not found');
  }

  Future<void> userFound() async {
    print('User found');
  }

  // Método para buscar un email
  Future<bool> lookForEmail(String email) async {
    var users = await _dataService.obtainUsers();
    var emailExists = users.any((user) => user['email'] == email);

    if (emailExists) {
      return true;
    } else {
      return false;
    }
  }

  // Método para registrar un usuario
  Future<bool> registerUser(String email, String password) async {
    var users = await _dataService.obtainUsers();
    var emailExists = users.any((user) => user['email'] == email);

    if (!emailExists) {
      await _dataService.insertUser({'email': email, 'password': password});
      return true;
    } else {
      return false;
    }
  }

  // Respuestas para el registro
  Future<void> emailNotFound() async {
    print('Email not found');
  }

  Future<void> emailFound() async {
    print('Email found');
  }

  Future<void> userRegisteredSuccessfully() async {
    print('User registered successfully');
  }

  Future<void> userRegistrationError() async {
    print('User registration error');
  }
}
