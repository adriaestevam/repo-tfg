import 'package:tfg_v1/Business/signup_manager.dart';
import '../Presentation/lib/classes/UIController.dart';
import '../Business/login_manager.dart';

class BusinessFacade {
  
  final UIController _uiController;
  final SignUpManager _signUpManager;
  final LoginManager _loginManager;

  BusinessFacade(
    this._uiController,
    this._signUpManager,
    this._loginManager,
  );

  Future<void> signUp(String email, String password) async {
    // Ask the SignUpManager to check password security
    final isSecurePassword = _signUpManager.checkPasswordSecurity(password);

    if (!isSecurePassword) {
      // Ask UI to display message about insecure password
      _uiController.displayInsecurePasswordMessage();
      return;
    }

    // Check if email already exists
    final emailExists = await _signUpManager.lookForEmail(email);
    if (emailExists) {
      // Ask UI to display message about existing email
      _uiController.displayExistingEmailMessage();
      return;
    }

    // Register user if email doesn't exist and password is secure
    _signUpManager.registerUser(email, password);

    // Ask UI to display successful registration message
    _uiController.displaySuccessfulRegistrationMessage();
  }

  Future<void> login(String email, String password) async {
    // Check if email and password combination exists
    final isValidCredentials = await _loginManager.lookForEmailAndPassword(email, password);

    if (isValidCredentials) {
      // Ask UI to display successful login message
      _uiController.displaySuccessfulLoginMessage();
    } else {
      // Ask UI to display invalid credentials message
      _uiController.displayInvalidCredentialsMessage();
    }
  }

}

