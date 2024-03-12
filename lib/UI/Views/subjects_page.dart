import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tfg_v1/Data/Models/Subject.dart';
import 'package:tfg_v1/Domain/NavigatorBloc/navigator_bloc.dart';
import 'package:tfg_v1/Domain/SubjectBloc/subject_bloc.dart';
import 'package:tfg_v1/Domain/SubjectBloc/subject_event.dart';
import 'package:tfg_v1/UI/Utilities/AppTheme.dart';
import 'package:tfg_v1/UI/Utilities/app_colors.dart';
import 'package:tfg_v1/UI/Views/notification_page.dart';
import 'package:tfg_v1/UI/Views/objectives_page.dart';

import '../../Domain/NavigatorBloc/navigator_event.dart';
import '../Utilities/widgets.dart';

class SubjectsScreen extends StatelessWidget {
  const SubjectsScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final NavigatorBloc navigatorBloc = BlocProvider.of<NavigatorBloc>(context);
    final SubjectBloc subjectBloc = BlocProvider.of<SubjectBloc>(context);

    return BlocBuilder<SubjectBloc, SubjectState>(
      builder: (context, state) {
        if (state is displaySubjectsInformation) {
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
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemCount: state.subjects.length,
                itemBuilder: (context, index) {
                  final subject = state.subjects[index];
                  return GestureDetector(
                    onTap: () {
                      // Navegar a la página de detalles de la asignatura
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SubjectDetailsPage(subject),
                        ),
                      );
                    },
                    child: SubjectCard(subject),
                  );
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
                      iconData: Icons.home,
                      size: 30,
                      color: accentColor,
                    ),
                    label: 'Home',
                    backgroundColor: backgroundColor,
                  ),
                  BottomNavigationBarItem(
                    icon: MyBottomBarIcon(
                      iconData: Icons.star,
                      size: 30,
                      color: accentColor,
                    ),
                    label: 'Objetivos',
                    backgroundColor: backgroundColor,
                  ),
                  BottomNavigationBarItem(
                    icon: MyBottomBarIcon(
                      iconData: Icons.notifications,
                      size: 30,
                      color: accentColor,
                    ),
                    label: 'Notificaciones',
                    backgroundColor: backgroundColor,
                  ),
                  BottomNavigationBarItem(
                    icon: MyBottomBarIcon(
                      iconData: Icons.school,
                      size: 30,
                      color: primaryColor,
                    ),
                    label: 'Asignaturas',
                    backgroundColor: backgroundColor,
                  ),
                ],
                selectedFontSize: 12,
                unselectedFontSize: 12,
                iconSize: 30,
                backgroundColor: backgroundColor,
                onTap: (index) {
                  switch (index) {
                    case 0:
                      navigatorBloc.add(GoToHomeEvent());
                      break;
                    case 1:
                      navigatorBloc.add(GoToObjectivesEvent());
                      break;
                    case 2:
                      navigatorBloc.add(GoToNotificationsEvent());
                      break;
                    case 3:
                      navigatorBloc.add(GoToSubjectsEvent());
                  }
                },
                currentIndex: 3,
              ),
            ),
          );
        } else {
          //event to load subjects data
          subjectBloc.add(loadSubjectsFromUser());
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
      },
    );
  }
}

class SubjectCard extends StatelessWidget {
  final Subject subject;

  const SubjectCard(this.subject, {Key? key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        decoration: myBoxDecoration(),
        child: Stack(
          children: [
            Positioned(
              bottom: 8,
              right: 8,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  subject.name,
                  style: const TextStyle(
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
}

class SubjectDetailsPage extends StatelessWidget {
  final Subject subject;

  const SubjectDetailsPage(this.subject, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(subject.name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 30),
            Container(
              padding: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: myBoxDecoration(),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.red.withOpacity(0.5), // Luz roja apagada
                        radius: 30,
                      ),
                      SizedBox(width: 10),
                      CircleAvatar(
                        backgroundColor: Colors.amber.withOpacity(0.5), // Luz amarilla apagada
                        radius: 30,
                      ),
                      SizedBox(width: 10),
                      CircleAvatar(
                        backgroundColor: Colors.green, // Luz verde encendida
                        radius: 30,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Estado del semáforo:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: myBoxDecoration(),
              child: Column(
                children: [
                  Text(
                    'Detalles de la asignatura',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  ListTile(
                    leading: Icon(Icons.book),
                    title: Text('Nombre'),
                    subtitle: Text(subject.name),
                  ),
                  ListTile(
                    leading: Icon(Icons.account_balance_wallet),
                    title: Text('Créditos'),
                    subtitle: Text('${subject.credits}'),
                  ),
                  ListTile(
                    leading: Icon(Icons.calculate),
                    title: Text('Fórmula'),
                    subtitle: Text(subject.formula),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


