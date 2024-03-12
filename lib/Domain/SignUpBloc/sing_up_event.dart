import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:tfg_v1/Data/Models/Subject.dart';

@immutable
abstract class SignUpEvent {}

class SignUpButtonPressed extends SignUpEvent {
  final String email;
  final String password;

  SignUpButtonPressed({required this.email, required this.password});
}

class EndOfInitialConfiguration extends SignUpEvent{
  final String user_name;
  final String university;
  final Map<Subject,bool> selectedSubjects;
  final Map<Subject, String> objectives;
  final Map<String, TimeOfDay> studyStartTimes;
  final Map<String, TimeOfDay> studyEndTimes;

  EndOfInitialConfiguration({
    required this.user_name,
    required this.university,
    required this.selectedSubjects,
    required this.objectives,
    required this.studyStartTimes,
    required this.studyEndTimes
  });
}
class UniversityIsIntroduced extends SignUpEvent{
  final String university;

  UniversityIsIntroduced({required this.university});
}
