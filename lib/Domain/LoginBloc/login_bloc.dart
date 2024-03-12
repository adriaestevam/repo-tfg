import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfg_v1/Domain/LoginBloc/login_event.dart';
import 'package:tfg_v1/Domain/LoginBloc/login_state.dart';
import '../../Data/Repositories/AuthRepository.dart'; 


class LoginBloc extends Bloc<LoginEvent, LoginState> {
final Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  LoginBloc({required AuthRepository authRepository}) : super(LoginInitial()) {
    on<LoginButtonPressed>((event, emit) async {
      emit(LoginLoading());
      try {        
        // Register user using a request to the auth repo.
        print("hola");
          bool userFound = await authRepository.lookForUser(event.email, event.password);

          if (userFound) {
            emit(LoginSucess());
            int userId = await authRepository.getUserId(event.email,event.password);
            

          prefs.then((SharedPreferences preferences) {
            preferences.setInt("currentUserId", userId);
          });

          } else {
            emit(LoginFailure(error: 'User not found'));
          }

      } catch (error) {
        // If an exception occurs during the sign-up process, emit a failure state
        emit(LoginFailure(error: error.toString()));
      }
    });  
    on<setLoginInitial>((event, emit) async {
      try{
        emit(LoginInitial());
      } catch(error){

      }
     
    });  
  }
}
