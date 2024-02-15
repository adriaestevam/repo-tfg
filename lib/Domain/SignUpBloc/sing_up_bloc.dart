import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tfg_v1/Domain/SignUpBloc/sing_up_event.dart';
import 'package:tfg_v1/Domain/SignUpBloc/sing_up_state.dart'; // Corrected import

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpInitial()) {
    on<SignUpButtonPressed>((event, emit) async {
      try {
        print("hoa manonal");
        // Perform some asynchronous operation, e.g., network request
        // Simulate a delay with a Future.delayed for demonstration
      

        // Emit a loading state to indicate that sign-up process has started
        emit(SignUpLoading());
        await Future.delayed(Duration(seconds: 10));

        // Here you would perform the sign-up operation, for example:
        // final response = await apiService.signUp(event.email, event.password);
        // if (response.success) {
        //   emit(SignUpSuccess());
        // } else {
        //   emit(SignUpFailure(error: response.error));
        // }

        // For demonstration purposes, let's simulate a successful sign-up
        emit(SignUpSuccess());
      } catch (error) {
        // If an exception occurs during the sign-up process, emit a failure state
        emit(SignUpFailure(error: error.toString()));
      }
    });
  }
}
