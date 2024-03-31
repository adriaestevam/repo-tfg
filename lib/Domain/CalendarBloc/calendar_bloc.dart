import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfg_v1/Data/Models/Evaluation.dart';
import 'package:tfg_v1/Data/Models/Event.dart';
import 'package:tfg_v1/Data/Models/Plan.dart';
import 'package:tfg_v1/Data/Models/StudyBloc.dart';
import 'package:tfg_v1/Data/Models/Subject.dart';
import 'package:tfg_v1/Data/Models/User-Subject-Event.dart';
import 'package:tfg_v1/Data/Models/User-Subject.dart';
import 'package:tfg_v1/Data/Planificator.dart';
import 'package:tfg_v1/Data/Repositories/UserRepository.dart';

import '../../Data/Models/Session.dart';
import '../../Data/Repositories/EventRepository.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc({required EventRepository eventRepository}) : super(CalendarInitial()) {
    on<addNewEvaluation>((event, emit) async {
      try{
        await eventRepository.addNewEvaluation(event.newEvaluation, event.newEvent, event.newUserSubjectEvent);
      } catch(error){
        print(error);
      }
    });
    on<addNewSession>((event, emit) async {
      try{
        await eventRepository.addNewSession(event.newSession, event.newEvent, event.newUserSubjectEvent);
      } catch(error){
        print(error);
      }
    });
    on<readyToDisplayCalendar>((event, emit) async {
      try{
        emit(displayCalendarInformation());
      } catch(error){
        print(error);
      }
    });
    on<DeleteSessionEvent>((event, emit) async {
      try{
        await eventRepository.DeleteSessionEvent(event.sessionId);
      } catch(error){
        print(error);
      }
    });
    on<DeleteEvaluationEvent>((event, emit) async {
      try{
        await eventRepository.DeleteEvaluationEvent(event.evaluationId);
      } catch(error){
        print(error);
      }
    });

    on<updateEvaluation>((event, emit) async {
      try{
        await eventRepository.updateEvaluation(event.newEvent,event.newEvaluation,event.newUserSubjectEvent);
      } catch(error){
        print(error);
      }
    });

    on<updateSession>((event, emit) async {
      try{
        await eventRepository.updateSession(event.newEvent,event.newSession,event.newUserSubjectEvent);
      } catch(error){
        print(error);
      }
    });
        
    on<uploadEvents>((event, emit) async {
      Map<DateTime, List<Event>> mapOfEvents = {};
      List<Event> userEvents = [];
      List<Evaluation> userEvaluations = [];
      List<Session> userSessions = [];
      try {


        if(!await eventRepository.checkUserHasPlan()){
          print('El user no té cap plan');

          Map<String, dynamic> planData = await eventRepository.getPlanData();
          print('Plan data obtained: $planData');

          // Extrayendo la información de planData
          List<StudyBlock> studyBlocks = planData['studyBlocks'] as List<StudyBlock>;
          print('Study blocks: $studyBlocks');

          List<Subject> subjects = planData['subjects'] as List<Subject>;
          print('Subjects: $subjects');

          List<UserSubject> userSubjects = planData['userSubjects'] as List<UserSubject>;
          print('User subjects: $userSubjects');

          List<Event> events = planData['events'] as List<Event>;
          print('Events: $events');

          List<Evaluation> evaluations = planData['evaluations'] as List<Evaluation>;
          print('Evaluations: $evaluations');

          List<UserSubjectEvent> userSubjectEvents = planData['userSubjectEvents'] as List<UserSubjectEvent>;
          print('User subject events: $userSubjectEvents');

          print('Data obtained and extracted');

          // Crear instancia de Planificator y generar plan
          Planificator planificator = Planificator();
          Map<String,dynamic> plan = planificator.generarPlan(studyBlocks, subjects, userSubjects, events, evaluations, userSubjectEvents);
          print('Generated plan: $plan');

          List<Event> eventsFromPlan = plan['events'] as List<Event>;
          print('Events from plan: $eventsFromPlan');

          List<Session> sessionsFromPlan = plan['sessions'] as List<Session>; // Ensure this key matches with what generarPlan returns
          print('Sessions from plan: $sessionsFromPlan');

          userEvents.addAll(eventsFromPlan);
          userSessions.addAll(sessionsFromPlan);

          print('Final user events: $userEvents');
          print('Final user sessions: $userSessions');

        } else {
          print('El user té un plan');
        }




        if(await eventRepository.checkUserHasEvents()){
          List<Event> repositoryEvents = await eventRepository.uploadEvents();
          userEvaluations = await eventRepository.uploadEvaluations();
          List<Session> repositorySessions = await eventRepository.uploadSessions();

          // Merge and remove duplicates
          for (var event in repositoryEvents) {
            if (!userEvents.any((e) => e.id == event.id)) {
              userEvents.add(event);
            }
          }
          for (var session in repositorySessions) {
            if (!userSessions.any((s) => s.id == session.id)) {
              userSessions.add(session);
            }
          }
    
          // Create a map of evaluations by their ID for quick lookup
          Map<int, Evaluation> evaluationMap = { for (var e in userEvaluations) e.id: e };
          Map<int, Session> sessionMap = { for (var s in userSessions) s.id: s };
     
          // Add Events to selectedEvents based on their corresponding evaluation date
          for (Event event in userEvents) {
            if (evaluationMap.containsKey(event.id)) {
              // Get the evaluation corresponding to this event
              Evaluation evaluation = evaluationMap[event.id]!;
              DateTime evaluationDate = evaluation.date; // Replace with your actual way to get the date of the evaluation

              // Add event to selectedEvents on the date of the corresponding evaluation
              if (!mapOfEvents.containsKey(evaluationDate)) {
                mapOfEvents[evaluationDate] = [];
              }
              mapOfEvents[evaluationDate]!.add(event);

            } else if (sessionMap.containsKey(event.id)){
              Session session = sessionMap[event.id]!;
              DateTime startTimeOfSession = session.startTime; //Considering stratTime as a reference for Mapping in the MapOfEvents

              if(!mapOfEvents.containsKey(startTimeOfSession)){
                mapOfEvents[startTimeOfSession]=[];
              }

              mapOfEvents[startTimeOfSession]!.add(event);
             
            }
          }
        }

     
        
        emit(uploadEventsToUI(mapOfEvents: mapOfEvents,evaluationList: userEvaluations,sessionList: userSessions));

      } catch (error) {
        print(error);
      }

    });
  }
}
