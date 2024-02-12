import 'package:tfg_v1/Presentation/lib/classes/login_controller.dart';
import 'package:tfg_v1/Presentation/lib/classes/signup_controller.dart';


class UIController {
  final SignUpController _signUpController;
  final LoginController _loginController;

  UIController(this._signUpController, this._loginController);

  // Function to handle the request for email and password
  void askForEmailAndPassword() {
    // Ask the sign-up controller to display the sign-up page
    _signUpController.displaySignUpPage();
  }

  // Function to display a message indicating that the email already exists
  void displayEmailExistsMessage() {
    // Implement logic to display the message in the UI
  }

  // Function to display a message indicating that the password is not secure enough
  void displayPasswordNotSecureMessage() {
    // Implement logic to display the message in the UI
  }

  // Function to display a message indicating successful registration
  void displaySuccessfulRegistrationMessage() {
    // Implement logic to display the message in the UI
  }

  void displayInsecurePasswordMessage() {}

  void displayExistingEmailMessage() {}

  void displaySuccessfulLoginMessage() {}

  void displayInvalidCredentialsMessage() {}
}
