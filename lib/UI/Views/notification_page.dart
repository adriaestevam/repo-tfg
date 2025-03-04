import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tfg_v1/Domain/CalendarBloc/calendar_bloc.dart';
import 'package:tfg_v1/Domain/NavigatorBloc/navigator_bloc.dart';
import 'package:tfg_v1/UI/Utilities/AppTheme.dart';
import 'package:tfg_v1/UI/Utilities/app_colors.dart';
import 'package:tfg_v1/UI/Views/Home/home_page.dart';
import 'package:tfg_v1/UI/Views/RetrospectiveScreen.dart';
import 'package:tfg_v1/UI/Views/objectives_page.dart';
import 'package:tfg_v1/UI/Views/subjects_page.dart';

import '../../Domain/NavigatorBloc/navigator_event.dart';
import '../Utilities/widgets.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  NotificationsScreenState createState() => NotificationsScreenState();
}

class NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedFolder = 'Inbox'; // Default selected folder
  
    

  @override
  Widget build(BuildContext context) {
    final NavigatorBloc navigatorBloc = BlocProvider.of<NavigatorBloc>(context);
    final CalendarBloc calendarBloc = BlocProvider.of<CalendarBloc>(context);

    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text("Calendar"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.account_circle),
          onPressed: () {
            // Lógica para la acción del icono de perfil
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildFolders(),
          Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.all(8),
            decoration: myBoxDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Realizar la retrospectiva de esta semana',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primaryColor, // Cambia esto según tu paleta de colores
                  ),
                ),
                SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      calendarBloc.add(getRetrosInformation());
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => RetrospectiveStepper(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: accentColor, // Color del botón
                    ),
                    child: Text('Empezar'),
                  ),
                ),
              ],
            ),
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
                color: accentColor, // Color personalizado
              ), 
              label: 'Objetivos',
              backgroundColor: backgroundColor,
            ),
            BottomNavigationBarItem(
              icon: MyBottomBarIcon(
                iconData: Icons.notifications, // El ícono que quieres usar
                size: 30, // Tamaño personalizado
                color: primaryColor, // Color personalizado
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
                calendarBloc.add(uploadEvents(userWantsPlan: false));navigatorBloc.add(GoToHomeEvent());
                break;
              case 1: navigatorBloc.add(GoToObjectivesEvent());
                break;
              case 2: navigatorBloc.add(GoToNotificationsEvent());
                break;
              case 3: navigatorBloc.add(GoToSubjectsEvent());
            }
          },
          currentIndex: 2, // Índice del botón actualmente seleccionado
        ),
      )
    );
  }

  Widget _buildFolders() {
    return SizedBox(
      height: 80,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFolderItem('Inbox', Icons.mail),
          _buildFolderItem('Archived', Icons.archive),
          _buildFolderItem('All', Icons.folder),
        ],
      ),
    );
  }

  Widget _buildFolderItem(String folderName, IconData icon) {
    bool isSelected = _selectedFolder == folderName;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFolder = folderName;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: const EdgeInsets.all(8),
        color: isSelected ? primaryColor : backgroundColor,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? Colors.white : secondaryTextColor),
            const SizedBox(width: 8),
            Text(
              folderName,
              style: TextStyle(
                color: isSelected ? Colors.white : secondaryTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


