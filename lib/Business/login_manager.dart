import '../Persistance/authDAO.dart';

class LoginManager {
  final AuthDAO _authDAO;

  LoginManager(this._authDAO);

  // Check if the provided email and password match a user in the database
  bool authenticateUser(String email, String password) {
    // Retrieve user information from the database based on the provided email and password
    Future<Map<String, dynamic>?> userData = _authDAO.lookForEmailAndPassword(email, password);
    
    // If userData is not null, authentication succeeds
    return userData != null;
  }

  // Get the email associated with the provided email address
  String? getEmail(String email) {
    // Retrieve user information from the database based on the provided email
    Map<String, dynamic>? userData = _authDAO.getUserByEmail(email);
    
    // If userData is not null, return the email associated with the user
    return userData?['email'];
  }

  lookForEmailAndPassword(String email, String password) {}
}
