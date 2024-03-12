part of 'subject_bloc.dart';

sealed class SubjectState extends Equatable {
  const SubjectState();
  
  @override
  List<Object> get props => [];
}

final class SubjectInitial extends SubjectState {}

class displaySubjectsInformation extends SubjectState{
  final List<Subject> subjects;

  displaySubjectsInformation({
    required this.subjects,
  });

}

class displayObjectivesAndPriorities extends SubjectState{
  final List<UserSubject> objectivesAndPriorities;
  final List<Subject> subjects;
  
  displayObjectivesAndPriorities({
    required this.objectivesAndPriorities,
    required this.subjects,
  });
}