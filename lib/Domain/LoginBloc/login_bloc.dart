import 'package:bloc/bloc.dart';
import 'package:tfg_v1/Domain/LoginBloc/login_event.dart';
import 'package:tfg_v1/Domain/LoginBloc/login_state.dart';
import '../../Data/AuthRepository.dart'; 


class LoginBloc extends Bloc<LoginEvent, LoginState> {

  LoginBloc({required AuthRepository authRepository}) : super(LoginInitial()) {
    on<LoginButtonPressed>((event, emit) async {
      try {
        emit(LoginLoading());
        
        // Register user using a request to the auth repo.
        try {
          await authRepository.lookForUser(event.email);
          emit(LoginSucess());
        } catch (error) {
          emit(LoginFailure(error: "Error checking email: $error"));
          return;
        }
        
      } catch (error) {
        // If an exception occurs during the sign-up process, emit a failure state
        emit(LoginFailure(error: error.toString()));
      }
    });  
  }
}
