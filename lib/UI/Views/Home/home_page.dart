import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tfg_v1/Data/Models/Evaluation.dart';
import 'package:tfg_v1/Data/Models/Event.dart';
import 'package:tfg_v1/Data/Models/Session.dart';
import 'package:tfg_v1/Data/Models/Subject.dart';
import 'package:tfg_v1/Data/Models/User-Subject-Event.dart';
import 'package:tfg_v1/UI/Utilities/AppTheme.dart';
import 'package:tfg_v1/UI/Utilities/widgets.dart';
import 'package:tfg_v1/UI/Views/Home/addNewEventScreen.dart';
import 'package:intl/intl.dart';
import '../../../Domain/CalendarBloc/calendar_bloc.dart';
import '../../../Domain/NavigatorBloc/navigator_bloc.dart';
import '../../../Domain/NavigatorBloc/navigator_event.dart';
import '../profileScreen.dart';



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
  bool _isEvaluation= false;
  String _selectedSubject = '';

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
        print('calendar initial');
        print('melon');
        calendarBloc.add(uploadEvents());
        return Scaffold(
          appBar: AppBar(
            title: Text('Cargando datos de la base de datos de eventos'),
          ),
          body: Center(
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
        print('esto es antes');
        selectedEvents = state.mapOfEvents;
        evaluationList = state.evaluationList;
        
        calendarBloc.add(readyToDisplayCalendar());
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
        print('estado displaycalendar');
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
          body: Column(
            children: [
              TableCalendar(
                focusedDay: selectedDay,
                firstDay: DateTime(1990),
                lastDay: DateTime(2050),
                calendarFormat: format,
                onFormatChanged: (CalendarFormat _format) {
                  setState(() {
                    format = _format;
                  });
                },
                startingDayOfWeek: StartingDayOfWeek.sunday,
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
                  selectedDecoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade500,
                        offset: Offset(4,4),
                        blurRadius: 5,
                        spreadRadius: 1
                      ),
                      BoxShadow(
                        color: Colors.white,
                        offset: Offset(-4,-4),
                        blurRadius: 5,
                        spreadRadius: 1
                      )
                    ],
                  ),
                  selectedTextStyle: TextStyle(color:Colors.white),
                  todayDecoration: BoxDecoration(
                    color: backgroundColor,
                    shape: BoxShape.rectangle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade500,
                        offset: Offset(4,4),
                        blurRadius: 5,
                        spreadRadius: 1
                      ),
                      BoxShadow(
                        color: Colors.white,
                        offset: Offset(-4,-4),
                        blurRadius: 5,
                        spreadRadius: 1
                      )
                    ],
                    borderRadius: BorderRadius.circular(5.0),
                  ),
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
                  formatButtonVisible: true,
                  titleCentered: true,
                  formatButtonShowsNext: false,
                  formatButtonDecoration: myBoxDecoration(),
                  formatButtonTextStyle: TextStyle(
                    color: secondaryTextColor,
                  ),
                ),
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, date, events) {
                    if (events.isNotEmpty) {
                      // Muestra un único punto si hay al menos un evento
                      return Positioned(
                        right: 1,
                        bottom: 1,
                        child: _buildEventsMarker(date, events),
                      );
                    }
                  },
                ), 
              ),
              ..._getEventsfromDay(selectedDay).map(
                (Event event) {
                  String eventDetails = "Hora no disponible";
                  IconData eventIcon = Icons.event_note; // Icono por defecto

                  // Buscar en la lista de evaluaciones
                  for (var eval in evaluationList) {
                    if (eval.id == event.id) {
                      eventDetails = "Evaluación a las " + DateFormat('HH:mm').format(eval.date);
                      eventIcon = Icons.assessment; // Icono para evaluaciones
                      break; // Salir del bucle si se encuentra la evaluación
                    }
                  }

                  // Si no se encontró en evaluaciones, buscar en las sesiones
                  if (eventDetails == "Hora no disponible") {
                    for (var sess in sessionsList) {
                      if (sess.id == event.id) {
                        eventDetails = "Sesión de " + DateFormat('HH:mm').format(sess.startTime) + " a " + DateFormat('HH:mm').format(sess.endTime);
                        eventIcon = Icons.schedule; // Icono para sesiones
                        break; // Salir del bucle si se encuentra la sesión
                      }
                    }
                  }

                  return ListTile(
                    leading: Icon(eventIcon),
                    title: Text(event.name),
                    subtitle: Text(eventDetails),
                    trailing: Icon(Icons.chevron_right),
                  );
                },
              ).toList(),



            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
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

                
                
                  // To refresh the UI and display the new event
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
              
              } else {
                print('No es ni un map');
              }

              
            },
            label: Text("Add Event"),
            icon: Icon(Icons.add),
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
                  case 0: navigatorBloc.add(GoToHomeEvent());
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

Widget _buildEventsMarker(DateTime date, List events) {
  return Container(
    decoration: eventMarkerDecoration(),
    width: 12.0, // Tamaño del punto
    height: 12.0, // Tamaño del punto
  );
}



