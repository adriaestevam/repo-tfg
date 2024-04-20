import 'package:tfg_v1/Data/Models/Subject.dart';
import 'package:tfg_v1/Data/Models/Users.dart';

abstract class AcademiaEvent{}

class uploadAcademicData extends AcademiaEvent{
  final Subject subject;

  uploadAcademicData({required this.subject});
}

class UpdateEvaluationGradeEvent extends AcademiaEvent {
  final String name;
  final String newGrade;
  final Subject subject;

  UpdateEvaluationGradeEvent({required this.name, required this.newGrade, required this.subject});
}



