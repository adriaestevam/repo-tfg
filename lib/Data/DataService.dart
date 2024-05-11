import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tfg_v1/Data/Models/Evaluation.dart';
import 'package:tfg_v1/Data/Models/Event.dart';
import 'package:tfg_v1/Data/Models/Plan.dart';
import 'package:tfg_v1/Data/Models/Session.dart';
import 'package:tfg_v1/Data/Models/User-Subject-Event.dart';
import 'package:tfg_v1/Data/Models/User-Subject.dart';
import 'package:tfg_v1/Data/Models/StudyBloc.dart';
import 'package:tfg_v1/Data/Models/Subject.dart';
import 'package:tfg_v1/Data/Models/University.dart';
import 'package:tfg_v1/Domain/CalendarBloc/calendar_bloc.dart';
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
    String path = join(databasesPath, 'v3.db');

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
          initialDate TEXT,
          PRIMARY KEY (userId, initialDate),
          FOREIGN KEY(userId) REFERENCES users(id)
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
    print('Fetching StudyBlocks for user ID: $userId');
    
    final List<Map<String, dynamic>> maps = await db.query(
      'study_block',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    print('StudyBlocks raw data: $maps');

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




 
  Future<void> updateUserFromProfileSettings(User user, String currentName, String currentMail, String currentPassword) async {
    final db = await database;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt("currentUserId");

    Map<String, dynamic> updatedFields = {};

    // Verificar si el nombre es diferente y no está vacío
    if (user.name != currentName && currentName.isNotEmpty) {
      print('Changing user name from ${user.name} to $currentName');
      updatedFields['name'] = currentName;
    }

    // Verificar si el correo electrónico es diferente y no está vacío
    if (user.email != currentMail && currentMail.isNotEmpty) {
      print('Changing user email from ${user.email} to $currentMail');
      updatedFields['email'] = currentMail;
    }

    // Verificar si la contraseña es diferente y no está vacía
    if (user.password != currentPassword && currentPassword.isNotEmpty) {
      print('Changing user password');
      updatedFields['password'] = currentPassword;
    }

    // Actualizar los campos en la base de datos si hay cambios
    if (updatedFields.isNotEmpty) {
      await db.update(
        'users',
        updatedFields,
        where: 'id = ?',
        whereArgs: [userId],
      );
      print('User updated successfully');
    } else {
      print('No changes detected');
    }
  }

  Future<void> addNewEvaluation(Evaluation evaluation, Event event, UserSubjectEvent userSubjectEvent) async {
    final db = await database;
    
    // Insertar evento
    await db.insert('event', event.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

    // Insertar evaluación
    await db.insert('evaluation', evaluation.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

    // Insertar UserSubjectEvent
    await db.insert('user_subject_event', userSubjectEvent.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> addNewSession(Session session, Event event, UserSubjectEvent userSubjectEvent) async {
    final db = await database;
    
    // Insertar evento
    await db.insert('event', event.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

    // Insertar evaluación
    await db.insert('session', session.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

    // Insertar UserSubjectEvent
    await db.insert('user_subject_event', userSubjectEvent.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }


  Future<List<Event>> uploadEvents() async {
    final db = await database;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt("currentUserId");

    List<Event> userEvents = [];

    if (userId == null) {
      print('No current user ID found');
      return userEvents;
    }

    // Obtener todos los UserSubjectEvent que corresponden al usuario
    final List<Map<String, dynamic>> userSubjectEventMaps = await db.query(
      'user_subject_event',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    // Convertir los mapas a objetos UserSubjectEvent
    List<UserSubjectEvent> userSubjectEvents = userSubjectEventMaps.map((map) => UserSubjectEvent.fromMap(map)).toList();

    // Para cada UserSubjectEvent, obtener el detalle del evento
    for (UserSubjectEvent userSubjectEvent in userSubjectEvents) {
      final List<Map<String, dynamic>> eventMaps = await db.query(
        'event',
        where: 'id = ?',
        whereArgs: [userSubjectEvent.eventId],
      );

      if (eventMaps.isNotEmpty) {
        userEvents.add(Event.fromMap(eventMaps.first));
      }
    }

    return userEvents;
  }
              



  Future<List<Evaluation>> uploadEvaluations() async {
    final db = await database;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt("currentUserId");

    List<Evaluation> userEvaluations = [];

    if (userId == null) {
      print('No current user ID found');
      return userEvaluations;
    }

    // Obtener todos los UserSubjectEvent que corresponden al usuario
    final List<Map<String, dynamic>> userSubjectEvents = await db.query(
      'user_subject_event',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    // Para cada UserSubjectEvent, obtener el detalle de la evaluación
    for (var userSubjectEventMap in userSubjectEvents) {
      final eventId = userSubjectEventMap['eventId'] as int;
      final List<Map<String, dynamic>> evaluationMaps = await db.query(
        'evaluation',
        where: 'id = ?',
        whereArgs: [eventId],
      );

      // Procesar las evaluaciones obtenidas
      for (var evaluationMap in evaluationMaps) {
        // Suponiendo que la clase Evaluation tiene un constructor fromMap
        Evaluation evaluation = Evaluation.fromMap(evaluationMap);
        userEvaluations.add(evaluation);
      }
    }
    return userEvaluations; 
  }

  Future<bool> checkUserHasEvents() async {
    final db = await database;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt("currentUserId");

    if (userId == null) {
      print('No current user ID found');
      return false;
    }

    // Comprobar si existen eventos asociados con el usuario
    final List<Map<String, dynamic>> userSubjectEvents = await db.query(
      'user_subject_event',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    // Si la lista no está vacía, significa que hay eventos asociados con el usuario
    return userSubjectEvents.isNotEmpty;
  }

  Future<bool> checkUserHasEvaluations() async {
    final db = await database;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt("currentUserId");

    if (userId == null) {
      print('No current user ID found');
      return false;
    }

    // Comprobar si existen evaluaciones asociadas con el usuario
    final List<Map<String, dynamic>> userSubjectEvents = await db.query(
      'user_subject_event',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    // Verificar si cada evento es una evaluación
    bool hasEvaluations = false;
    for (var userSubjectEvent in userSubjectEvents) {
      final eventId = userSubjectEvent['eventId'] as int;
      final List<Map<String, dynamic>> evaluationMaps = await db.query(
        'evaluation',
        where: 'id = ?',
        whereArgs: [eventId],
      );
      if (evaluationMaps.isNotEmpty) {
        hasEvaluations = true;
        break;
      }
    }
    print('hasevaluations es ahora mismo ${hasEvaluations}');
    return hasEvaluations;
  }


  Future<bool> checkUserHasSessions() async {
      return false;
  }


  Future<List<Session>> uploadSessions() async {
 
    final db = await database;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt("currentUserId");
    

    List<Session> userSessions = [];

    if (userId == null) {
      print('No current user ID found');
      return userSessions;
    }

    // Obtener todos los UserSubjectEvent que corresponden al usuario
    final List<Map<String, dynamic>> userSubjectEvents = await db.query(
      'user_subject_event',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    // Para cada UserSubjectEvent, obtener el detalle de la evaluación
    for (var userSubjectEventMap in userSubjectEvents) {
     
      final eventId = userSubjectEventMap['eventId'] as int;
      final List<Map<String, dynamic>> sessionMaps = await db.query(
        'session',
        where: 'id = ?',
        whereArgs: [eventId],
      );

      // Procesar las evaluaciones obtenidas
      for (var sessionsMap in sessionMaps) {
      
        // Suponiendo que la clase Evaluation tiene un constructor fromMap
        Session session = Session.fromMap(sessionsMap);
        userSessions.add(session);
       
      }
    }
    return userSessions; 
  }

  Future<List<UserSubjectEvent>> uploadUserSubjectEvents() async {
    final db = await database;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt("currentUserId");

    if (userId == null) {
      print('No current user ID found');
      return throw Exception('No user found for user subject event');
    }
    final List<Map<String, dynamic>> maps = await db.query(
      'user_subject_event',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    return List.generate(maps.length, (i) {
      return UserSubjectEvent.fromMap(maps[i]);
    });
  }

  Future<void> deleteSessionEvent(int sessionId) async {
    final db = await database;
    
    // Eliminar la sesión de la tabla 'session'
    await db.delete(
      'session',
      where: 'id = ?',
      whereArgs: [sessionId],
    );

    // También eliminar el evento asociado en la tabla 'event'
    await db.delete(
      'event',
      where: 'id = ?',
      whereArgs: [sessionId],
    );

    // Opcionalmente, si se necesita, eliminar la relación en la tabla 'user_subject_event'
    await db.delete(
      'user_subject_event',
      where: 'eventId = ?',
      whereArgs: [sessionId],
    );
  }

  Future<void> deleteEvaluationEvent(int evaluationId) async {
    final db = await database;
    
    // Eliminar la evaluación de la tabla 'evaluation'
    await db.delete(
      'evaluation',
      where: 'id = ?',
      whereArgs: [evaluationId],
    );

    // También eliminar el evento asociado en la tabla 'event'
    await db.delete(
      'event',
      where: 'id = ?',
      whereArgs: [evaluationId],
    );

    // Opcionalmente, si se necesita, eliminar la relación en la tabla 'user_subject_event'
    await db.delete(
      'user_subject_event',
      where: 'eventId = ?',
      whereArgs: [evaluationId],
    );
  }

  Future<void> updateEvaluation(Event newEvent, Evaluation newEvaluation, UserSubjectEvent newUserSubjectEvent) async {
    final db = await database;

    // Actualizar el evento en la tabla 'event'
    await db.update(
      'event',
      newEvent.toMap(),
      where: 'id = ?',
      whereArgs: [newEvent.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Actualizar la evaluación en la tabla 'evaluation'
    await db.update(
      'evaluation',
      newEvaluation.toMap(),
      where: 'id = ?',
      whereArgs: [newEvaluation.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Actualizar la relación en la tabla 'user_subject_event'
    await db.update(
      'user_subject_event',
      newUserSubjectEvent.toMap(),
      where: 'eventId = ?',
      whereArgs: [newUserSubjectEvent.eventId],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<void> updateSession(Event newEvent, Session newSession, UserSubjectEvent newUserSubjectEvent) async {
    final db = await database;

    // Actualizar el evento en la tabla 'event'
    await db.update(
      'event',
      newEvent.toMap(),
      where: 'id = ?',
      whereArgs: [newEvent.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Actualizar la evaluación en la tabla 'evaluation'
    await db.update(
      'session',
      newSession.toMap(),
      where: 'id = ?',
      whereArgs: [newSession.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Actualizar la relación en la tabla 'user_subject_event'
    await db.update(
      'user_subject_event',
      newUserSubjectEvent.toMap(),
      where: 'eventId = ?',
      whereArgs: [newUserSubjectEvent.eventId],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Method to check if the current user has a plan
  Future<bool> checkUserHasPlan() async {
    final db = await database; // Get the database instance
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt("currentUserId");

    if (userId == null) {
      print('No current user ID found');
      return false; // If there's no current user, return false
    }

    // Query the 'plan' table to check for entries corresponding to the current user
    final List<Map<String, dynamic>> plans = await db.query(
      'plan',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    // Return true if there are entries, else false
    return plans.isNotEmpty;
  }

  Future<Map<String, dynamic>> getUserPlanData() async {
    final db = await database;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt("currentUserId");

    if (userId == null) {
      print('No current user ID found');
      return {}; // Si no hay usuario actual, devuelve un mapa vacío
    }

    print('Current user ID: $userId');
    print('hola');
    // Obtener StudyBlocks del usuario actual
    List<StudyBlock> studyBlocks = await getStudyBlocksByUserId(userId);
    print('StudyBlocks retrieved: ${studyBlocks.length} items');

    // Obtener Subjects del usuario actual
    List<Subject> subjects = await getSubjectsByUserId(userId);
    print('Subjects retrieved: ${subjects.length} items');

    // Obtener UserSubjects del usuario actual
    List<UserSubject> userSubjects = await objectivesAndPrioritiesByUserId(userId);
    print('UserSubjects retrieved: ${userSubjects.length} items');

    // Obtener Events del usuario actual
    List<Event> events = await uploadEvents(); // Esta función ya filtra por usuario actual
    print('Events retrieved: ${events.length} items');

    // Obtener Evaluations del usuario actual
    List<Evaluation> evaluations = await uploadEvaluations(); // Esta función ya filtra por usuario actual
    print('Evaluations retrieved: ${evaluations.length} items');

    // Obtener UserSubjectEvents del usuario actual
    List<UserSubjectEvent> userSubjectEvents = await uploadUserSubjectEvents();
    print('UserSubjectEvents retrieved: ${userSubjectEvents.length} items');

    Map<String, dynamic> planData = {
      'studyBlocks': studyBlocks,
      'subjects': subjects,
      'userSubjects': userSubjects,
      'events': events,
      'evaluations': evaluations,
      'userSubjectEvents': userSubjectEvents,
    };

    print('Plan data prepared for the user: $planData');

      return planData;
  }

  Future<void> addPlan(List<Event> eventsFromPlan, List<Session> sessionsFromPlan, List<UserSubjectEvent> userSubjectEventsFromPlan, Plan plan) async {
    final db = await database;  // Ensure database is initialized and ready
  

    // Begin a batch to perform multiple insertions atomically
    Batch batch = db.batch();

    // Insert the Plan into the 'plans' table
    // Ensure the date is stored in ISO-8601 string format (YYYY-MM-DDTHH:MM:SS.sssZ)
    batch.insert(
      'plan',
      {
        'userId': plan.userId,
        'initialDate': plan.initialDate.toIso8601String()
      },
      conflictAlgorithm: ConflictAlgorithm.replace
    );

    // Insert each Event into the 'event' table
    for (Event event in eventsFromPlan) {
      batch.insert(
        'event',
        event.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace
      );
    }

    // Insert each Session into the 'session' table
    for (Session session in sessionsFromPlan) {
      batch.insert(
        'session',
        session.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace
      );
    }

    // Insert each UserSubjectEvent into the 'user_subject_event' table
    for (UserSubjectEvent userSubjectEvent in userSubjectEventsFromPlan) {
      batch.insert(
        'user_subject_event',
        userSubjectEvent.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace
      );
    }

    // Commit the batch
    await batch.commit(noResult: true);  // noResult: true can improve performance when the results are not needed

    print('Plan data has been successfully added to the database.');

  }

  Future<void> deleteStudyBlock(StudyBlock oldBlock) async {
    final db = await database; // Ensure that the database instance is obtained

    // Delete the study block from the 'study_block' table
    int result = await db.delete(
      'study_block',
      where: 'id = ?', // Use a WHERE clause to specify which study block to delete
      whereArgs: [oldBlock.id] // Provide the ID of the study block to delete
    );

    if (result != 0) {
      print('Study block deleted successfully');
    } else {
      print('Error deleting study block');
    }
  }

  Future<void> addNewStudyBlock(StudyBlock newBlock) async {
    final db = await database; // Ensure that the database instance is obtained

    // Insert the new study block into the 'study_block' table
    int id = await db.insert(
      'study_block',
      newBlock.toMap(), // Convert the StudyBlock instance into a Map
      conflictAlgorithm: ConflictAlgorithm.replace // Handle any conflicts by replacing the old data
    );

    if (id != 0) {
      print('Study block added successfully with id $id');
    } else {
      print('Failed to add study block');
    }
  }

  Future<void> saveChangesRetros(Map<int, double> updatedGrades, Map<int, bool> selectedSessions) async {
    final db = await database;

    // Begin a transaction to ensure all operations are executed together
    await db.transaction((txn) async {
      // Update evaluation grades and mark the corresponding event as done in one loop
      for (var entry in updatedGrades.entries) {
        // Update evaluation grades based on updatedGrades map
        await txn.update(
          'evaluation',
          {'grade': entry.value},
          where: 'id = ?',
          whereArgs: [entry.key]
        );

        // Mark the corresponding event as done, regardless of its current isDone status
        await txn.update(
          'event',
          {'isDone': 1}, // Set isDone to true (1) for the corresponding event
          where: 'id = ?',
          whereArgs: [entry.key]
        );
      }

      for (var entry in selectedSessions.entries) {
        if (entry.value) { // Only update if the session is selected
          await txn.update(
            'event',
            {'isDone': 1}, // Assuming 'isDone' is stored as INTEGER (1 for true)
            where: 'id = ?',
            whereArgs: [entry.key]
          );
        }
      }
    });

    print("Changes to evaluations and events have been saved successfully.");
  }

  Future<void> updateFeedbackFromSubject(int subjectId, int feedback) async {
    final db = await database; // Asegúrate de que la instancia de la base de datos está obtenida

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt("currentUserId");

    if (userId == null) {
      print('No current user ID found');
      return; // Si no hay usuario actual, termina la función prematuramente
    }

    // Comienza una transacción para asegurar que la actualización es atómica
    await db.transaction((txn) async {
      int count = await txn.update(
        'user_subject', // Asume que 'user_subject' es el nombre de la tabla
        {'feedback': feedback}, // El nuevo valor para el campo 'feedback'
        where: 'userId = ? AND subjectId = ?',
        whereArgs: [userId, subjectId]
      );

      if (count != 0) {
        print('Feedback updated successfully for subject ID $subjectId and user ID $userId');
      } else {
        print('Failed to update feedback or no matching record found');
      }
    });
  }

  Future<int> getUserCurrentFeedback(int subjectId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt("currentUserId");

    if (userId == null) {
      throw Exception("No current user ID found");
    }

    final db = await database; // Ensure you await the database here

    // Now that db is a Database instance, you can use the query method
    List<Map<String, dynamic>> results = await db.query(
      'user_subject', // Name of the table
      columns: ['feedback'], // Column to retrieve
      where: 'userId = ? AND subjectId = ?', // Condition to match the correct user_subject
      whereArgs: [userId, subjectId], // Arguments for the WHERE clause
    );

    if (results.isNotEmpty) {
      // Return the feedback value if found
      return results.first['feedback'];
    } else {
      // No feedback found, handle appropriately
      throw Exception("No feedback record found for user $userId and subject $subjectId");
    }
  }

  
}

