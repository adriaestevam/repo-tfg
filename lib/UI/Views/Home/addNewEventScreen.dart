import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tfg_v1/Data/Models/Event.dart';
import 'package:tfg_v1/Data/Models/Subject.dart';
import 'package:tfg_v1/UI/Utilities/AppTheme.dart';
import 'package:tfg_v1/UI/Utilities/widgets.dart';


class AddNewEventScreen extends StatefulWidget {
  @override
  _AddNewEventScreenState createState() => _AddNewEventScreenState();
}

class _AddNewEventScreenState extends State<AddNewEventScreen> {
  TextEditingController _eventNameController = TextEditingController();
  bool _isEvaluation = false;
  String? _selectedSubject;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedStartTime = TimeOfDay.now();
  TimeOfDay _selectedEndTime = TimeOfDay.now();

  List<Subject> _subjects = [
    Subject(id: Random().nextInt(100), universityId: 111, name: "Subject A", credits: 3, formula: "formula A"),
    Subject(id: Random().nextInt(100), universityId: 111, name: "Subject B", credits: 3, formula: "formula B"),
    Subject(id: Random().nextInt(100), universityId: 111, name: "Subject C", credits: 3, formula: "formula C"),
    Subject(id: Random().nextInt(100), universityId: 111, name: "Subject D", credits: 3, formula: "formula D")
    // Add more subjects as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Add New Event to the Calendar',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            myTransparentTextField(
              controller: _eventNameController, 
              obscureText: false, hintText: '', 
              labelText: 'Event name', 
              keyboardType: TextInputType.name
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if(!_isEvaluation)...[
                  Text('Event type: Session')
                ] else ...[
                  Text('Event type: Evaluation'),
                ],
                mySwitch(
                  value: _isEvaluation, 
                  onChanged: (value) {
                    setState(() {
                      _isEvaluation = value;
                    });
                  },
                ),
               
              ],
            ),
            SizedBox(height: 20.0),
            Container(
              child: DropdownButtonFormField<String>(
                value: _selectedSubject,
                items: _subjects
                    .map((subject) => DropdownMenuItem(
                          value: subject.name,
                          child: Text(subject.name),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSubject = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Subject',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0.0)
                  ),
                  
                ),
              ),
              decoration: myBoxDecoration(),
            ),
            
            SizedBox(height: 20.0),
            ListTile(
              title: Text('Date: ${_selectedDate.toString().split(' ')[0]}'),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null && picked != _selectedDate)
                  setState(() {
                    _selectedDate = picked;
                  });
              },
            ),
            if (!_isEvaluation) ...[
              ListTile(
                title: Text(
                    'Start Time: ${_selectedStartTime.format(context)}'),
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
              ListTile(
                title:
                    Text('End Time: ${_selectedEndTime.format(context)}'),
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
            ] else ... [
              ListTile(
                title: Text(
                    'Time: ${_selectedStartTime.format(context)}'),
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
            ],
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                myTransparentButton(
                  onPressed: () {Navigator.pop(context);}, 
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: secondaryTextColor),
                  ), 
                  decoration: myBoxDecoration(),
                  height: 50,
                  width: 100,
                ),
                myGreenButton(
                  onPressed: (){
                    //Generar evento y pasarlo al home
                    Event newEvent = Event(id: Random().nextInt(100), name: _eventNameController.text, isDone: false);
                    Navigator.pop(context,newEvent);
                  }, 
                  decoration: myBoxDecoration(), 
                  child: Text(
                    'Add',
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                  height: 50,
                  width: 100 ,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
