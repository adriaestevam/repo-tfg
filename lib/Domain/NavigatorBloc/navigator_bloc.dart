import 'package:bloc/bloc.dart';
import 'navigator_event.dart';
import 'navigator_state.dart';

class NavigatorBloc extends Bloc<NavigatorEvent, NaviState> {
  NavigatorBloc() : super(NavigatorInitial()) {
    on<GoToLoginEvent>((event, emit) async {
      try {
        emit(GoToLoginState());
      } catch (error) {
        print("Error: $error");
      }
    });
    on<GoToSignUpEvent>((event, emit) async {
      try {
        emit(GoToSignupState());
      } catch (error) {
        print("Error: $error");
      }
    });
    on<GoToStartInitialConfigutationEvent>((event, emit) async {
      try {
        emit(GoToStartInitialConfigutationState());
      } catch (error) {
        print("Error: $error");
      }
    });
    on<GoToHomeEvent>((event, emit) async {
      try {
        emit(GoToHomeState());
      } catch (error) {
        print("Error: $error");
      }
    });
  }
}

