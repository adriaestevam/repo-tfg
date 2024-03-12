import 'package:bloc/bloc.dart';
import 'package:tfg_v1/Data/Models/Users.dart';
import 'package:tfg_v1/Data/Repositories/UserRepository.dart';
import 'package:tfg_v1/Domain/UserBloc/user_event.dart';
import 'package:tfg_v1/Domain/UserBloc/user_state.dart';

import 'package:tfg_v1/Data/Models/StudyBloc.dart';

import 'package:tfg_v1/Data/Models/Subject.dart';
import 'package:tfg_v1/Data/Models/University.dart';


class UserBloc extends Bloc<UserEvent, UserState> {

  UserBloc({required UserRepository userRepository}) : super(UserInitial()) {
   
    on<loadUserProfileInformation>((event, emit) async {
      try{
        // Obtener la información del usuario
        User user = await userRepository.getCurrentUser();

        // Obtener la información de la universidad
        University university =await userRepository.getUniversityFromCurrentUser();

        // Obtener las materias del usuario
        List<Subject> subjects = await userRepository.getSubjectsByUserId(user.id);


        emit(displayInformation(user: user,university: university, subjects: subjects));

      }catch(error){
        print('error');
        print(error);
      }       
    });  
    on<updateUser>((event, emit) async {
      try{
        User user = event.user;
        String currentName = event.currentName;
        String currentMail = event.currentMail;
        String currentPassword = event.currentPassword;

        if (user.name != currentName && currentName != '') {
          print('name is different');
          userRepository.editusername(currentName);
          await Future.delayed(Duration(seconds: 1)); // Delay for 1 second
        }

        if (user.email != currentMail && currentMail != '') {
          print('email is different');
          userRepository.editEmail(currentMail);
          await Future.delayed(Duration(seconds: 1)); // Delay for 1 second
        }

        if (user.password != currentPassword && currentPassword != '') {
          print('password is different');
          userRepository.editPassword(currentPassword);
          await Future.delayed(Duration(seconds: 1)); // Delay for 1 second
        }


      }catch(error){
        print('error');
        print(error);
      }       
    });  
    
  }
}
