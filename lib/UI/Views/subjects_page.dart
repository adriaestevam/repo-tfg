import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tfg_v1/Data/Models/Evaluation.dart';
import 'package:tfg_v1/Data/Models/Event.dart';
import 'package:tfg_v1/Data/Models/Subject.dart';
import 'package:tfg_v1/Domain/AcademiaBloc/academia_bloc.dart';
import 'package:tfg_v1/Domain/AcademiaBloc/academia_event.dart';
import 'package:tfg_v1/Domain/AcademiaBloc/academia_state.dart';
import 'package:tfg_v1/Domain/CalendarBloc/calendar_bloc.dart';
import 'package:tfg_v1/Domain/NavigatorBloc/navigator_bloc.dart';
import 'package:tfg_v1/Domain/SubjectBloc/subject_bloc.dart';
import 'package:tfg_v1/Domain/SubjectBloc/subject_event.dart';
import 'package:tfg_v1/UI/Utilities/AppTheme.dart';
import 'package:tfg_v1/UI/Utilities/app_colors.dart';
import 'package:tfg_v1/UI/Views/notification_page.dart';
import 'package:tfg_v1/UI/Views/objectives_page.dart';
import 'package:avatar_glow/avatar_glow.dart';
import '../../Domain/NavigatorBloc/navigator_event.dart';
import '../Utilities/widgets.dart';

class SubjectsScreen extends StatelessWidget {
  const SubjectsScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final NavigatorBloc navigatorBloc = BlocProvider.of<NavigatorBloc>(context);
    final SubjectBloc subjectBloc = BlocProvider.of<SubjectBloc>(context);
    final AcademiaBloc academiaBloc = BlocProvider.of<AcademiaBloc>(context);

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
                      academiaBloc.add(uploadAcademicData(subject: subject));
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
                      final CalendarBloc calendarBloc = BlocProvider.of<CalendarBloc>(context);
                      navigatorBloc.add(GoToHomeEvent());
                      calendarBloc.add(uploadEvents(userWantsPlan: false));
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
    AcademiaBloc academiaBloc = BlocProvider.of<AcademiaBloc>(context);

    return BlocBuilder<AcademiaBloc,AcademiaState>(builder: (context,state){
      if(state is AcademiaInitial){
        academiaBloc.add(uploadAcademicData(subject: subject));
        return Scaffold(
          appBar: AppBar(
            title: const Text('Cargando datos academicos'),
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
      } else if (state is displayInformation){
        List<Event> events = state.events;
        List<Evaluation> evaluations = state.evaluations;
        int feedback = state.feedback;
        
      
        List<Map<String, String>> formulaElements = subject.formula.split(', ')
        .map((e) {
          var parts = e.split(': ');
          return {
            'name': parts[0],
            'weight': parts[1]
          };
        }).toList();
        
        Map<String,TextEditingController> gradeControllers= getEvaluationsGradeControllers(formulaElements,events, evaluations);
        
        return Scaffold(
          appBar: AppBar(
            title: Text(subject.name),
            backgroundColor: backgroundColor,
          ),
          body: SingleChildScrollView(
            child: Center(
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
                            if (feedback == 1)
                              AvatarGlow(
                                animate: true,
                                glowColor: Colors.red,
                                
                                child: CircleAvatar(
                                  backgroundColor: Colors.red.withOpacity(0.5),
                                  radius: 30,
                                  child: Icon(Icons.error, size: 30, color: Colors.white),
                                ),
                              ),
                            if (feedback == 2)
                              AvatarGlow(
                                animate: true,
                                glowColor: Colors.amber,
                                
                                child: CircleAvatar(
                                  backgroundColor: Colors.amber.withOpacity(0.5),
                                  radius: 30,
                                  child: Icon(Icons.warning, size: 30, color: Colors.white),
                                ),
                              ),
                            if (feedback == 3)
                              AvatarGlow(
                                animate: true,
                                glowColor: Colors.green,
                                
                                child: CircleAvatar(
                                  backgroundColor: Colors.green.withOpacity(0.5),
                                  radius: 30,
                                  child: Icon(Icons.check, size: 30, color: Colors.white),
                                ),
                              ),
                            SizedBox(width: 10),
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
                        Container(
                          padding: EdgeInsets.all(20),
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Columna para el nombre del subject
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.book, size: 24),
                                  SizedBox(height: 8),
                                  Text('Nombre', style: TextStyle(fontSize: 16)),
                                  Text(subject.name, style: TextStyle(fontSize: 24,fontWeight: FontWeight.w500)),
                                ],
                              ),
                              // Columna para los créditos
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.confirmation_number, size: 24),
                                  SizedBox(height: 8),
                                  Text('Créditos', style: TextStyle(fontSize: 16)),
                                  Text('${subject.credits}', style: TextStyle(fontSize: 24,fontWeight: FontWeight.w500),),
                                ],
                              ),
                            ],
                          ),
                        ),

