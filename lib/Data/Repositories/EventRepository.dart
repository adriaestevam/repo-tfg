import 'dart:math';
import 'package:tfg_v1/Data/Models/Evaluation.dart';
import 'package:tfg_v1/Data/Models/Session.dart';
import 'package:tfg_v1/Data/Models/User-Subject-Event.dart';
import 'package:tfg_v1/Data/Models/Users.dart';

import '../DataService.dart';
import '../Models/Event.dart';


class EventRepository {
  final DataService _dataService;
  EventRepository(this._dataService);

  addNewEvaluation(Evaluation evaluation, Event event, UserSubjectEvent userSubjectEvent){
    _dataService.addNewEvaluation(evaluation,event,userSubjectEvent);

  }

  uploadEvents() {
    return _dataService.uploadEvents();
  }

  uploadEvaluations() {
    return _dataService.uploadEvaluations();
  }

  checkUserHasEvents() {
    return _dataService.checkUserHasEvents();
  }

  
  checkUserHasSessions() {
    return _dataService.checkUserHasSessions();
  }

  
  checkUserHasEvaluations(){
    _dataService.checkUserHasEvaluations();
  }

  addNewSession(Session newSession, Event newEvent, UserSubjectEvent newUserSubjectEvent) {
    _dataService.addNewSession(newSession,newEvent,newUserSubjectEvent);
  }

  uploadSession() {
   return _dataService.uploadSessions();
  }

}

  


