import '../Persistance/authDAO.dart';

class SignUpManager {
  final AuthDAO _authDAO;

  SignUpManager(this._authDAO);

  // Check if the password meets security requirements
  bool checkPasswordSecurity(String password) {
    // Implement logic to check password security
    // Example: Check password length, complexity, etc.
    return password.length >= 8; // Example: Password must be at least 8 characters long
  }

  // Look for email in the database
  Future<bool> lookForEmail(String email) {
    return _authDAO.lookForEmail(email);
  }

  // Register the user in the database
  void registerUser(String email, String password) {
    // Implement logic to register the user
    _authDAO.addUser({'email': email, 'password': password});
  }
}
