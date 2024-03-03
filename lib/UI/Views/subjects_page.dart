import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tfg_v1/Domain/NavigatorBloc/navigator_bloc.dart';
import 'package:tfg_v1/UI/Utilities/app_colors.dart';
import 'package:tfg_v1/UI/Views/notification_page.dart';
import 'package:tfg_v1/UI/Views/objectives_page.dart';
import 'package:tfg_v1/UI/Widgets/bottom_navigation_widget.dart';

import '../../Domain/NavigatorBloc/navigator_event.dart';
import '../Utilities/widgets.dart';

class SubjectsScreen extends StatelessWidget {
  const SubjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigatorBloc navigatorBloc = BlocProvider.of<NavigatorBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Subjects'),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: 8,
          itemBuilder: (context, index) {
            return SubjectCard(index + 1); // Subject cards with index starting from 1
          },
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

class SubjectCard extends StatelessWidget {
  final int subjectNumber;

  const SubjectCard(this.subjectNumber, {super.key});

  @override
  Widget build(BuildContext context) {
    Color cardColor = _generateRandomColor(); // Generate random color for each card

    return GestureDetector(
      onTap: () {
        // Handle onTap for the card
        // You can navigate to a detailed subject page or perform any other action
      },
      child: Card(
        color: cardColor,
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 8,
              right: 8,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Subject $subjectNumber',
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _generateRandomColor() {
    // Generate random color using app color palette
    List<Color> colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.accent,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.indigo,
    ];
    return colors[subjectNumber % colors.length]; // Get color based on subject number
  }
}
