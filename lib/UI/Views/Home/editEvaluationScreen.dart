import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfg_v1/Data/Models/Evaluation.dart';
import 'package:tfg_v1/Data/Models/Event.dart';
import 'package:tfg_v1/Data/Models/Subject.dart';
import 'package:tfg_v1/Data/Models/User-Subject-Event.dart';
import 'package:tfg_v1/Domain/SubjectBloc/subject_event.dart';
import 'package:tfg_v1/UI/Utilities/widgets.dart';

import '../../../Data/Models/Session.dart';
import '../../../Domain/SubjectBloc/subject_bloc.dart';
import '../../Utilities/AppTheme.dart';

class EditEvaluationScreen extends StatefulWidget {
  final DateTime selectedDay;
  final Evaluation originalEvaluation;
  const EditEvaluationScreen({required this.originalEvaluation, required this.selectedDay, Key? key}) : super(key: key);
  @override
  _EditEvaluationScreenState createState() => _EditEvaluationScreenState();
}

class _EditEvaluationScreenState extends State<EditEvaluationScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Subject? _selectedSubject;
  TimeOfDay _selectedTime = TimeOfDay.now();
  List<String> _formulaElements = [];
  String? _selectedFormulaElement;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _selectedFormulaElement = null;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SubjectBloc subjectBloc = BlocProvider.of<SubjectBloc>(context);
    return BlocBuilder<SubjectBloc, SubjectState>(builder: (context, state) {
      if (state is displaySubjectsInformation) {
        List<Subject> _subjects = state.subjects;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: backgroundColor,
          ),
          body: _buildEvaluationTab(_subjects),
        );
      } else {
        subjectBloc.add(loadSubjectsFromUser());
        return Scaffold(
          appBar: AppBar(
            title: Text('Cargando datos de usuario'),
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
  

  Widget _buildEvaluationTab(List<Subject> subjects) {


    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Edit Evaluation',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20.0),
          // Dropdown for selecting subject
          Container(
            decoration: myBoxDecoration(),
            child: DropdownButtonFormField<String>(
              value: _selectedSubject?.name,
              items: subjects
                  .map((subject) => DropdownMenuItem(
                        value: subject.name,
                        child: Text(subject.name),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSubject = subjects.firstWhere((subject) => subject.name == value);
                  // Analizar la fórmula y actualizar _formulaElements
                  _formulaElements = _selectedSubject!.formula.split(', ').map((e) => e.split(': ')[0]).toList();
                  
                  
                  _selectedFormulaElement = null; // Restablecer el elemento seleccionado
                });
              },
              decoration: InputDecoration(
                labelText: 'Subject',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0.0),
                ),
              ),
            ),
          ),
          SizedBox(height: 20.0),
          Container(
            decoration: myBoxDecoration(),
            child: DropdownButtonFormField<String>(
              value: _selectedFormulaElement,
              items: _formulaElements
                  .map((element) => DropdownMenuItem(
                        value: element,
                        child: Text(element),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedFormulaElement = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Formula Element',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          // Start time picker
          ListTile(
            title: Text(
              'Start Time: ${_selectedTime.format(context)}',
            ),
            trailing: Icon(Icons.access_time),
            onTap: () async {
              final TimeOfDay? picked = await showTimePicker(
                context: context,
                initialTime: _selectedTime,
              );
              if (picked != null)
                setState(() {
                  _selectedTime = picked;
                });
            },
          ),
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              myGreenButton(
                onPressed: () async {
                  //logica de guardar
                  DateTime date = DateTime(
                    widget.selectedDay.year, 
                    widget.selectedDay.month, 
                    widget.selectedDay.day, 
                    _selectedTime.hour, 
                    _selectedTime.minute
                  );

                  int eventId = widget.originalEvaluation.id;

                  Evaluation newEvaluation = Evaluation(
                    id: eventId, 
                    date: date, 
                    grade: 11
                  );

                  Event newEvent = Event(
                    id: eventId,
                    name: '${_selectedFormulaElement} of subject ${_selectedSubject!.name}',
                    isDone:false 
                  );

                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                  int userId = prefs.getInt("currentUserId") ?? 0;

                  UserSubjectEvent newUserSubjectEvent = UserSubjectEvent(
                    userId: userId, 
                    subjectId: _selectedSubject!.id, 
                    eventId: eventId
                  );

                  Map<String, dynamic> eventData = {
                      'evaluation': newEvaluation,
                      'event': newEvent,
                      'userSubjectEvent': newUserSubjectEvent,
                  };

                  Navigator.pop(context,eventData);
                }, 
                child: Text('Save',style: TextStyle(color: Colors.white),), 
                decoration: myBoxDecoration(), 
                height: 50, width: 140
              ),
              myTransparentButton(
                onPressed: (){
                  Navigator.pop(context);
                }, 
                child: Text('Cancel',style: TextStyle(color: accentColor),), 
                decoration: myBoxDecoration(), 
                height: 50, width: 140
              ),
            ],
          ),
        ],
      ),
    );
  }

}

