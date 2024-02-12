class AuthDAO {
  final Database _database;

  AuthDAO(this._database);

  Future<void> addUser(Map<String, dynamic> userData) async {
    await _database.insert(
      'users',
      userData
    );
  }

  Future<void> updateUser(int id, Map<String, dynamic> userData) async {
    await _database.update(
      'users',
      userData,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteUser(int id) async {
    await _database.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Map<String, dynamic>?> getUserById(int id) async {
    List<Map<String, dynamic>> users = await _database.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    return users.isNotEmpty ? users.first : null;
  }

  Future<bool> lookForEmail(String email) async {
    List<Map<String, dynamic>> users = await _database.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return users.isNotEmpty;
  }

  Future<Map<String, dynamic>?> lookForEmailAndPassword(
      String email, String password) async {
    List<Map<String, dynamic>> users = await _database.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return users.isNotEmpty ? users.first : null;
  }

  Map<String, dynamic>? getUserByEmail(String email) {}
}

class Database {
  query(String s, {required String where, required List<dynamic> whereArgs}) {}
  
  update(String s, Map<String, dynamic> userData, {required String where, required List<dynamic> whereArgs}) {}
  
  insert(String s, Map<String, dynamic> userData) {}
  
  delete(String s, {required String where, required List<dynamic> whereArgs}) {}
}

