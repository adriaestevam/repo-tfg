import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tfg_v1/Data/Models/Evaluation.dart';
import 'package:tfg_v1/Data/Models/Event.dart';
import 'package:tfg_v1/Data/Models/Session.dart';
import 'package:tfg_v1/Data/Models/User-Subject-Event.dart';
import 'package:tfg_v1/UI/Utilities/AppTheme.dart';
import 'package:tfg_v1/UI/Utilities/widgets.dart';
import 'package:intl/intl.dart';
import 'package:tfg_v1/UI/Views/Home/addNewEventScreen.dart';
import 'package:tfg_v1/UI/Views/Home/editEvaluationScreen.dart';
import 'package:tfg_v1/UI/Views/Home/editSessionScreen.dart';
import '../../../Domain/CalendarBloc/calendar_bloc.dart';
import '../../../Domain/NavigatorBloc/navigator_bloc.dart';
import '../../../Domain/NavigatorBloc/navigator_event.dart';
import '../profileScreen.dart';
import 'package:collection/collection.dart'; 


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<DateTime, List<Event>> selectedEvents = {};
  List<UserSubjectEvent> userSubjectEventLsit = [];
  List<Session> sessionsList = [];
  List<Evaluation> evaluationList = [];
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();


  TextEditingController _eventController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  List<Event> _getEventsfromDay(DateTime date) {
    // Crea una nueva fecha solo con año, mes y día
    DateTime justDate = DateTime(date.year, date.month, date.day);

    // Filtra los eventos que coincidan con la fecha, sin importar la hora
    return selectedEvents.entries
        .where((entry) {
          DateTime eventDate = entry.key;
          // Comparar solo año, mes y día del evento
          return DateTime(eventDate.year, eventDate.month, eventDate.day) == justDate;
        })
        .expand((entry) => entry.value)
        .toList();
  }

  List<Widget> _buildEventList(DateTime date) {
  // Filter events for the given day
  List<Event> dayEvents = _getEventsfromDay(date);

  // Separately track evaluations and sessions
  List<Widget> evaluationsWidgets = [];
  List<Widget> sessionsWidgets = [];

  // Iterate over events and categorize them
  for (var event in dayEvents) {
    var eval = evaluationList.firstWhereOrNull((e) => e.id == event.id);
    var session = sessionsList.firstWhereOrNull((s) => s.id == event.id);

    if (eval != null) {
      // It's an evaluation
      evaluationsWidgets.add(_buildEvaluationTile(eval, event));
    } else if (session != null) {
      // It's a session
      sessionsWidgets.add(_buildSessionTile(session, event));
    }
  }

  // Return the list of widgets, with evaluations first, followed by sessions
  return [
    if (evaluationsWidgets.isNotEmpty) ...[
      Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Text('Evaluations', style: Theme.of(context).textTheme.headline6),
      ),
      ...evaluationsWidgets,
    ],
    if (sessionsWidgets.isNotEmpty) ...[
      Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Text('Sessions', style: Theme.of(context).textTheme.headline6),
      ),
      ...sessionsWidgets,
    ],
  ];
  }

  Widget _buildEvaluationTile(Evaluation evaluation, Event event) {
    
    final CalendarBloc calendarBloc = BlocProvider.of<CalendarBloc>(context);

    return Container(
      decoration: myBoxDecoration(),
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Stack(
        children: [
          ListTile(
            leading: Icon(Icons.local_library),
            title: Text(event.name),
            subtitle: Text("Evaluación a las " + DateFormat('HH:mm').format(evaluation.date)),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, size: 20),
                  onPressed: () async {
                    // Navegar a la pantalla de edición y obtener los resultados actualizados
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditEvaluationScreen(originalEvaluation: evaluation, selectedDay: evaluation.date,)),
                    );

                    if (result is Map && result.containsKey('evaluation')) {
                      Evaluation newEvaluation = result['evaluation'];
                      Event newEvent = result['event'];
                      UserSubjectEvent newUserSubjectEvent = result['userSubjectEvent'];

                      // Actualizar la lista de evaluaciones
                      int index = evaluationList.indexWhere((eva) => eva.id == evaluation.id);
                      if (index != -1) {
                        evaluationList[index] = newEvaluation;
                      }

                      // Actualizar la lista de eventos
                      DateTime adjustedSelectedDay = _getDateOnly(selectedDay);
                      int eventIndex = -1;
                      selectedEvents.forEach((date, events) {
                        if (_getDateOnly(date) == adjustedSelectedDay) {
                          int tempIndex = events.indexWhere((e) => e.id == newEvent.id);
                          if (tempIndex != -1) {
                            eventIndex = tempIndex;
                            selectedEvents[date]![tempIndex] = newEvent; // Actualiza el evento en el día correcto
                          }
                        }
                      });

                      if (eventIndex == -1) {
                        print('Error: Evento no encontrado para el día ajustado.');
                      }

                      // Actualizar la lista de UserSubjectEvent
                      int userSubjectEventIndex = userSubjectEventLsit.indexWhere((use) => use.eventId == newUserSubjectEvent.eventId);
                      if (userSubjectEventIndex != -1) {
                        userSubjectEventLsit[userSubjectEventIndex] = newUserSubjectEvent;
                      }

                      // Llamar al bloc para actualizar la base de datos, etc.
                      calendarBloc.add(updateEvaluation(newEvaluation: newEvaluation, newEvent: newEvent, newUserSubjectEvent: newUserSubjectEvent));

                      // Actualizar el UI
                      setState(() {});

                      
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, size: 20),
                  onPressed: () {
                    // Llamar a la función de eliminación
                    _deleteEvaluation(evaluation.id);
                    setState(() {});
                  },
                ),
                if(event.isDone)
                  Positioned(
                    right: 12,
                    bottom: 10,
                    child: Icon(Icons.check_circle, color: primaryColor, size: 20)
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionTile(Session session, Event event) {
    
    final CalendarBloc calendarBloc = BlocProvider.of<CalendarBloc>(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      decoration: myBoxDecoration(),
      child: Stack(
        children: [
          ListTile(
            leading: Icon(Icons.lightbulb_outline),
            title: Text(event.name, style: TextStyle(color: Colors.black87)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Start: " + DateFormat('HH:mm').format(session.startTime)),
                SizedBox(height: 4),
                Text("End: " + DateFormat('HH:mm').format(session.endTime)),
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, size: 20),
                  onPressed: () async {
                    // Navegar a la pantalla de edición y obtener los resultados actualizados
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditSessionScreen(originalSession: session, selectedDay: session.startTime,)),
                    );

                    if (result is Map && result.containsKey('session')) {

                      Session newSession = result['session'];
                      Event newEvent = result['event'];
                      UserSubjectEvent newUserSubjectEvent = result['userSubjectEvent'];

                      // Actualizar la sesión, el evento y UserSubjectEvent en las listas y mapas
                      int index = sessionsList.indexWhere((s) => s.id == session.id);
                      if (index != -1) {
                        sessionsList[index] = newSession;
                      }
                      
                      DateTime adjustedSelectedDay = _getDateOnly(selectedDay);
                      int eventIndex = -1;
                      selectedEvents.forEach((date, events) {
                        if (_getDateOnly(date) == adjustedSelectedDay) {
                          int tempIndex = events.indexWhere((e) => e.id == newEvent.id);
                          if (tempIndex != -1) {
                            eventIndex = tempIndex;
                            selectedEvents[date]![tempIndex] = newEvent; // Actualiza el evento en el día correcto
                          }
                        }
                      });

                      if (eventIndex == -1) {
                        print('Error: Evento no encontrado para el día ajustado.');
                      }

                      int userSubjectEventIndex = userSubjectEventLsit.indexWhere((use) => use.eventId == newUserSubjectEvent.eventId);
                      if (userSubjectEventIndex != -1) {
                        userSubjectEventLsit[userSubjectEventIndex] = newUserSubjectEvent;
                      }

                      
                      calendarBloc.add(updateSession(newSession: newSession, newEvent: newEvent, newUserSubjectEvent: newUserSubjectEvent));
                      
                      // Actualizar el UI
                      setState(() {});
                    }
                  },
                ),

                IconButton(
                  icon: const Icon(Icons.delete, size: 20),
                  onPressed: () {
                    // Implementar lógica de eliminación
                     _deleteSession(session.id);
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
          if(event.isDone)
            Positioned(
              right: 12,
              bottom: 10,
              child: Icon(Icons.check_circle, color: primaryColor, size: 20)
            )
        ],
      ),
    );
  }

  void _deleteSession(int sessionId) {
    final CalendarBloc calendarBloc = BlocProvider.of<CalendarBloc>(context);

    setState(() {
      // Eliminar la sesión de la lista
      sessionsList.removeWhere((session) => session.id == sessionId);

      // Actualizar selectedEvents para quitar el evento asociado
      selectedEvents.forEach((date, events) {
        events.removeWhere((event) => event.id == sessionId);
      });
    });

    calendarBloc.add(DeleteSessionEvent(sessionId: sessionId));
  }

  void _deleteEvaluation(int evaluationId) {
    final CalendarBloc calendarBloc = BlocProvider.of<CalendarBloc>(context);
    
    setState(() {
      // Eliminar la sesión de la lista
      evaluationList.removeWhere((evaluation) => evaluation.id == evaluationId);

      // Actualizar selectedEvents para quitar el evento asociado
      selectedEvents.forEach((date, events) {
        events.removeWhere((event) => event.id == evaluationId);
      });
    });

    calendarBloc.add(DeleteEvaluationEvent(evaluationId: evaluationId));
  }





  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final NavigatorBloc navigatorBloc = BlocProvider.of<NavigatorBloc>(context);
    final CalendarBloc calendarBloc = BlocProvider.of<CalendarBloc>(context);

    return BlocBuilder<CalendarBloc,CalendarState>(builder: (context, state) {
      if(state is CalendarInitial){
    
        calendarBloc.add(uploadEvents(userWantsPlan: false));
        return Scaffold(
          appBar: AppBar(
            title: const Text('Cargando datos de la base de datos de eventos'),
          ),
          body: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(), // Icono de carga
                SizedBox(height: 20),
                Text(
                  'Cargando datos de usuario...',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        );

      } else if(state is uploadEventsToUI){
      
        selectedEvents = state.mapOfEvents;
        evaluationList = state.evaluationList;
        sessionsList = state.sessionList;
        
        calendarBloc.add(readyToDisplayCalendar(userWantsPlan: state.userWantsPlan));
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check,color: Colors.green,), // Icono de carga
                SizedBox(height: 20),
                Text(
                  'Events have been uploaded!',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        );

      } 
      else if(state is displayCalendarInformation){
       
        return Scaffold(
          appBar: AppBar(
            backgroundColor: backgroundColor,
            title: Text("Calendar"),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()), 
                );
              },
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  // Lógica para la acción del icono de configuración
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child:Column(
              children: [                
                Padding(
                  padding:  const EdgeInsets.only(left: 8.0, right: 8),
                  child: Card(
                    color: Colors.transparent,
                    elevation: 0,
                    child: TableCalendar(
                      focusedDay: selectedDay,
                      firstDay: DateTime(1990),
                      lastDay: DateTime(2050),
                      calendarFormat: format,
                      onFormatChanged: (CalendarFormat _format) {
                        setState(() {
                          format = _format;
                        });
                      },
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      daysOfWeekVisible: true,

                      //Day Changed
                      onDaySelected: (DateTime selectDay, DateTime focusDay) {
                        setState(() {
                          selectedDay = selectDay;
                          focusedDay = focusDay;
                        });
                        print(focusedDay);
                      },
                      selectedDayPredicate: (DateTime date) {
                        return isSameDay(selectedDay, date);
                      },

                      eventLoader: _getEventsfromDay,

                      //To style the Calendar
                      calendarStyle: CalendarStyle(
                        isTodayHighlighted: true,
                        selectedDecoration: myDayofCalendarDecoration(),
                        selectedTextStyle: TextStyle(color:Colors.white),
                        todayTextStyle: TextStyle(color: primaryColor,fontWeight: FontWeight.bold),
                        todayDecoration: currentDayDecoration(),
                        defaultDecoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        weekendDecoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      headerStyle: HeaderStyle(
                        leftChevronVisible: false,
                        rightChevronIcon: Icon(Icons.arrow_forward_ios, size: 15, color: backgroundColor),
                        formatButtonDecoration: myBoxDecoration()
                    
                      ),
                      calendarBuilders: CalendarBuilders(
                        markerBuilder: (context, date, events) {
                          if (events.isNotEmpty) {
                            return Positioned(
                              right: 1,
                              top: 1,
                              child: _buildEventsMarker(date, events),
                            );
                          }
                          return null;
                        },
                      ), 
                    ),
                  ),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: myRoundButtonDecoration(),
                        child: IconButton(
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AddNewEventScreen(selectedDay: selectedDay,)),
                            );

                            if(result is Map && result.containsKey('session')){
                              Session newSession = result['session'];
                              Event newEvent = result['event'];
                              UserSubjectEvent newUserSubjectEvent = result['userSubjectEvent'];

                              if (selectedEvents[selectedDay] == null) {
                                selectedEvents[selectedDay] = [];
                              }

                              // Now it's safe to add the new event
                              selectedEvents[selectedDay]!.add(newEvent);
                              sessionsList.add(newSession);
                              userSubjectEventLsit.add(newUserSubjectEvent);

                              calendarBloc.add(addNewSession(
                                newSession: newSession,
                                newEvent: newEvent,
                                newUserSubjectEvent : newUserSubjectEvent
                              ));
                                                      
                              setState(() {});

                            } else if (result is Map && result.containsKey('evaluation')){
                                Evaluation newEvaluation = result['evaluation'];
                                Event newEvent = result['event'];
                                UserSubjectEvent newUserSubjectEvent = result['userSubjectEvent'];
                              
                                if (selectedEvents[selectedDay] == null) {
                                  selectedEvents[selectedDay] = [];
                                }

                                // Now it's safe to add the new event
                                selectedEvents[selectedDay]!.add(newEvent);
                                evaluationList.add(newEvaluation);
                                userSubjectEventLsit.add(newUserSubjectEvent);

                                
                                calendarBloc.add(addNewEvaluation(
                                  newEvaluation: newEvaluation,
                                  newEvent: newEvent,
                                  newUserSubjectEvent: newUserSubjectEvent
                                ));

                                setState(() {});
                              } 
                            },
                          icon: const Icon(Icons.add),
                          color: accentColor, // Color del ícono
                        ),
                      ),
                      SizedBox(width: 20,),
                      Container(
                        decoration: state.userWantsPlan ? myRoundButtonDecorationActive() : myRoundButtonDecorationDesactive(),
                        child: IconButton(
                          onPressed: (){
                            if (!state.userWantsPlan) {
                              calendarBloc.add(uploadEvents(userWantsPlan: true));
                            }
                          },
                          icon: Icon(state.userWantsPlan ? Icons.check : Icons.sync),
                          color: state.userWantsPlan ? backgroundColor : primaryColor
                        ),
                      ),
                    ],), 
                ..._buildEventList(selectedDay)
              ],
            ), 
          ),
              
      
  
          bottomNavigationBar: SizedBox(
            height: 100,
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  icon: MyBottomBarIcon(
                    iconData: Icons.home, // El ícono que quieres usar
                    size: 30, // Tamaño personalizado
                    color: primaryColor, // Color personalizado
                  ), // Tamaño más grande para el ícono
                  label: 'Home',
                  backgroundColor: backgroundColor,
                ),
                BottomNavigationBarItem(
                  icon: MyBottomBarIcon(
                    iconData: Icons.star, // El ícono que quieres usar
                    size: 30, // Tamaño personalizado
                    color: accentColor, // Color personalizado
                  ), 
                  label: 'Objetivos',
                  backgroundColor: backgroundColor,
                ),
                BottomNavigationBarItem(
                  icon: MyBottomBarIcon(
                    iconData: Icons.notifications, // El ícono que quieres usar
                    size: 30, // Tamaño personalizado
                    color: accentColor, // Color personalizado
                  ),  // Ícono para 'Notificaciones'
                  label: 'Notificaciones',
                  backgroundColor: backgroundColor,
                ),
                BottomNavigationBarItem(
                  icon: MyBottomBarIcon(
                    iconData: Icons.school, // El ícono que quieres usar
                    size: 30, // Tamaño personalizado
                    color: accentColor, // Color personalizado
                  ),  // Ícono para 'Asignaturas Universitarias'
                  label: 'Asignaturas',
                  backgroundColor: backgroundColor,
                ),
              ],
              selectedFontSize: 12, // Ajusta el tamaño del texto cuando está seleccionado
              unselectedFontSize: 12, // Ajusta el tamaño del texto cuando no está seleccionado
              iconSize: 30, 
              backgroundColor: backgroundColor,// Tamaño general de los íconos
              // ... otras propiedades como currentIndex, onTap, etc
              onTap: (index) {
                switch(index){
                  case 0: 
                    navigatorBloc.add(GoToHomeEvent());
                    calendarBloc.add(uploadEvents(userWantsPlan: false));
                    break;
                  case 1: navigatorBloc.add(GoToObjectivesEvent());
                    break;
                  case 2: navigatorBloc.add(GoToNotificationsEvent());
                    break;
                  case 3: navigatorBloc.add(GoToSubjectsEvent());
                }
              },
              currentIndex: 0, // Índice del botón actualmente seleccionado
            ),
          ), 
        );
      } 
      else {
        print('estado else');
        return Scaffold(
          appBar: AppBar(
            title: Text('Cargando datos de usuario'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(), // Icono de carga
                SizedBox(height: 20),
                Text(
                  'Cargadedededede...',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        );
        }
      },);
    }
  }
  
  DateTime _getDateOnly(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }


Widget _buildEventsMarker(DateTime date, List events) {
  return Container(
    decoration: eventMarkerDecoration(),
    width: 9.0, // Tamaño del punto
    height: 9.0, // Tamaño del punto
  );
}




