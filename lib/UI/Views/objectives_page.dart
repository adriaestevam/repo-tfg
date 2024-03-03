import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tfg_v1/Domain/NavigatorBloc/navigator_event.dart';
import 'package:tfg_v1/UI/Utilities/widgets.dart';
import 'package:tfg_v1/UI/Widgets/bottom_navigation_widget.dart';

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
    

    return Scaffold(
      appBar: AppBar(
        title: Text('Mi objetivos'),
        backgroundColor: backgroundColor,
      ),
      body: ListView(
        children: <Widget>[
          // Objetivos
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Objetivos',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          CheckboxListTile(
            title: Text('Aprobar todas las asignaturas'),
            value: true,
            onChanged: (bool? value) {
              // Actualizar el estado de este objetivo
            },
          ),
          CheckboxListTile(
            title: Text('Excelencia en DPOO'),
            value: false,
            onChanged: (bool? value) {
              // Actualizar el estado de este objetivo
            },
          ),

          // Prioridades
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Prioridades',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          for (var asignatura in prioridadesAsignaturas)
            ListTile(
              title: Text(asignatura),
              trailing: Icon(Icons.drag_handle),
              onTap: () {
                // Definir la acción al tocar en la asignatura
              },
            ),

          // Tareas para esta semana
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Para esta semana',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          for (var tarea in tareasSemana)
            ListTile(
              title: Text(tarea),
              trailing: Icon(Icons.edit),
              onTap: () {
                // Definir la acción al tocar en la tarea
              },
            ),
        ],
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
              case 0: navigatorBloc.add(GoToHomeEvent());
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
  }
}
