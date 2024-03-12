import 'package:meta/meta.dart';
import 'package:tfg_v1/Data/Models/Subject.dart';

@immutable
abstract class SignUpState {}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpSuccess extends SignUpState {}

class SignUpFailure extends SignUpState {
  final String error;

  SignUpFailure({required this.error});
}

class SwipeToLoginState extends SignUpState {}

class InitialConfigState extends SignUpState{}

class DisplaySuggestions extends SignUpState{}

class SubjectsFromUniversityState extends SignUpState{
  final List<Subject> subjectsFromUniversity;
  SubjectsFromUniversityState({required this.subjectsFromUniversity});
}

class FirstTimeUniversity extends SignUpState{}