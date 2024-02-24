import 'package:bloc/bloc.dart';
import 'package:tfg_v1/Data/AuthRepository.dart';
import 'package:tfg_v1/Domain/Initial%20Configuration%20Bloc/initial_config_event.dart';
import 'package:tfg_v1/Domain/Initial%20Configuration%20Bloc/initial_config_state.dart';

class InitialConfigBloc extends Bloc<InitialConfigEvent, InitialConfigState> {

  InitialConfigBloc({required AuthRepository authRepository}) : super(InitialConfigurationInitial()) {
    on<UniversityIsIntroduced>((event, emit) async {
      try {
        //La universidad ha sido introducida y hay que devolver las asignaturas
      } catch (error) {
        
       
      }
    });  
    on<EndOfInitialConfiguration>((event, emit) async {
      try {
        var userInformationSaved = await authRepository.registerInitialConfig(
          event.user_name,
          event.university,
          event.selectedSubjects,
          event.objectives,
          event.studyStartTimes,
          event.studyEndTimes
        );
        //Guardar la información en la base de datos dado un usuario
      } catch (error) {
        
       
      }
    });  
  }
}