import 'dart:math';

import 'package:flutter/src/material/time.dart';
import 'package:meta/meta.dart';
import 'package:tfg_v1/Data/Models/StudyBloc.dart';
import 'package:tfg_v1/Data/Models/User-Subject.dart';
import 'package:tfg_v1/Data/Models/Users.dart';
import 'package:tfg_v1/Data/Models/Subject.dart';
import 'package:tfg_v1/Data/Models/University.dart';
import '../DataService.dart';

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
  Future<bool> registerUser(User newuser) async {
    await _dataService.printEverything();

    var users = await _dataService.obtainUsers();
    var emailExists = users.any((user) => user['email'] == newuser.email);

    if (!emailExists) {
      _dataService.registerUser(newuser);
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

  //Initial Configuration

  //Request
 

  getUniversityID(String university) {
    return _dataService.getUniversityId(university);
  }

  checkIfUniversityRegistered(String university) async {
    var universities = await _dataService.obtainUniversities();
    var universityIsRegistered = universities.any((university) => university == university.name);
    if(universityIsRegistered){return true;} else {return false;}
  }

  registerUniversity(University university) {
    _dataService.registerUniversity(university);

  }

  registerSubject(Subject subject) {
    _dataService.registerSubject(subject);
  }

  registerUserSubject(UserSubject userSubject) {
    _dataService.registerUserSubject(userSubject);
  }

  registerStudyBlock(StudyBlock studyBlock) {
    _dataService.registerStudyBlock(studyBlock);
    print("registerstudyblock");
    _dataService.printEverything();

  }

  getSubjectsByUniversity(String university) {
    return _dataService.getSubjectsByUniversity(university);
  }

  getUserId(String email, String password) {
    return _dataService.getUserId(email,password);
  }
}

