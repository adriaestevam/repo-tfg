
import 'package:meta/meta.dart';
import 'package:tfg_v1/Data/Models/Evaluation.dart';
import 'package:tfg_v1/Data/Models/Event.dart';
import 'package:tfg_v1/Data/Models/StudyBloc.dart';
import 'package:tfg_v1/Data/Models/Subject.dart';
import 'package:tfg_v1/Data/Models/University.dart';
import '../../Data/Models/Users.dart';


abstract class AcademiaState{}

class AcademiaInitial extends AcademiaState {}
class displayInformation extends AcademiaState{
  final List<Event> events;
  final List<Evaluation> evaluations;

  displayInformation({required this.events, required this.evaluations});
}