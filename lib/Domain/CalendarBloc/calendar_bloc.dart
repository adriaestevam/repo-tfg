import 'dart:math';

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

          List<Subject> subjects = planData['subjects'] as List<Subject>;
          List<UserSubject> userSubjects = planData['userSubjects'] as List<UserSubject>;
          List<Event> events = planData['events'] as List<Event>;
          List<Evaluation> evaluations = planData['evaluations'] as List<Evaluation>;
          List<UserSubjectEvent> userSubjectEvents = planData['userSubjectEvents'] as List<UserSubjectEvent>;

          print('Data obtained and extracted');
          
          //Create the ideal distribution
          Map<String,double> idealPriorityDistribution = createPriorityDistribution(subjects,userSubjects);
         
          Map<String,double> idealUrgencyDistribution = createUrgencyDistribution(subjects,events,evaluations);
         
          // Crear instancia de Planificator y generar plan
          Planificator planificator = Planificator();
          Map<String,dynamic> plan = await planificator.generatePlan(studyBlocks, subjects, userSubjects, events, evaluations, userSubjectEvents,idealPriorityDistribution,idealUrgencyDistribution);
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

Map<String, double> createUrgencyDistribution(List<Subject> subjects, List<Event> events, List<Evaluation> evaluations) {
    Map<String, double> distribution = {};
    double totalScore = 0.0;

    
    // Calculate scores for each subject
    for (var subject in subjects) {
        int proximityScore = calculateProximityScore(subject.name, events, evaluations);
        int weightScore = calculateWeightScore(subject.name, subject.formula, events, evaluations);

        // Assuming a simple addition of scores, modify as needed for different scoring logic
        int urgencyScore = proximityScore + weightScore;
        distribution[subject.name] = urgencyScore.toDouble();
        totalScore += urgencyScore;
    }

    // Normalize the distribution
    if (totalScore > 0) {  // Ensure we do not divide by zero
        for (var key in distribution.keys.toList()) {
            distribution[key] = distribution[key]! / totalScore;
        }
    }

    return distribution;
}


int calculateWeightScore(String subjectName, String formula, List<Event> events, List<Evaluation> evaluations) {
  try {
      // Find the nearest evaluation based on the subject name
      Evaluation nearestEvaluation = findNearestEvaluation(subjectName, events, evaluations);
      
      // Find the corresponding event to extract the evaluation name
      Event correspondingEvent = events.firstWhere(
          (event) => event.id == nearestEvaluation.id,
          orElse: () => throw Exception('Event not found for the evaluation.')
      );

      // Extract the evaluation name from the event's name
      String evaluationName = extractEvaluationNameFromEventName(correspondingEvent.name);

      // Extract weight for the evaluation name from the formula
      double weight = extractWeightFromFormula(formula, evaluationName);
      
      // Convert weight to an integer score for simplicity, could adjust scale as needed
      return (weight * 100).toInt();  // Example scoring: scale weight to make it an integer score
  } catch (e) {
      print('Error calculating weight score: $e');
      return 0;  // Return 0 on error
  }
}

String extractEvaluationNameFromEventName(String eventName) {
    RegExp pattern = RegExp(r'(examen\d+) of subject');
    RegExpMatch? match = pattern.firstMatch(eventName);
    return match?.group(1) ?? "";  // Return empty if no match found
}

double extractWeightFromFormula(String formula, String evaluationName) {
  RegExp regExp = RegExp(r'(\w+): (\d+\.\d+)%');
  Map<String, double> weights = {};

  for (var match in regExp.allMatches(formula)) {
      String name = match.group(1)!;
      double weight = double.parse(match.group(2)!);
      weights[name] = weight;
  }

  return weights[evaluationName] ?? 0.0;  // Return 0 if no matching evaluation weight is found
}

Evaluation findNearestEvaluation(String subjectName, List<Event> events, List<Evaluation> evaluations) {
  DateTime now = DateTime.now();
  Evaluation? nearestEvaluation;
  int minTimeDiff = double.maxFinite.toInt();

  for (Event event in events.where((e) => e.name.contains(subjectName))) {
    Evaluation? evaluation = evaluations.firstWhere(
      (eval) => eval.id == event.id,
      orElse: () => throw Exception('Evaluation not found for the evaluation.')
    );

    DateTime evaluationDate = evaluation.date;
    int timeDiff = evaluationDate.difference(now).inMinutes.abs();

    if (timeDiff < minTimeDiff) {
      minTimeDiff = timeDiff;
      nearestEvaluation = evaluation;
    }
    }

  if (nearestEvaluation == null) {
    throw Exception('No evaluation found for the subject: $subjectName');
  }

  return nearestEvaluation;
}


int calculateProximityScore(String subjectName, List<Event> events, List<Evaluation> evaluations) {
  DateTime now = DateTime.now();

  // Filter events to find those that correspond to the subject
  List<Event> subjectEvents = events.where(
    (event) => event.name.endsWith(' of $subjectName')
  ).toList();

  // Find all evaluations linked to these subject events
  List<Evaluation> subjectEvaluations = [];
  for (Event event in subjectEvents) {
    // Find evaluations that match the event ID
    evaluations.forEach((evaluation) {
      if (evaluation.id == event.id) {
        subjectEvaluations.add(evaluation);
      }
    });
  }

  // Calculate the minimum number of days to the nearest evaluation
  int minDaysToEvaluation = subjectEvaluations.fold<int>(
    double.maxFinite.toInt(),  // Use double's maxFinite converted to int as a large initial value
    (previousValue, evaluation) {
      DateTime evaluationDate = evaluation.date; 
      int daysDifference = evaluationDate.difference(now).inDays;
      // Update the minimum if this evaluation is closer and in the future
      if (daysDifference > 0 && daysDifference < previousValue) {
        return daysDifference;
      }
      return previousValue;
    },
  );

  // If no future evaluations are found, return 0 as the score
  if (minDaysToEvaluation == double.maxFinite.toInt()) {
    return 0;
  }

  // The scoring mechanism can be adjusted as needed
  int score = max(0, 100 - minDaysToEvaluation);  // Example: fewer days to evaluation, higher score

  return score;
}


Map<String, double> createPriorityDistribution(List<Subject> subjects, List<UserSubject> userSubjects) {
  Map<String, double> distribution = {};
  int totalScore = 0;

  // Create a map to quickly find UserSubject by subjectId
  Map<int, UserSubject> userSubjectMap = {
    for (var userSubject in userSubjects) userSubject.subjectId: userSubject
  };

  // Calculate a score for each subject based on priority, objective, and feedback
  for (var subject in subjects) {
    UserSubject userSubject = userSubjectMap[subject.id]!;
    
    // Calculate priority score (inverse because lower number means higher priority)
    int priorityScore = (userSubjects.length + 1) - userSubject.priority; // Invert priority to make it a score

    // Objective score: higher if the objective is to achieve honors
    int objectiveScore = (userSubject.objective == 'honours') ? 2 : 1;

    // Feedback score: Inverse because 1 means urgent need for improvement
    int feedbackScore = 4 - userSubject.feedback; // Invert feedback to make it a score

    // Calculate combined score
    int combinedScore = priorityScore * objectiveScore * feedbackScore;
    distribution[subject.name] = combinedScore.toDouble();
    totalScore += combinedScore;
  }

  // Normalize the scores to get a percentage distribution
  if (totalScore > 0) { // Prevent division by zero
    for (var key in distribution.keys.toList()) {
      distribution[key] = (distribution[key]! / totalScore) * 100;
    }
  }

  return distribution;
}

  


