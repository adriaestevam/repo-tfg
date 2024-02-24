import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
abstract class InitialConfigEvent{}

class EndOfInitialConfiguration extends InitialConfigEvent {
  final String user_name;
  final String university;
  final Map<String,bool> selectedSubjects;
  final Map<String, String> objectives;
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
class UniversityIsIntroduced extends InitialConfigEvent {}

