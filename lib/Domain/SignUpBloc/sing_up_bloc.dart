import 'package:bloc/bloc.dart';
import 'package:tfg_v1/Domain/SignUpBloc/sing_up_event.dart';
import 'package:tfg_v1/Domain/SignUpBloc/sing_up_state.dart';
import '../../Data/AuthRepository.dart'; 


class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {

  SignUpBloc({required AuthRepository authRepository}) : super(SignUpInitial()) {
    on<SignUpButtonPressed>((event, emit) async {
      try {
        emit(SignUpLoading());
        
        if (!checkIfPasswordIsSecure(event.password)) { 
          emit(SignUpFailure(
            error: "Password must contain at least one uppercase letter, one lowercase letter, one digit, and one special character"
          ));
          return; // Return early if the password is not secure
        }
        var emailExists= await authRepository.lookForEmail(event.email);

        if(emailExists){
          emit(SignUpFailure(error: "Email already registered. Login or use another email"));
          return;
        }

        var userRegisteredSuccessfully = await authRepository.registerUser(event.email, event.password);

        if(userRegisteredSuccessfully){
          emit(SignUpSuccess());
           await Future.delayed(Duration(seconds: 1));
        }
        else {
          emit(SignUpFailure(error: "Registration error"));
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
    return true;
}
