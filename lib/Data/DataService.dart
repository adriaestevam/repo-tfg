import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tfg_v1/Data/Models/subject.dart';

class DataService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    // Si _database es null, inicializamos la base de datos
    _database = await initDB();
    return _database!;
  }


  initDB() async {
    
    String databasesPath = await getDatabasesPath();
    print(databasesPath);
    print("Inicialización de la base de datos"+databasesPath);
    String path = join(databasesPath, 'app_database.db');

    return await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      // Crear tabla de Usuarios (ya existente)
      await db.execute('''
        CREATE TABLE Usuarios(
          id INTEGER PRIMARY KEY, 
          nombre TEXT, 
          email TEXT, 
          password TEXT
        );
        CREATE TABLE ConfiguracionInicial(
          id INTEGER PRIMARY KEY, 
          user_name TEXT, 
          university TEXT
        );
        CREATE TABLE MateriasSeleccionadas(
          id INTEGER PRIMARY KEY, 
          user_id INTEGER, 
          subject TEXT, 
          selected BOOLEAN
        );
        CREATE TABLE Objetivos(
          id INTEGER PRIMARY KEY, 
          user_id INTEGER, 
          objective TEXT, 
          description TEXT
        );
        CREATE TABLE HorariosEstudio(
          id INTEGER PRIMARY KEY, 
          user_id INTEGER, 
          day TEXT, 
          startTime TEXT, 
          endTime TEXT
        );
      '''
      );
    });
  }

  // Obtener todos los usuarios
  Future<List<Map<String, dynamic>>> obtainUsers() async {
    final db = await database;
    return await db.query('Usuarios');
  }

  // Insertar un nuevo usuario
  Future<void> insertUser(Map<String, dynamic> userInfo) async {
    final db = await database;
    await db.insert(
      'Usuarios',
      userInfo,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );


  }

  Future<void> insertInitialConfiguration(Map<String, dynamic> configInfo) async {
    final db = await database;
    await db.insert('ConfiguracionInicial', configInfo, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertSelectedSubjects(int userId, Map<Subject, bool> selectedSubjects) async {
    final db = await database;
    for (var subject in selectedSubjects.entries) {
      await db.insert('MateriasSeleccionadas', {
        'user_id': userId,
        'subject': subject.key,
        'selected': subject.value ? 1 : 0 // SQLite no tiene boolean, así que usamos int
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<void> insertObjectives(int userId, Map<Subject, String> objectives) async {
    final db = await database;
    for (var objective in objectives.entries) {
      await db.insert('Objetivos', {
        'user_id': userId,
        'objective': objective.key,
        'description': objective.value
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<void> insertStudyBlocs(int userId, Map<String, TimeOfDay> studyStartTimes, Map<String, TimeOfDay> studyEndTimes) async {
    final db = await database;

    // Iterar sobre studyStartTimes y studyEndTimes y insertar en HorariosEstudio
    studyStartTimes.forEach((day, startTime) async {
      var endTime = studyEndTimes[day];
      await db.insert('HorariosEstudio', {
        'user_id': userId,
        'day': day,
        'startTime': _timeOfDayToString(startTime), // Conversión de TimeOfDay a String
        'endTime': _timeOfDayToString(endTime!) // Conversión de TimeOfDay a String
      });
    });
  }

  // Método auxiliar para convertir TimeOfDay a String
  String _timeOfDayToString(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }


  Future<void> printEverything() async {
    final db = await database;

    // Lista de los nombres de todas las tablas
    List<String> tables = ['Usuarios'];

    for (String table in tables) {
      final List<Map<String, dynamic>> results = await db.query(table);
      print('--- Contenido de la tabla $table ---');
      for (var row in results) {
        print(row);
      }
    }
  }
 
}
