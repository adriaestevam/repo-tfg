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

class uploadEvents extends CalendarEvent{}
class readyToDisplayCalendar extends CalendarEvent{}
