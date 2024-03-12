import 'dart:math';
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

  void editusername(String name) {
    _dataService.editUserName(name);
  }

  void editEmail(String email) {
    _dataService.editEmail(email);
  }

  void editPassword(String password) {
    _dataService.editPassword(password);
  }
}

  


