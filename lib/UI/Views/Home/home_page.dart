import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tfg_v1/Data/Models/Event.dart';
import 'package:tfg_v1/Data/Models/Subject.dart';
import 'package:tfg_v1/UI/Utilities/AppTheme.dart';
import 'package:tfg_v1/UI/Utilities/widgets.dart';
import 'package:tfg_v1/UI/Views/Home/addNewEventScreen.dart';

import '../../../Domain/NavigatorBloc/navigator_bloc.dart';
import '../../../Domain/NavigatorBloc/navigator_event.dart';
import '../profileScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<DateTime, List<Event>> selectedEvents = {};
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  bool _isEvaluation= false;
  String _selectedSubject = '';

  TextEditingController _eventController = TextEditingController();

  @override
  void initState() {
    selectedEvents = {};
    super.initState();
  }

  List<Event> _getEventsfromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final NavigatorBloc navigatorBloc = BlocProvider.of<NavigatorBloc>(context);
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
            MaterialPageRoute(builder: (context) => ProfileScreen()), // Reemplaza PerfilScreen() con el nombre de tu pantalla de perfil
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
          ),
          ..._getEventsfromDay(selectedDay).map(
            (Event event) => ListTile(
              title: Text(
                event.name,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNewEventScreen()),
          );

          if (result is Event){
            //Add event to calendar
            //Save event in ddbb
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
}

