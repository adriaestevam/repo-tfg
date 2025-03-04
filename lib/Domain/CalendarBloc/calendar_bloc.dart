import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
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
  CalendarBloc({required EventRepository eventRepository, required UserRepository userRepository}) : super(CalendarInitial()) {
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
        emit(displayCalendarInformation(userWantsPlan: event.userWantsPlan));
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


        if(event.userWantsPlan){ 
          Map<String, dynamic> planData = await eventRepository.getPlanData();

          // Extrayendo la información de planData
          List<StudyBlock> studyBlocks = planData['studyBlocks'] as List<StudyBlock>;

          List<Subject> subjects = planData['subjects'] as List<Subject>;
          List<UserSubject> userSubjects = planData['userSubjects'] as List<UserSubject>;
          List<Event> events = planData['events'] as List<Event>;
          List<Evaluation> evaluations = planData['evaluations'] as List<Evaluation>;
          List<UserSubjectEvent> userSubjectEvents = planData['userSubjectEvents'] as List<UserSubjectEvent>;

          
          //Create the ideal distribution
          Map<String,double> idealPriorityDistribution = createPriorityDistribution(subjects,userSubjects);
         
          Map<String,double> idealUrgencyDistribution = createUrgencyDistribution(subjects,events,evaluations);
         
          // Crear instancia de Planificator y generar plan
          Planificator planificator = Planificator();
          Map<String,dynamic> plan = await planificator.generatePlan(studyBlocks, subjects, userSubjects, events, evaluations, userSubjectEvents,idealPriorityDistribution,idealUrgencyDistribution);
    

          List<Event> eventsFromPlan = plan['events'] as List<Event>;
        

          List<Session> sessionsFromPlan = plan['sessions'] as List<Session>; // Ensure this key matches with what generarPlan returns

          final SharedPreferences prefs = await SharedPreferences.getInstance();
          int? userId = prefs.getInt("currentUserId");

          if (userId == null) {
            throw Exception('No current user ID found');
          }

          DateTime initialDate = getNearestMonday();
       
          Plan planIdentificator = Plan(userId: userId,initialDate:initialDate);

          userEvents.addAll(eventsFromPlan);
          userSessions.addAll(sessionsFromPlan);

          List<UserSubjectEvent>  userSubjectEventsFromPlan = await getUserSubjectEventsFromPlan(eventsFromPlan,subjects,userId);

          await eventRepository.addPlan(eventsFromPlan,sessionsFromPlan,userSubjectEventsFromPlan,planIdentificator);


        } else {
          print('El user té un plan');
        }




        if(await eventRepository.checkUserHasEvents()){
          
          List<Event> repositoryEvents = await eventRepository.uploadEvents();
          userEvaluations = await eventRepository.uploadEvaluations();
          List<Session> repositorySessions = await eventRepository.uploadSessions();
          
          for(Session session in repositorySessions){
            print('este es el id de todas las sessions: ${session.id}');
          }


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
        } else {
          print('User has none events');
        }

     
        
        emit(uploadEventsToUI(mapOfEvents: mapOfEvents,evaluationList: userEvaluations,sessionList: userSessions, userWantsPlan: event.userWantsPlan));

      } catch (error) {
        print(error);
      }

    });
    on<getRetrosInformation>((event, emit) async {
      try {
        // Fetch data from the repository
        List<Event> events = await eventRepository.uploadEvents();
        List<Session> sessions = await eventRepository.uploadSessions();
        List<Evaluation> evaluations = await eventRepository.uploadEvaluations();

        // Determine the start of the week (last Monday)
        DateTime now = DateTime.now();
        DateTime lastMonday = now.subtract(Duration(days:7));

        // Filter sessions and evaluations
        Map<int, Session> relevantSessions = {};
        Map<int, Evaluation> relevantEvaluations = {};

        for (var session in sessions) {
          if (session.startTime.isAfter(lastMonday) && session.startTime.isBefore(now)) {
            relevantSessions[session.id] = session;
          }
        }

        for (var evaluation in evaluations) {
          if (evaluation.date.isAfter(lastMonday) && evaluation.date.isBefore(now)) {
            relevantEvaluations[evaluation.id] = evaluation;
          }
        }

        // Filter events based on 'done' status and match them with sessions or evaluations
        List<Event> matchedEvents = [];
        List<Session> matchedSessions = [];
        List<Evaluation> matchedEvaluations = [];

        for (var event in events) {
          if (!event.isDone) {
            Session? session = relevantSessions[event.id];
            Evaluation? evaluation = relevantEvaluations[event.id];

            if (session != null || evaluation != null) {
              matchedEvents.add(event);
              if (session != null) {
                matchedSessions.add(session);
              }
              if (evaluation != null) {
                matchedEvaluations.add(evaluation);
              }
            }
          }
        }

        // Emit the result or use another way to display the information
        emit(displayRestrosInformation(events: matchedEvents,sessions: matchedSessions, evaluations: matchedEvaluations));
        
      } catch (error) {
        print(error);
      }
    });
    on<SubmitEvaluationChangesEvent>((event, emit) async {
      try{
        Map<int, double> updatedGrades = event.updatedGrades;
        Map<int, bool> selectedSessions = event.selectedSessions;

        await eventRepository.saveChangesRetros(updatedGrades,selectedSessions);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        int? userId = prefs.getInt("currentUserId");

        if (userId == null) {
          throw Exception('No current user found');
        }
        
        print('Current User ID: $userId');
        List<Subject> subjects = await userRepository.getSubjectsByUserId(userId);
        List<Evaluation> evaluations = await eventRepository.uploadEvaluations();
        List<Event> events = await eventRepository.uploadEvents();
        List<UserSubjectEvent> use = await eventRepository.uploadUserSubjectEvents();

        for (Subject subject in subjects) {
          List<Map<String, dynamic>> formulaElements = subject.formula.split(', ')
            .map((e) {
              var parts = e.split(': ');
              return {
                'name': parts[0].trim(),
                'weight': double.parse(parts[1].replaceAll('%', '').trim()) / 100
              };
            }).toList();

          print('Parsed formula for ${subject.name}: $formulaElements');

          double weightedScore = 0.0;
          double totalWeight = 0.0;
          
          for (Evaluation evaluation in evaluations) {
            UserSubjectEvent useEvent;
            Event event;
            Map<String, dynamic> formulaPart;

            try {
              useEvent = use.firstWhere((u) => u.eventId == evaluation.id && u.subjectId == subject.id);
            } catch (e) {
              // Evento aún no ha ocurrido o no está registrado, continuar al siguiente
              continue;
            }

            try {
              event = events.firstWhere((e) => e.id == evaluation.id);
            } catch (e) {
              // Evento no encontrado, continuar al siguiente
              continue;
            }

            // Normalizando el nombre del evento
            String eventName = event.name.split(' of ')[0].trim();

            try {
              formulaPart = formulaElements.firstWhere((elem) => elem['name'] == eventName);
            } catch (e) {
              // Parte de la fórmula no encontrada, continuar al siguiente
              continue;
            }

            if (evaluation.grade < 0 || evaluation.grade > 10) {
              // Nota inválida, continuar al siguiente
              continue;
            }

            weightedScore += evaluation.grade * formulaPart['weight'];
            totalWeight += formulaPart['weight'];
            print('Processed grade ${evaluation.grade} for ${eventName} with weight ${formulaPart['weight']}');
          }

          if (totalWeight > 0) {
            weightedScore /= totalWeight;
          }
          int feedback = (weightedScore >= 8) ? 3 : (weightedScore >= 5) ? 2 : 1;
          print("Feedback for Subject ${subject.name}: $feedback");

          await userRepository.updateFeedbackFromSubject(subject.id,feedback);
        }


      } 
      catch(error){
        print(error);
      }
    });
  } 
}

