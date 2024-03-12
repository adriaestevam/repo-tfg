import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tfg_v1/Data/Models/User-Subject.dart';

import 'package:tfg_v1/Data/Models/StudyBloc.dart';
import 'package:tfg_v1/Data/Models/Subject.dart';
import 'package:tfg_v1/Data/Models/University.dart';
import '../../Data/Models/Users.dart';


class DataService {
  static Database? _database;
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();



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

  Future<List<Subject>> getSubjectsByUniversity(String university) async {
    final Database db = await database;

    // Realizamos la consulta para obtener los temas de la universidad especificada
    final List<Map<String, dynamic>> maps = await db.query(
      'subjects',
      where: 'universityId IN (SELECT id FROM university WHERE name = ?)',
      whereArgs: [university],
    );

    // Convertimos los resultados de la consulta a una lista de objetos Subject
    return List.generate(maps.length, (i) {
      return Subject.fromMap(maps[i]);
    });
  }

  Future<int?> getUserId(String email, String password) async {
    final db = await database; // Asegúrate de obtener la instancia de la base de datos

    // Realizamos la consulta para obtener el ID del usuario
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      columns: ['id'], // Solo necesitamos la columna id
      where: 'email = ? AND password = ?', // Filtramos por email y password
      whereArgs: [email, password],
    );

    // Comprobamos si hemos obtenido algún resultado
    if (maps.isNotEmpty) {
      return maps.first['id'] as int?; // Devolvemos el ID del primer resultado
    }
    return null; // Devolvemos null si no encontramos el usuario
  }

  Future<University?> getUniversityFromCurrentUser() async {
    final db = await database;

    // Obtener el ID del usuario actual de SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt("currentUserId");
    if (userId == null) {
      // Si no hay un usuario actual, devolver null
      print('No current user ID found');
      return null;
    }

    // Realizar la consulta para obtener el usuario actual
    final List<Map<String, dynamic>> userMaps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );

    if (userMaps.isEmpty) {
      // Si no se encuentra el usuario, devolver null
      print('User not found in the database');
      return null;
    }

    // Obtener el ID de la universidad asociada al usuario
    final int universityId = userMaps.first['universityId'] as int;

    // Realizar la consulta para obtener la universidad asociada
    final List<Map<String, dynamic>> universityMaps = await db.query(
      'university', // Asegúrate de que el nombre de la tabla sea correcto
      where: 'id = ?',
      whereArgs: [universityId],
    );

    if (universityMaps.isEmpty) {
      // Si no se encuentra la universidad, devolver null
      print('University not found in the database');
      return null;
    }
    // Crear un objeto University con la información obtenida
    return University.fromMap(universityMaps.first);
  }

    Future<User?> getCurrentUser() async {
    final db = await database;

    // Obtener el ID del usuario actual de SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt("currentUserId");
    if (userId == null) {
      // Si no hay un usuario actual, devolver null
      print('No current user ID found');
      return null;
    }

    // Realizar la consulta para obtener el usuario actual
    final List<Map<String, dynamic>> userMaps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );

    if (userMaps.isEmpty) {
      // Si no se encuentra el usuario, devolver null
      print('User not found in the database');
      return null;
    }

    // Crear un objeto User con la información obtenida
    return User.fromMap(userMaps.first);
  }

  Future<List<Subject>> getSubjectsByUserId(int userId) async {
    final Database db = await database;

    // Realizamos la consulta para obtener las materias del usuario especificado
    final List<Map<String, dynamic>> maps = await db.query(
      'subjects',
      where: 'id IN (SELECT subjectId FROM user_subject WHERE userId = ?)',
      whereArgs: [userId],
    );

    // Convertimos los resultados de la consulta a una lista de objetos Subject
    return List.generate(maps.length, (i) {
      return Subject.fromMap(maps[i]);
    });
  }

  Future<List<StudyBlock>> getStudyBlocksByUserId(int userId) async {
    final Database db = await database;

    // Realizamos la consulta para obtener los bloques de estudio del usuario especificado
    final List<Map<String, dynamic>> maps = await db.query(
      'study_block',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    // Convertimos los resultados de la consulta a una lista de objetos StudyBlock
    return List.generate(maps.length, (i) {
      return StudyBlock.fromMap(maps[i]);
    });
  }

  Future<List<UserSubject>> objectivesAndPrioritiesByUserId(int id) async {
    final db = await database;

    // Realizamos la consulta para obtener los elementos de la tabla user_subject correspondientes al ID de usuario especificado
    final List<Map<String, dynamic>> maps = await db.query(
      'user_subject',
      where: 'userId = ?',
      whereArgs: [id],
    );

    // Convertimos los resultados de la consulta a una lista de objetos UserSubject
    return List.generate(maps.length, (i) {
      return UserSubject.fromMap(maps[i]);
    });
  }

  Future<void> editUserName(String name) async {
    print('Editing user name: $name');
    final db = await database;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt("currentUserId");
    // Actualizar el nombre de usuario en la base de datos
    await db.update(
      'users',
      {'name': name},
      where: 'id = ?',
      whereArgs: [userId],
    );
    print('User name updated successfully $userId');
  }

  Future<void> editEmail(String email) async {
    print('Editing user email: $email');
    final db = await database;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt("currentUserId");
    // Actualizar el correo electrónico del usuario en la base de datos
    await db.update(
      'users',
      {'email': email},
      where: 'id = ?',
      whereArgs: [userId],
    );
    print('User email updated successfully  $userId');
  }

  Future<void> editPassword(String password) async {
    print('Editing user password');
    final db = await database;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt("currentUserId");
    // Actualizar la contraseña del usuario en la base de datos
    await db.update(
      'users',
      {'password': password},
      where: 'id = ?',
      whereArgs: [userId],
    );
    print('User password updated successfully  $userId');
  }

}


