import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tfg_v1/Data/Models/Evaluation.dart';
import 'package:tfg_v1/Data/Models/Event.dart';
import 'package:tfg_v1/Data/Models/Session.dart';
import 'package:tfg_v1/Domain/CalendarBloc/calendar_bloc.dart';
import 'package:tfg_v1/UI/Utilities/widgets.dart'; // Ensure this includes needed widgets like colors

class RetrospectiveStepper extends StatefulWidget {
  const RetrospectiveStepper({Key? key}) : super(key: key);

  @override
  _RetrospectiveStepperState createState() => _RetrospectiveStepperState();
}

class _RetrospectiveStepperState extends State<RetrospectiveStepper> {
  int _currentStep = 0;
  Map<int, bool> selectedEvents = {}; // Tracks which events are selected
  Map<int,double> newGrades = {};
  

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (context, state) {
        if (state is displayRestrosInformation) {
          int totalSteps = 2;
          return Scaffold(
            appBar: AppBar(
              title: Text('Retrospectiva Semanal'),
              backgroundColor: backgroundColor, // Define this in your utilities
            ),
            body: Stepper(
              type: StepperType.vertical,
              currentStep: _currentStep,
              onStepContinue:_currentStep <= totalSteps - 1 ? _onStepContinue : null,
              onStepCancel: _currentStep > 0 ? _onStepCancel : null,
              steps: _steps(state.events, state.evaluations, state.sessions),
            ),
          );
        } else {
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
                  Text('Cargando...', style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  List<Step> _steps(List<Event> events, List<Evaluation> evaluations, List<Session> sessions) {
    return [
      Step(
        title: Text("Primer paso"),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Repaso Semanal",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Text("Selecciona las sesiones de estudio que has realizado."),
            SizedBox(height: 10),
            Flexible(
              fit: FlexFit.loose,
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: sessions.length,
                itemBuilder: (BuildContext context, int index) {
                  Session session = sessions[index];
                  Event event = events.firstWhere(
                    (e) => e.id == session.id,
                    orElse: () => Event(id: -1, name: "Evento no encontrado",isDone: false)
                  );
                  bool isSelected = selectedEvents[event.id] ?? false;
                   String formattedDate = DateFormat('EEEE d \'de\' MMMM \'de\' yyyy \'a las\' HH:mm', 'es_ES').format(session.startTime);
                  return CheckboxListTile(
                    value: isSelected,
                    onChanged: (bool? newValue) {
                      setState(() {
                        selectedEvents[event.id] = newValue ?? false;
                      });
                    },
                    title: Text(event.name),
                    subtitle: Text("${formattedDate}"), // Adjust date format as needed
                    controlAffinity: ListTileControlAffinity.leading,
                  );
                },
              ),
            ),
          ],
        ),
        isActive: _currentStep == 0,
        state: _currentStep > 0 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: Text('Segundo paso'),
        content: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Añade alguna nota que hayas recibido y no hayas registrado aún'),
            ),
            // Removed Expanded and replaced with a Container with definite height
            Container(
              height: 300, // Set this height based on your UI needs
              child: ListView.builder(
                itemCount: evaluations.length,
                itemBuilder: (context, index) {
                  final evaluation = evaluations[index];
                  final event = events.firstWhere(
                    (e) => e.id == evaluation.id,
                    orElse: () => Event(id: -1, name: "Evento no encontrado", isDone: false)
                  );

                  return ListTile(
                    title: Text(event.name),
                    subtitle: TextFormField(
                      initialValue: evaluation.grade.toString(),
                      decoration: InputDecoration(
                        labelText: 'Nota',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        newGrades[evaluation.id] = double.tryParse(value) ?? evaluation.grade;
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        isActive: _currentStep >= 1,
        state: _currentStep > 1 ? StepState.complete : StepState.indexed,
      )



      // Add other steps as needed
    ];
  }

 void _onStepContinue() {
  setState(() {
    if (_currentStep == 0) {
      print('Current step es $_currentStep');
      _currentStep++;
    } else {
      print('continue');
      final CalendarBloc calendarBloc = BlocProvider.of<CalendarBloc>(context);
      calendarBloc.add(SubmitEvaluationChangesEvent(newGrades, selectedEvents));
      // Optionally, navigate away or show a confirmation message
      Navigator.pop(context);
    }
  });
}


  void _onStepCancel() {
    setState(() {
      if (_currentStep > 0) {
        _currentStep -= 1;
      }
    });
  }
}
