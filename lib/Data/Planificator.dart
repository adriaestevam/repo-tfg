import 'package:bloc/bloc.dart';
import 'package:tfg_v1/Data/Models/Evaluation.dart';
import 'package:tfg_v1/Data/Models/Event.dart';
import 'package:tfg_v1/Data/Models/Plan.dart';
import 'package:tfg_v1/Data/Models/StudyBloc.dart';
import 'package:tfg_v1/Data/Models/User-Subject-Event.dart';

import 'package:tfg_v1/Data/Models/User-Subject.dart';
import '../../Data/Models/Subject.dart';

import '../../Data/Models/Session.dart';
class Planificator {
  // Define your method signatures and implementations here.

  // This method generates the plan.
  Map<String,dynamic> generarPlan(
    List<StudyBlock> studyBlocks,
    List<Subject> subjects,
    List<UserSubject> userSubjects,
    List<Event> events,
    List<Evaluation> evaluations,
    List<UserSubjectEvent> userSubjectEvents) {

  print("Study Blocks:");
  for (var studyBlock in studyBlocks) {
    print("ID: ${studyBlock.id}, User ID: ${studyBlock.userId}, Day: ${studyBlock.day}, Start Time: ${studyBlock.startTime}, End Time: ${studyBlock.endTime}");
  }

  print("\nSubjects:");
  for (var subject in subjects) {
    print("ID: ${subject.id}, Name: ${subject.name}, Credits: ${subject.credits}, Formula: ${subject.formula}");
  }

  print("\nUser Subjects:");
  for (var userSubject in userSubjects) {
    print("User ID: ${userSubject.userId}, Subject ID: ${userSubject.subjectId}, Objective: ${userSubject.objective}, Priority: ${userSubject.priority}, Feedback: ${userSubject.feedback}");
  }

  print("\nEvents:");
  for (var event in events) {
    print("ID: ${event.id}, Name: ${event.name}, Is Done: ${event.isDone}");
  }

  print("\nEvaluations:");
  for (var evaluation in evaluations) {
    print("ID: ${evaluation.id}, Date: ${evaluation.date}, Grade: ${evaluation.grade}");
  }

  print("\nUser Subject Events:");
  for (var userSubjectEvent in userSubjectEvents) {
    print("User ID: ${userSubjectEvent.userId}, Subject ID: ${userSubjectEvent.subjectId}, Event ID: ${userSubjectEvent.eventId}");
  }

  // Aquí iría la lógica para generar el plan
  Plan plan = Plan(userId: 0, sessionId: 0);
  List<Event> listEvents = [];
  List<Session> listSessions = [];
  Map<String,dynamic> mapOfLists = {};


  Event event1 = Event(id: 1, name: 'Session of testing 1', isDone: false);
  Session session1 = Session(id: 1, startTime: DateTime(2024, 4, 1, 9, 0), endTime: DateTime(2024, 4, 1, 11, 0));

  Event event2 = Event(id: 2, name: 'Session of testing 2', isDone: false);
  Session session2 = Session(id: 2, startTime: DateTime(2024, 4, 1, 13, 0), endTime: DateTime(2024, 4, 1, 15, 0));

  Event event3 = Event(id: 3, name: 'Session of testing 3', isDone: false);
  Session session3 = Session(id: 3, startTime: DateTime(2024, 4, 2, 9, 0), endTime: DateTime(2024, 4, 2, 11, 0));

  Event event4 = Event(id: 4, name: 'Session of testing 4', isDone: false);
  Session session4 = Session(id: 4, startTime: DateTime(2024, 4, 2, 14, 0), endTime: DateTime(2024, 4, 2, 16, 0));

  Event event5 = Event(id: 5, name: 'Session of testing 5', isDone: false);
  Session session5 = Session(id: 5, startTime: DateTime(2024, 4, 3, 10, 0), endTime: DateTime(2024, 4, 3, 12, 0));

  listEvents.add(event1);
  listEvents.add(event2);
  listEvents.add(event3);
  listEvents.add(event4);
  listEvents.add(event5);

  listSessions.add(session1);
  listSessions.add(session2);
  listSessions.add(session3);
  listSessions.add(session4);
  listSessions.add(session5);

  // Agregar las listas al mapa
  mapOfLists['events'] = listEvents;
  mapOfLists['sessions'] = listSessions;

  // Retornar el mapa
  return mapOfLists;
}

  // Placeholder for calculating available time.
  // You need to implement the logic.
  Map<String, dynamic> calcularTiempoDisponible(List<StudyBlock> studyBlocks) {
    // Implement your logic here.
    return {};
  }

  // Placeholder for calculating subject importance.
  // You need to implement the logic.
  Map<String, dynamic> calcularImportanciaAsignaturas(
      List<Subject> subjects,
      List<UserSubject> userSubjects,
      List<Event> events,
      List<Evaluation> evaluations,
      List<UserSubjectEvent> userSubjectEvents) {
    // Implement your logic here.
    return {};
  }

  // Placeholder for distributing study time.
  // You need to implement the logic.
  Map<String, dynamic> distribuirTiempoEstudio(
      Map<String, dynamic> importanciaAsignaturas,
      Map<String, dynamic> tiempoDisponible) {
    // Implement your logic here.
    return {};
  }

  // Placeholder for planning a session.
  // You need to implement the logic.
  Session? planificarSesion(
      StudyBlock bloque, Map<String, dynamic> distribucionTiempo) {
    // Implement your logic here.
    return null;
  }

  // Placeholder for creating a plan instance.
  // You need to implement the logic.
  Plan crearInstanciaPlan(Session sesion, List<UserSubject> userSubjects) {
    // Implement your logic here.
    // This method creates a Plan instance based on the session and user data.
    return Plan(
        userId: 1, // Example data; replace with actual logic.
         // Assuming Session has a subjectId.
        sessionId: sesion.id);
  }
}

// Define other classes like StudyBlock, Subject, UserSubject, Event, Evaluation, UserSubjectEvent, Session, and Plan as needed.
