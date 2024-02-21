import 'package:bloc/bloc.dart';
import 'package:tfg_v1/Domain/LoginBloc/login_event.dart';
import 'package:tfg_v1/Domain/LoginBloc/login_state.dart';
import '../../Data/AuthRepository.dart'; 


class LoginBloc extends Bloc<LoginEvent, LoginState> {

  LoginBloc({required AuthRepository authRepository}) : super(LoginInitial()) {
    on<LoginButtonPressed>((event, emit) async {
      emit(LoginLoading());
      try {        
        // Register user using a request to the auth repo.
        print("hola");
          bool userFound = await authRepository.lookForUser(event.email, event.password);

          if (userFound) {
            emit(LoginSucess());
          } else {
            emit(LoginFailure(error: 'User not found'));
          }

      } catch (error) {
        // If an exception occurs during the sign-up process, emit a failure state
        emit(LoginFailure(error: error.toString()));
      }
    });  
  }
}
