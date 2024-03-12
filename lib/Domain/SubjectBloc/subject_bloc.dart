import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfg_v1/Data/Models/User-Subject.dart';
import 'package:tfg_v1/Data/Repositories/UserRepository.dart';
import 'package:tfg_v1/Domain/SubjectBloc/subject_event.dart';

import '../../Data/Models/Subject.dart';
part 'subject_state.dart';

class SubjectBloc extends Bloc<SubjectEvent, SubjectState> {

  SubjectBloc({required UserRepository userRepository}) : super(SubjectInitial()) {
   
    on<loadSubjectsFromUser>((event, emit) async {
      try{
        // Obtener el ID del usuario desde SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('currentUserId');

    if (userId != null) {
      // Obtener las materias del usuario utilizando el ID obtenido
      List<Subject> subjects = await userRepository.getSubjectsByUserId(userId);
      emit(displaySubjectsInformation(subjects: subjects));
    } 

      }catch(error){

      }       
    }); 
    on<loadObjectivesAndPriorities>((event, emit) async {
      try{
        // Obtener el ID del usuario desde SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        int? userId = prefs.getInt('currentUserId');

        if (userId != null) {
          // Obtener las materias del usuario utilizando el ID obtenido
          List<Subject> subjects = await userRepository.getSubjectsByUserId(userId);
          List<UserSubject> objectivesAndPriorities = await userRepository.objectivesAndPrioritiesByUserId(userId);
          emit(displayObjectivesAndPriorities(
            objectivesAndPriorities: objectivesAndPriorities,
            subjects: subjects));
        } 

      }catch(error){

      }       
    });    
  }
}
