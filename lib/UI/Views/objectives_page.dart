import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tfg_v1/Data/Models/Subject.dart';
import 'package:tfg_v1/Domain/CalendarBloc/calendar_bloc.dart';
import 'package:tfg_v1/Domain/NavigatorBloc/navigator_event.dart';
import 'package:tfg_v1/Domain/SubjectBloc/subject_bloc.dart';
import 'package:tfg_v1/Domain/SubjectBloc/subject_event.dart';
import 'package:tfg_v1/UI/Utilities/AppTheme.dart';
import 'package:tfg_v1/UI/Utilities/widgets.dart';
import 'package:tfg_v1/UI/Views/profileScreen.dart';

import '../../Domain/NavigatorBloc/navigator_bloc.dart';

List<String> objetivos = ['Aprobar todas las asignaturas', 'Excelencia en Chemistry', 'Excelencia en Biology'];
List<String> prioridadesAsignaturas = ['Matemáticas', 'Biología', 'Química'];
List<String> tareasSemana = ['Preparar presentación de Biología', 'Estudiar para examen de Química', 'Hacer ejercicios de Matemáticas'];

class ObjectivesScreen extends StatefulWidget {
  const ObjectivesScreen({Key? key}) : super(key: key);

  @override
  _ObjectivesScreenState createState() => _ObjectivesScreenState();
}

class _ObjectivesScreenState extends State<ObjectivesScreen> {
  
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    // Assume AppTheme is defined somewhere in your application
    final appTheme = Theme.of(context);
    final NavigatorBloc navigatorBloc = BlocProvider.of<NavigatorBloc>(context);
    final SubjectBloc subjectBloc = BlocProvider.of<SubjectBloc>(context);

    return BlocBuilder<SubjectBloc, SubjectState>(
      builder: (context, state) {
        if(state is displayObjectivesAndPriorities){
          // Maximum number of items in either list to determine the container height
          int maxItems = max(state.subjects.length, state.objectivesAndPriorities.length);
          double containerHeight = maxItems * 60.0; // Assuming each ListTile has an approximate height of 60 pixels

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
            body: SingleChildScrollView(
              child: Column(
                children: [
                  // Sección de objetivos
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Container para la lista de aprobados
                        Container(
                          height: containerHeight, // Set the height dynamically
                          decoration: myBoxDecoration(),
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5),
                              Text(
                                'Aprobar:',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 2),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: state.subjects.length,
                                itemBuilder: (context, index) {
                                  final subject = state.subjects[index];
                                  final objective = state.objectivesAndPriorities.firstWhere(
                                    (element) => element.subjectId == subject.id,
                                  );
                                  if (objective != null && objective.objective == 'Pass') {
                                    return ListTile(
                                      title: Text(subject.name),
                                      subtitle: Text('Créditos: ${subject.credits}'),
                                    );
                                  } else {
                                    return SizedBox.shrink(); // Oculta los elementos que no cumplen el criterio
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        // Container para la lista de honor
                        Container(
                          height: containerHeight, // Set the height dynamically
                          decoration: myBoxDecoration(),
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5),
                              Text(
                                'Honour:',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 2),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: state.subjects.length,
                                itemBuilder: (context, index) {
                                  final subject = state.subjects[index];
                                  final objective = state.objectivesAndPriorities.firstWhere(
                                    (element) => element.subjectId == subject.id,
                                  );
                                  if (objective != null && objective.objective == 'Honors') {
                                    return ListTile(
                                      title: Text(subject.name),
                                      subtitle: Text('Créditos: ${subject.credits}'),
                                    );
                                  } else {
                                    return SizedBox.shrink(); // Oculta los elementos que no cumplen el criterio
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Lista reordenable de asignaturas basada en la prioridad
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Asignaturas por Prioridad:',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        ReorderableListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          reverse: true, // Invertir el orden
                          children: state.subjects.map((subject) {
                            final objective = state.objectivesAndPriorities.firstWhere(
                              (element) => element.subjectId == subject.id,
                            );
                            return ListTile(
                              key: Key(subject.id.toString()),
                              title: Text(subject.name),
                              subtitle: Text(objective != null ? 'Prioridad: ${objective.priority}' : 'Prioridad: No definida'),
                            );
                          }).toList(),
                          onReorder: (oldIndex, newIndex) {
                            // Implementa la lógica de reordenamiento aquí
                          },
                        ),
                      ],
                    ),
                  ),
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
                      color: accentColor, // Color personalizado
                    ), // Tamaño más grande para el ícono
                    label: 'Home',
                    backgroundColor: backgroundColor,
                  ),
                  BottomNavigationBarItem(
                    icon: MyBottomBarIcon(
                      iconData: Icons.star, // El ícono que quieres usar
                      size: 30, // Tamaño personalizado
                      color: primaryColor, // Color personalizado
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
                    final CalendarBloc calendarBloc = BlocProvider.of<CalendarBloc>(context);
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
                currentIndex: 1, // Índice del botón actualmente seleccionado
              ),
            )
          );
        } else {
          subjectBloc.add(loadObjectivesAndPriorities());
          return Scaffold(
            appBar: AppBar(
              title: Text('Cargando datos de usuario'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text(
                    'Cargando datos de usuario...',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          );
        }
      }
    );
      
  }
}