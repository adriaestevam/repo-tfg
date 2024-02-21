import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    // Si _database es null, inicializamos la base de datos
    _database = await initDB();
    return _database!;
  }

  initDB() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'app_database.db');

    return await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      // Aquí puedes crear las tablas que necesites
      await db.execute('CREATE TABLE Usuarios(id INTEGER PRIMARY KEY, nombre TEXT, email TEXT, password TEXT)');
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
 
}
