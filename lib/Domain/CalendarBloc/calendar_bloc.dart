import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tfg_v1/Data/Models/Evaluation.dart';
import 'package:tfg_v1/Data/Models/Event.dart';
import 'package:tfg_v1/Data/Models/User-Subject-Event.dart';

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
    on<readyToDisplayCalendar>((event, emit) async {
      try{
        emit(displayCalendarInformation());
      } catch(error){
        print(error);
      }
    });
    
    on<uploadEvents>((event, emit) async {
      Map<DateTime, List<Event>> mapOfEvents = {};
      List<Event> userEvents = [];
      List<Evaluation> userEvaluations = [];

      try {
        if(await eventRepository.checkUserHasEvents()){
          userEvents = await eventRepository.uploadEvents();
          userEvaluations = await eventRepository.uploadEvaluations();

          // Create a map of evaluations by their ID for quick lookup
          Map<int, Evaluation> evaluationMap = { for (var e in userEvaluations) e.id: e };

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
            }
          }
        }
        
        emit(uploadEventsToUI(mapOfEvents: mapOfEvents,evaluationList: userEvaluations));

      } catch (error) {
        print(error);
      }

    });
  }
}
