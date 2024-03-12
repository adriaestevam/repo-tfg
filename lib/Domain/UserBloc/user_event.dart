
import 'package:tfg_v1/Data/Models/Users.dart';

abstract class UserEvent{}

class loadUserProfileInformation extends UserEvent{}

class updateUser extends UserEvent{
  final User user;
  final String currentName;
  final String currentMail;
  final String currentPassword;

  updateUser({
    required this.user,
    required this.currentName,
    required this.currentMail,
    required this.currentPassword,
  });
}