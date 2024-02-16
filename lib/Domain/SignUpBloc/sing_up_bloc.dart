import 'package:bloc/bloc.dart';
import 'package:tfg_v1/Domain/SignUpBloc/sing_up_event.dart';
import 'package:tfg_v1/Domain/SignUpBloc/sing_up_state.dart';
import '../../Data/AuthRepository.dart'; 


class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {

  SignUpBloc({required AuthRepository authRepository}) : super(SignUpInitial()) {
    on<SignUpButtonPressed>((event, emit) async {
      try {
        emit(SignUpLoading());
        
        if (false) { //!checkIfPasswordIsSecure(event.password)
          emit(SignUpFailure(
            error: "Password must contain at least one uppercase letter, one lowercase letter, one digit, and one special character"
          ));
          return; // Return early if the password is not secure
        }

        // Register user using a request to the auth repo.
        try {
          await authRepository.lookForEmail(event.email);
        } catch (error) {
          emit(SignUpFailure(error: "Error checking email: $error"));
          return;
        }

        try {
          await authRepository.registerUser(event.email, event.password);
          emit(SignUpSuccess());
          await Future.delayed(Duration(seconds: 2));
          emit(SwipeToLoginState()); ////?¿?¿?¿
        } catch (error) {
          emit(SignUpFailure(error: "User registration failed: $error"));
        }
      } catch (error) {
        // If an exception occurs during the sign-up process, emit a failure state
        emit(SignUpFailure(error: error.toString()));
      }
    });  
  }
}

bool checkIfPasswordIsSecure(String password) {
  // Check if the password length is at least 8 characters
  if (password.length < 8) {
    return false;
  }

  // Check if the password contains at least one uppercase letter
  bool hasUppercase = password.contains(RegExp(r'[A-Z]'));

  // Check if the password contains at least one lowercase letter
  bool hasLowercase = password.contains(RegExp(r'[a-z]'));

  // Check if the password contains at least one digit
  bool hasDigit = password.contains(RegExp(r'[0-9]'));

  // Check if the password contains at least one special character
  bool hasSpecialChar =
      password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

  // Check if all criteria are met
  return hasUppercase && hasLowercase && hasDigit && hasSpecialChar;
}
