import 'package:bloc/bloc.dart';
import 'navigator_event.dart';
import 'navigator_state.dart';

class NavigatorBloc extends Bloc<NavigatorEvent, NaviState> {
  NavigatorBloc() : super(NavigatorInitial()) {
    on<LoginEvent>((event, emit) async {
      try {
        emit(LoginState());
      } catch (error) {
        print("Error: $error");
      }
    });
    on<SignUpEvent>((event, emit) async {
      try {
        emit(SignupState());
      } catch (error) {
        print("Error: $error");
      }
    });
    on<StartInitialConfigutationEvent>((event, emit) async {
      try {
        emit(StartInitialConfigutationState());
      } catch (error) {
        print("Error: $error");
      }
    });
  }
}
