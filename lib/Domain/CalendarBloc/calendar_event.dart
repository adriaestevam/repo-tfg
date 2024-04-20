part of 'calendar_bloc.dart';
abstract class CalendarEvent{}

class addNewEvaluation extends CalendarEvent{
  final Evaluation newEvaluation;
  final Event newEvent;
  final UserSubjectEvent newUserSubjectEvent;

  addNewEvaluation({
    required this.newEvaluation,
    required this.newEvent,
    required this.newUserSubjectEvent
  });

}

class updateEvaluation extends CalendarEvent{
  final Evaluation newEvaluation;
  final Event newEvent;
  final UserSubjectEvent newUserSubjectEvent;

  updateEvaluation({
    required this.newEvaluation,
    required this.newEvent,
    required this.newUserSubjectEvent
  });

}

class updateSession extends CalendarEvent{
  final Session newSession;
  final Event newEvent;
  final UserSubjectEvent newUserSubjectEvent;

  updateSession({
    required this.newSession,
    required this.newEvent,
    required this.newUserSubjectEvent
  });

}

class addNewSession extends CalendarEvent{
  final Session newSession;
  final Event newEvent;
  final UserSubjectEvent newUserSubjectEvent;

  addNewSession({
    required this.newSession,
    required this.newEvent,
    required this.newUserSubjectEvent
  });

}

class uploadEvents extends CalendarEvent{
  bool userWantsPlan;
  uploadEvents({required this.userWantsPlan});
}

class readyToDisplayCalendar extends CalendarEvent{
  bool userWantsPlan;
  readyToDisplayCalendar({required this.userWantsPlan});
}

class DeleteSessionEvent extends CalendarEvent{
  final int sessionId;
  DeleteSessionEvent({required this.sessionId});
}

class DeleteEvaluationEvent extends CalendarEvent{
  final int evaluationId;
  DeleteEvaluationEvent({required this.evaluationId});
}

