part of 'calendar_bloc.dart';

abstract class CalendarState{}

class CalendarInitial extends CalendarState{}
class displayCalendarInformation extends CalendarState{
  final bool userWantsPlan;
  displayCalendarInformation({required this.userWantsPlan});
}


class uploadEventsToUI extends CalendarState {
  final bool userWantsPlan;
  final Map<DateTime,List<Event>> mapOfEvents;
  final List<Evaluation> evaluationList;
  final List<Session> sessionList;

  uploadEventsToUI({
    required this.userWantsPlan,
    required this.mapOfEvents,
    required this.evaluationList,
    required this.sessionList,
  });
}

class displayRestrosInformation extends CalendarState{
  final List<Event> events;
  final List<Session> sessions;
  final List<Evaluation> evaluations;

  displayRestrosInformation({
    required this.events,
    required this.sessions,
    required this.evaluations,
  });
}