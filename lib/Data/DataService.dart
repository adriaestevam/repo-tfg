import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tfg_v1/Data/Models/StudyBloc.dart';
import 'package:tfg_v1/Data/Models/User-Subject.dart';
import 'package:tfg_v1/Data/Models/Users.dart';
import 'package:tfg_v1/Data/Models/subject.dart';

import 'Models/university.dart';

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
    String path = join(databasesPath, 'v2.db');

    return await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      // Crear tabla de Usuarios (ya existente)
      await db.execute('''
        CREATE TABLE users(
          id INTERGER PRIMARY KEY,
          name TEXT,
          email TEXT,
          password TEXT,
          universityId INTERGER,
          FOREIGN KEY(universityId) REFERENCES university(id)
        )
      ''');

      await db.execute('''
        CREATE TABLE subjects(
          id INTERGER PRIMARY KEY,
          name TEXT,
          credits INTERGER,
          formula TEXT,
          universityId INTERGER,
          FOREIGN KEY(universityId) REFERENCES university(id)
        )
      ''');

      await db.execute('''
        CREATE TABLE university(
          id INTEGER PRIMARY KEY,
          name TEXT
        )
      ''');

      await db.execute('''
        CREATE TABLE study_block(
          id INTEGER PRIMARY KEY,
          userId INTEGER,
          day TEXT,
          startTime TEXT,
          endTime TEXT,
          FOREIGN KEY(userId) REFERENCES users(id)
        )
      ''');

      await db.execute('''
        CREATE TABLE event(
          id INTEGER PRIMARY KEY,
          name TEXT,
          isDone INTEGER
        )
      ''');

      await db.execute('''
        CREATE TABLE session(
          id INTEGER PRIMARY KEY,
          startTime TEXT,
          endTime TEXT,
          FOREIGN KEY(id) REFERENCES event(id)
        )
      ''');

      await db.execute('''
        CREATE TABLE evaluation(
          id INTEGER PRIMARY KEY,
          date TEXT,
          grade REAL,
          FOREIGN KEY(id) REFERENCES event(id)
        )
      ''');

      await db.execute('''
        CREATE TABLE plan(
          userId INTEGER,
          subjectId INTEGER,
          sessionId INTEGER,
          PRIMARY KEY (userId, subjectId, sessionId),
          FOREIGN KEY(userId) REFERENCES users(id),
          FOREIGN KEY(subjectId) REFERENCES subjects(id),
          FOREIGN KEY(sessionId) REFERENCES session(id)
        )
      ''');

      await db.execute('''
        CREATE TABLE user_subject(
          userId INTEGER,
          subjectId INTEGER,
          objective INTEGER,
          priority INTEGER,
          feedback INTEGER,
          PRIMARY KEY (userId, subjectId),
          FOREIGN KEY(userId) REFERENCES users(id),
          FOREIGN KEY(subjectId) REFERENCES subjects(id)
        )
      ''');

      await db.execute('''
        CREATE TABLE user_subject_event(
          userId INTEGER,
          subjectId INTEGER,
          eventId INTEGER,
          PRIMARY KEY (userId, subjectId, eventId),
          FOREIGN KEY(userId) REFERENCES users(id),
          FOREIGN KEY(subjectId) REFERENCES subjects(id),
          FOREIGN KEY(eventId) REFERENCES events(id)
        )
      ''');

    });
  }

  // Obtener todos los usuarios
  Future<List<Map<String, dynamic>>> obtainUsers() async {
    final db = await database;
    return await db.query('users');
  }

  // Insertar un nuevo usuario
  Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertUniversity(University university) async {
    final db = await database; // Asegúrate de que 'database' es tu instancia de la base de datos SQLite
    await db.insert(
      'university',
      university.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertSubject(Subject subject) async {
    final db = await database;
    await db.insert(
      'subjects',
      subject.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertStudyBlock(StudyBlock studyBlock) async {
    final db = await database;
    await db.insert(
      'study_block',
      studyBlock.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  Future<void> printEverything() async {
    final db = await database;

    // Lista de los nombres de todas las tablas
    List<String> tables = ['users','subjects','user_subject','university','study_block'];

    for (String table in tables) {
      final List<Map<String, dynamic>> results = await db.query(table);
      print('--- Contenido de la tabla $table ---');
      for (var row in results) {
        print(row);
      }
    }
  }

  Future<int?> getUniversityId(String universityName) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'university',
      columns: ['id'],
      where: 'name = ?',
      whereArgs: [universityName],
    );
    if (maps.isNotEmpty) {
      return maps.first['id'] as int;
    }
    return null;
  }


  Future<List<University>> obtainUniversities() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('university');
    return List.generate(maps.length, (i) {
      return University.fromMap(maps[i]);
    });
  }


  Future<void> registerUniversity(University university) async {
    final db = await database;
    await db.insert(
      'university',
      university.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  Future<void> registerSubject(Subject subject) async {
    final db = await database;
    await db.insert(
      'subjects',
      subject.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  Future<void> registerUserSubject(UserSubject userSubject) async {
    final db = await database;
    await db.insert(
      'user_subject',
      userSubject.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  Future<void> registerStudyBlock(StudyBlock studyBlock) async {
    final db = await database;
    await db.insert(
      'study_block',
      studyBlock.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> registerUser(User newuser) async {
    final db = await database;
    await db.insert(
      'users', 
      newuser.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace);
  }

 
}