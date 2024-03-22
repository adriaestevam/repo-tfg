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

class AddNewEventScreen extends StatefulWidget {
  final DateTime selectedDay;
  const AddNewEventScreen({required this.selectedDay, Key? key}) : super(key: key);
  @override
  _AddNewEventScreenState createState() => _AddNewEventScreenState();
}

class _AddNewEventScreenState extends State<AddNewEventScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController _eventNameController = TextEditingController();
  Subject? _selectedSubject;
  TimeOfDay _selectedStartTime = TimeOfDay.now();
  TimeOfDay _selectedEndTime = TimeOfDay.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SubjectBloc subjectBloc = BlocProvider.of<SubjectBloc>(context);
    return BlocBuilder<SubjectBloc,SubjectState>(builder: (context,state){
      if(state is displaySubjectsInformation){
        List<Subject> _subjects = state.subjects;
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: backgroundColor,
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TabBar(
                  controller: _tabController,
                  tabs: [
                    Tab(text: 'Session'),
                    Tab(text: 'Evaluation'),
                  ],
                  onTap: (index) {
                    setState(() {
                      _currentTabIndex = index;
                    });
                  },
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildSessionTab(_subjects),
                      _buildEvaluationTab(_subjects),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        subjectBloc.add(loadSubjectsFromUser());
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

  Widget _buildSessionTab(List<Subject> subjects) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Add New Session Event to the Calendar',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20.0),
          // Dropdown for selecting subject
          Container(
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
                  _selectedSubject = subjects.firstWhere(
                    (subject) => subject.name == value);
                });
              },
              decoration: InputDecoration(
                labelText: 'Subject',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0.0),
                ),
              ),
            ),
            decoration: myBoxDecoration(),
          ),
          SizedBox(height: 20.0),
          // Start time picker
          ListTile(
            title: Text(
              'Start Time: ${_selectedStartTime.format(context)}',
            ),
            trailing: Icon(Icons.access_time),
            onTap: () async {
              final TimeOfDay? picked = await showTimePicker(
                context: context,
                initialTime: _selectedStartTime,
              );
              if (picked != null)
                setState(() {
                  _selectedStartTime = picked;
                });
            },
          ),
          // End time picker
          ListTile(
            title: Text(
              'End Time: ${_selectedEndTime.format(context)}',
            ),
            trailing: Icon(Icons.access_time),
            onTap: () async {
              final TimeOfDay? picked = await showTimePicker(
                context: context,
                initialTime: _selectedEndTime,
              );
              if (picked != null)
                setState(() {
                  _selectedEndTime = picked;
                });
            },
          ),
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              myGreenButton(
                onPressed: () async {
                  // Converting selected day, start time, and end time to DateTime
                  DateTime startDateTime = DateTime(
                    widget.selectedDay.year, 
                    widget.selectedDay.month, 
                    widget.selectedDay.day, 
                    _selectedStartTime.hour, 
                    _selectedStartTime.minute
                  );
                  DateTime endDateTime = DateTime(
                    widget.selectedDay.year, 
                    widget.selectedDay.month, 
                    widget.selectedDay.day, 
                    _selectedEndTime.hour, 
                    _selectedEndTime.minute
                  );

                  // Check if end time is after start time
                  if(endDateTime.isAfter(startDateTime)) {
                    // Creating the new session
                    int eventId = Random().nextInt(1000);

                    Session newSession = Session(
                      id: eventId, // Random ID for the session
                      startTime: startDateTime,
                      endTime: endDateTime,
                    );

                    Event newEvent = Event(
                      id: eventId, 
                      name: 'Session of subject ${_selectedSubject!.name}', 
                      isDone: false,
                    );

                    final SharedPreferences prefs = await SharedPreferences.getInstance();
                    int userId = prefs.getInt("currentUserId") ?? 0;

                    UserSubjectEvent newUserSubjectEvent =UserSubjectEvent(
                      userId: userId, 
                      subjectId: _selectedSubject!.id, 
                      eventId: eventId
                    );

                    Map<String, dynamic> eventData = {
                      'session': newSession,
                      'event': newEvent,
                      'userSubjectEvent': newUserSubjectEvent,
                    };



                    Navigator.pop(context, eventData);

                    // Add your logic to save the session or update your state here
                    // For example, you could add it to a list of sessions or call a function to save it to a database
                  } else {
                    // Show an error if end time is before start time
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Invalid Time'),
                        content: Text('End time must be after start time.'),
                        actions: [
                          TextButton(
                            child: Text('OK'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    );
                  }
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



  Widget _buildEvaluationTab(List<Subject> subjects) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Add New Session Event to the Calendar',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20.0),
          // Dropdown for selecting subject
          Container(
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
                  _selectedSubject = subjects.firstWhere(
                    (subject) => subject.name == value);
                });
              },
              decoration: InputDecoration(
                labelText: 'Subject',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0.0),
                ),
              ),
            ),
            decoration: myBoxDecoration(),
          ),
          SizedBox(height: 20.0),
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

                  int eventId = Random().nextInt(1000);

                  Evaluation newEvaluation = Evaluation(
                    id: eventId, 
                    date: date, 
                    grade: 11
                  );

                  Event newEvent = Event(
                    id: eventId,
                    name: 'Evaluation of subject ${_selectedSubject!.name}',
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

