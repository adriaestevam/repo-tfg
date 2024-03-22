
import 'package:meta/meta.dart';
import 'package:tfg_v1/Data/Models/StudyBloc.dart';
import 'package:tfg_v1/Data/Models/Subject.dart';
import 'package:tfg_v1/Data/Models/University.dart';
import '../../Data/Models/Users.dart';


abstract class UserState{}

class UserInitial extends UserState {}

class displayInformation extends UserState{
  final User user;
  final University university;
  final List<Subject> subjects;

  displayInformation({
    required this.user,
    required this.university,
    required this.subjects,
  });

}

class userSuccessfullyUpdated extends UserState{}
class UpdatingUserInformation extends UserState{}

