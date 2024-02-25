import 'package:bloc/bloc.dart';
import 'package:tfg_v1/Data/AuthRepository.dart';
import 'package:tfg_v1/Domain/AddNewSubject/add_new_subject_event.dart';
import 'package:tfg_v1/Domain/Initial%20Configuration%20Bloc/initial_config_event.dart';
import 'package:tfg_v1/Domain/Initial%20Configuration%20Bloc/initial_config_state.dart';


class AddNewSubjectBloc extends Bloc<AddNewSubjectEvent, InitialConfigState> {

  AddNewSubjectBloc({required AuthRepository authRepository}) : super(InitialConfigurationInitial()) {
    on<AddNewSubjectButtonPressed>((event, emit) async {
      try {
        
      } catch (error) {
        
      }
    });
  }
}