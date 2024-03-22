import 'dart:math';
import 'package:tfg_v1/Data/Models/Users.dart';

import '../DataService.dart';


class UserRepository {
  final DataService _dataService;

  UserRepository(this._dataService);

  getUniversityFromCurrentUser() {
    return _dataService.getUniversityFromCurrentUser();
  }

  getCurrentUser() {
    return _dataService.getCurrentUser();
  }

  getSubjectsByUserId(int id) {
    return _dataService.getSubjectsByUserId(id);
  }

  getStudyBlocksByUserId(int id) {
    return _dataService.getStudyBlocksByUserId(id);
  }

  objectivesAndPrioritiesByUserId(int id) {
    return _dataService.objectivesAndPrioritiesByUserId(id);
  }

  void updateUserFromProfileSettings(User user, String currentName, String currentMail, String currentPassword) {
    _dataService.updateUserFromProfileSettings(user,currentName,currentMail,currentPassword);
  }
}

  