                        Text('Fórmula y Evaluaciones', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(height: 20,),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[500]!,
                                offset: Offset(4, 4),
                                blurRadius: 15,
                                spreadRadius: 1,
                              ),
                              BoxShadow(
                                color: Colors.white,
                                offset: Offset(-4, -4),
                                blurRadius: 15,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Table(
                            columnWidths: const {
                              0: FlexColumnWidth(3),
                              1: FlexColumnWidth(2),
                              2: FlexColumnWidth(2),
                            },
                            children: [
                              TableRow(
                                children: [
                                  TableCell(
                                    verticalAlignment: TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Componente', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[600])),
                                    ),
                                  ),
                                  TableCell(
                                    verticalAlignment: TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Peso', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[600])),
                                    ),
                                  ),
                                  TableCell(
                                    verticalAlignment: TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Nota', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[600])),
                                    ),
                                  ),
                                ],
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                  color: Colors.grey[200],
                                ),
                              ),
                              for (var element in formulaElements)
                                TableRow(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  children: [
                                    TableCell(
                                      verticalAlignment: TableCellVerticalAlignment.middle,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(element['name'] ?? ''),
                                      ),
                                    ),
                                    TableCell(
                                      verticalAlignment: TableCellVerticalAlignment.middle,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(element['weight'] ?? ''),
                                      ),
                                    ),
                                    TableCell(
                                      verticalAlignment: TableCellVerticalAlignment.middle,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: gradeControllers[element['name']]?.text.isEmpty ?? true ? Text('No Eva') : TextField(
                                          controller: gradeControllers[element['name']],
                                          onSubmitted: (value) {
                                            academiaBloc.add(UpdateEvaluationGradeEvent(name: element['name']!, newGrade: value, subject: subject));
                                          },
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder( // Esquinas no redondeadas
                                              borderSide: BorderSide.none, // No mostrar borde
                                            ),
                                            filled: false, // No fill
                                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10), // Adjusts internal padding to reduce height
                                            isDense: true, // Further reduces the height
                                          ),
                                          keyboardType: TextInputType.number,
                                          style: TextStyle(
                                            fontSize: 14, // Adjusts font size if necessary
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                            ],
                          ),

                        )

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ) 
        );
      } else {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Cargando datos academicos'),
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

      }

    });
  }
}

Map<String, TextEditingController> getEvaluationsGradeControllers(List<Map<String, String>> formulaElements, List<Event> events, List<Evaluation> evaluations) {
  Map<String, TextEditingController> controllers = {};

  for (var element in formulaElements) {
    String evaluationName = element['name'] ?? '';
    Event? matchingEvent = events.firstWhereOrNull((event) => event.name.contains(evaluationName));
    if (matchingEvent != null) {
      Evaluation? matchingEvaluation = evaluations.firstWhereOrNull((eval) => eval.id == matchingEvent.id);
      if (matchingEvaluation != null) {
        controllers[evaluationName] = TextEditingController(
          text: matchingEvaluation.grade == 11 ? '-' : matchingEvaluation.grade.toString()
        );
      }
    }
  }

  return controllers;
}