DateTime getNearestMonday() {
  DateTime now = DateTime.now();
  int currentWeekday = now.weekday;

  // Dart's DateTime.weekday uses 1 for Monday and 7 for Sunday
  // Calculate the number of days to the next Monday
  int daysUntilMonday = DateTime.monday - currentWeekday;
  if (daysUntilMonday <= 0) {
    daysUntilMonday += 7; // Ensure it's always a future Monday unless today is Monday
  }

  DateTime nextMonday = now.add(Duration(days: daysUntilMonday));
  return nextMonday;
}


List<UserSubjectEvent> getUserSubjectEventsFromPlan(List<Event> eventsFromPlan, List<Subject> subjects, int userId)  {
  // Retrieve the current user ID from SharedPreferences
  

  List<UserSubjectEvent> userSubjectEvents = [];

  for (Event event in eventsFromPlan) {
    // Parse the subject name from event name assuming format 'session of subject <subject name>'
    String eventNamePattern = r'Session of Subject (.+)';
    RegExp regExp = RegExp(eventNamePattern);
    var match = regExp.firstMatch(event.name);

    if (match != null && match.groupCount >= 1) {
      String subjectName = match.group(1)!; // Extracted subject name
      // Find the corresponding subject ID
      Subject? subject = subjects.firstWhereOrNull((sub) => sub.name == subjectName);
      if (subject != null) {
        // Create a UserSubjectEvent and add to the list
        UserSubjectEvent userSubjectEvent = UserSubjectEvent(
          userId: userId,
          subjectId: subject.id,
          eventId: event.id,
        );
        userSubjectEvents.add(userSubjectEvent);
      } else {
        print('no match found for usersubjectevent');
      }
    }
  }

  return userSubjectEvents;
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

  


