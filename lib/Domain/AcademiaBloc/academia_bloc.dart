import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:tfg_v1/Data/DataService.dart';
import 'package:tfg_v1/Data/Models/Evaluation.dart';
import 'package:tfg_v1/Data/Models/Event.dart';
import 'package:tfg_v1/Data/Models/Subject.dart';
import 'package:tfg_v1/Data/Models/User-Subject-Event.dart';
import 'package:tfg_v1/Data/Repositories/EventRepository.dart';
import 'package:tfg_v1/Data/Repositories/UserRepository.dart';
import 'package:tfg_v1/Domain/AcademiaBloc/academia_event.dart';
import 'package:tfg_v1/Domain/AcademiaBloc/academia_state.dart';
import 'package:tfg_v1/Domain/CalendarBloc/calendar_bloc.dart';



class AcademiaBloc extends Bloc<AcademiaEvent, AcademiaState> {

  AcademiaBloc({required EventRepository eventRepository}) : super(AcademiaInitial()) {
   
    on<uploadAcademicData>((event, emit) async {
      try{
        UserRepository userRepository = UserRepository(DataService());
        Subject subject = event.subject;

        int feedback = await userRepository.getUserCurrentFeedback(subject.id);
        //get events and evaluations from subject and user
        List<Evaluation> evaluations = await eventRepository.uploadEvaluations();
        List<Event> events = await eventRepository.uploadEvents();
        List<UserSubjectEvent> userSubjectEvents = await eventRepository.uploadUserSubjectEvents();
        

        // Print each event's name for debugging
        print('Events data loaded:');
        for (Event event in events) {
            print('Event name: ${event.name}');
        }

        List<Event> eventFromSubject = getEventsFromSubject(subject.id, events,userSubjectEvents);

        print('Events from subject loaded');
        for (Event event in eventFromSubject){
          print('Event name: ${event.name}');
        }
     
        List<Evaluation> evaluationsFromSubject = getEvaluationsFromSubject(eventFromSubject, evaluations);

        emit(displayInformation(events: eventFromSubject, evaluations: evaluationsFromSubject,feedback: feedback));


      }catch(error){
        print('error');
        print(error);
      }       
    });    
    on<UpdateEvaluationGradeEvent>((event, emit) async {
  print('Updating evaluation grade');
  Subject subject = event.subject;
  String evaluationName = event.name;
  String newGradeStr = event.newGrade; // Assuming event.newGrade is a string
  double newGrade;

  try {
    newGrade = double.parse(newGradeStr);
  } catch (e) {
    throw Exception("Error converting newGrade to double: $e");
  }

  try {
    List<Evaluation> evaluations = await eventRepository.uploadEvaluations();
    print('Evaluations loaded: ${evaluations.length}');

    List<Event> events = await eventRepository.uploadEvents();
    print('Events loaded: ${events.length}');
    for(Event event in events){
      print('Events names : ${event.name}');
    }

    List<UserSubjectEvent> userSubjectEvents = await eventRepository.uploadUserSubjectEvents();
    print('UserSubjectEvents loaded: ${userSubjectEvents.length}');

    // Assuming you have the subject name as part of the event's name
    String eventNameToFind = "$evaluationName of subject ${subject.name}";
    print('Looking for event: $eventNameToFind');

    Event? matchingEvent = events.firstWhereOrNull((e) => e.name.contains(eventNameToFind));
    if (matchingEvent == null) {
      print('Event not found for the given evaluation name and subject');
      throw Exception("Event not found for the given evaluation name and subject");
    } else {
      print('Matching event found: ${matchingEvent.name}');
    }

    Evaluation? matchingEvaluation = evaluations.firstWhereOrNull((ev) => ev.id == matchingEvent.id);
    if (matchingEvaluation == null) {
      print('Evaluation not found');
      throw Exception('Evaluation not found');
    } else {
      print('Matching evaluation found: Grade before update ${matchingEvaluation.grade}');
    }

    UserSubjectEvent userSubjectEvent = userSubjectEvents.firstWhereOrNull(
        (u) => u.eventId == matchingEvaluation.id
    ) ?? (throw Exception('UserSubjectEvent not found for the given evaluation ID.'));
    print('Matching UserSubjectEvent found: ${userSubjectEvent.subjectId}');

    Evaluation newEvaluation = Evaluation(id: matchingEvaluation.id, date: matchingEvaluation.date, grade: newGrade);
    print('New evaluation prepared with updated grade: $newGrade');

    await eventRepository.updateEvaluation(matchingEvent, newEvaluation, userSubjectEvent);
    print('Evaluation updated successfully');
    emit(AcademiaInitial());
  } catch (e) {
    throw Exception("Error when updating evaluation grade"); // Emit error state with the error message
  }
});

  }
}

List<Event> getEventsFromSubject(int subId, List<Event> events, List<UserSubjectEvent> userSubjectEvents) {
  // Crear un conjunto de IDs de eventos que coincidan con el subjectId dado
  Set<int> eventIds = userSubjectEvents.where((use) => use.subjectId == subId).map((use) => use.eventId).toSet();

  // Filtrar eventos cuyos IDs estén en el conjunto de IDs válidos
  return events.where((event) => eventIds.contains(event.id)).toList();
}


List<Evaluation> getEvaluationsFromSubject(List<Event> eventsFromSubject, List<Evaluation> evaluations) {
  // Extract event IDs from the events related to the subject
  Set<int> eventIds = eventsFromSubject.map((e) => e.id).toSet();

  // Filter evaluations where their ID matches any ID from the events list
  return evaluations.where((evaluation) => eventIds.contains(evaluation.id)).toList();
}


