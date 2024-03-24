part of 'calendar_bloc.dart';

abstract class CalendarState{}

class CalendarInitial extends CalendarState{}
class displayCalendarInformation extends CalendarState{}

class uploadEventsToUI extends CalendarState {

  final Map<DateTime,List<Event>> mapOfEvents;
  final List<Evaluation> evaluationList;
  final List<Session> sessionList;

  uploadEventsToUI({
    required this.mapOfEvents,
    required this.evaluationList,
    required this.sessionList,
  });
}