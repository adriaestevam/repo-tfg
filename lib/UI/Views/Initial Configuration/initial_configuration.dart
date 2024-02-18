import 'package:flutter/material.dart';
import 'package:tfg_v1/UI/Views/Initial%20Configuration/addNewSubject.dart';

class InitialConfigurationScreen extends StatefulWidget {
  @override
  _InitialConfigurationScreenState createState() =>
      _InitialConfigurationScreenState();
}

class _InitialConfigurationScreenState
    extends State<InitialConfigurationScreen> {
  int _currentStep = 0;
  final int _totalSteps = 6;
  final _nameController = TextEditingController();
  final _universityController = TextEditingController();
  List<String> subjects = ['Math', 'Physics', 'Chemistry']; // Example subjects
  Map<String, bool> selectedSubjects = {};
  Map<String, String> objectives = {}; // Almacena 'Pass', 'Honors' o 'None'
  Map<String, TimeOfDay> studyStartTimes = {};
  Map<String, TimeOfDay> studyEndTimes = {};
  int _activeDayStep = 0; // Para manejar el día activo en el Stepper

  List<Step> _buildStudySteps() {
    var daysOfWeek = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

    return List.generate(daysOfWeek.length, (index) {
      String day = daysOfWeek[index];
      return Step(
        title: Text(day),
        content: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Start Time:'),
                TextButton(
                  onPressed: () => _selectTime(context, day, true),
                  child: Text('${studyStartTimes[day]!.format(context)}'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('End Time:'),
                TextButton(
                  onPressed: () => _selectTime(context, day, false),
                  child: Text('${studyEndTimes[day]!.format(context)}'),
                ),
              ],
            ),
          ],
        ),
        isActive: _activeDayStep == index,
        state: _activeDayStep == index ? StepState.editing : StepState.indexed,
      );
    });
  }

  // Define the colors used in the UI (replace with your actual colors)
  final Color primaryColor = Color(0xFF4A64FE);
  final Color backgroundColor = Color(0xFFF0F2F5);
  final Color accentColor = Color(0xFF6C757D);
  final Color textColor = Color(0xFF212529);

  final List<String> stepLabels = [
    'Enter Your Name',
    'Search for Your University',
    'Select Subjects',
    'Arrange Subjects',
    'Pass or Honors',
    'Study Blocks',
  ];

  void initState() {
    super.initState();
    var daysOfWeek = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    for (var day in daysOfWeek) {
      studyStartTimes[day] = TimeOfDay(hour: 14, minute: 0);
      studyEndTimes[day] = TimeOfDay(hour: 18, minute: 0);
    }
    for (var subject in subjects) {
      objectives[subject] = 'None';
      selectedSubjects[subject] = false;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _universityController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(
      BuildContext context, String day, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? studyStartTimes[day]! : studyEndTimes[day]!,
    );

    if (picked != null) {
      setState(() {
        if (isStartTime) {
          studyStartTimes[day] = picked;
        } else {
          studyEndTimes[day] = picked;
        }
      });
    }
  }

  Widget _buildCircularStepIndicator() {
    double progressValue = (_currentStep + 1) / _totalSteps;
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: CircularProgressIndicator(
            value: progressValue,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            strokeWidth: 6,
          ),
        ),
        Text(
          'Step ${_currentStep + 1} of $_totalSteps',
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.bold, color: textColor),
        ),
      ],
    );
  }

  Widget _buildStepTitle() {
    return Column(
      children: [
        Text(
          stepLabels[_currentStep],
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
        ),
        if (_currentStep < _totalSteps - 1)
          Text('Next: ${stepLabels[_currentStep + 1]}',
              style: TextStyle(fontSize: 16, color: accentColor)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      hintColor: accentColor,
      textTheme: Theme.of(context)
          .textTheme
          .apply(bodyColor: textColor, displayColor: textColor),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
        labelStyle: TextStyle(color: accentColor),
      ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        buttonColor: primaryColor,
      ),
    );

    return MaterialApp(
      theme: theme,
      home: Scaffold(
        appBar: AppBar(
          title:
              Text('Initial Configuration', style: TextStyle(color: textColor)),
          backgroundColor: backgroundColor,
          elevation: 0,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildCircularStepIndicator(),
            ),
            _buildStepTitle(),
            Expanded(child: _buildStepContent()),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentStep > 0)
                    OutlinedButton(
                      child: Text('Back', style: TextStyle(color: textColor)),
                      onPressed: () {
                        setState(() {
                          if (_currentStep > 0) _currentStep--;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ElevatedButton(
                    child: Text(
                        _currentStep == _totalSteps - 1 ? 'Finish' : 'Next',
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      if (_currentStep < _totalSteps - 1) {
                        setState(() {
                          _currentStep++;
                        });
                      } else {
                        // Finish the configuration
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    // Style the form fields according to the design
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _getStepContent(_currentStep),
        ),
      ),
    );
  }

  Widget _getStepContent(int stepIndex) {
    switch (stepIndex) {
      case 0:
        return _buildNameStep();
      case 1:
        return _buildUniversityStep();
      case 2:
        return _buildSubjectsStep();

      case 3:
        return _buildPrioritiesStep();
      case 4:
        return _buildObjectivesStep();
      case 5:
        return _buildStudyBlockStep();
      default:
        return Center(
            child: Text(
          'Unknown step',
        )); //add style?¿
    }
  }

  Widget _buildNameStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Icon(
                Icons.emoji_emotions,
                color: primaryColor,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Hello there! What name should we use for you?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: 'Your name',
            labelStyle: TextStyle(color: accentColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            prefixIcon: Icon(Icons.person, color: accentColor),
          ),
        ),
      ],
    );
  }

  Widget _buildUniversityStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Icon(Icons.school, color: primaryColor),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Which university are you affiliated with?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        TextFormField(
          controller: _universityController,
          decoration: InputDecoration(
            labelText: 'University name',
            labelStyle: TextStyle(color: accentColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            prefixIcon: Icon(Icons.search, color: accentColor),
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Icon(Icons.book, color: primaryColor),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Do you take any of these subjects?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: subjects
                .map((subject) => CheckboxListTile(
                      title: Text(subject,
                          style: TextStyle(fontSize: 16, color: textColor)),
                      value: selectedSubjects[subject] ?? false,
                      onChanged: (bool? value) {
                        setState(() {
                          selectedSubjects[subject] = value!;
                        });
                      },
                      secondary: Icon(Icons.school, color: accentColor),
                      activeColor: primaryColor,
                      checkColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ))
                .toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Add a subject if you don\'t find yours',
            style: TextStyle(fontSize: 16, color: textColor),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ElevatedButton.icon(
            icon: Icon(Icons.add, color: Colors.white),
            label: Text('Add Subject', style: TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddNewSubject()),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrioritiesStep() {
    // Filtrar y crear una lista de las materias seleccionadas
    List<String> selectedSubjectList = subjects
        .where((subject) => selectedSubjects[subject] ?? false)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Icon(Icons.sort, color: primaryColor),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Sort your subjects by importance for you',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ReorderableListView(
            onReorder: (int oldIndex, int newIndex) {
              if (newIndex > oldIndex) {
                newIndex -= 1;
              }
              setState(() {
                final String item = selectedSubjectList.removeAt(oldIndex);
                selectedSubjectList.insert(newIndex, item);
              });
            },
            children: selectedSubjectList
                .asMap()
                .map((index, subject) => MapEntry(
                      index,
                      ListTile(
                        key: ValueKey('$subject-$index'),
                        title: Text(subject,
                            style: TextStyle(fontSize: 16, color: textColor)),
                        leading: Icon(Icons.drag_handle, color: accentColor),
                      ),
                    ))
                .values
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildObjectiveOptions(String subject) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <String>['Pass', 'Honors', 'None'].map((String value) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(
                horizontal: 8), // Añade espacio entre las opciones
            child: ChoiceChip(
              label: Text(value),
              selected: objectives[subject] == value,
              onSelected: (bool selected) {
                setState(() {
                  if (selected) {
                    objectives[subject] = value;
                  }
                });
              },
              selectedColor: primaryColor,
              labelStyle: TextStyle(
                color: objectives[subject] == value ? Colors.white : textColor,
                fontWeight: FontWeight.bold,
              ),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                    color:
                        textColor), // Agrega un borde para una mejor visibilidad
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildObjectivesStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Set your goal for each subject',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: subjects.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(subjects[index],
                    style: TextStyle(fontSize: 16, color: textColor)),
                subtitle: _buildObjectiveOptions(subjects[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStudyBlockStep() {
  return Theme(
    data: ThemeData(
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        // Añade más personalización si es necesario
      ),
      textTheme: TextTheme(
        // Personaliza el tema de texto si es necesario
      ),
    ),
    child: Stepper(
      type: StepperType.vertical, 
      steps: _buildStudySteps(),
      currentStep: _activeDayStep,
      onStepTapped: (step) => setState(() => _activeDayStep = step),
       onStepContinue: () {
        if (_activeDayStep < 6) {
          setState(() => _activeDayStep += 1);
        }
      },
      onStepCancel: () {
        if (_activeDayStep > 0) {
          setState(() => _activeDayStep -= 1);
        }
      },
      controlsBuilder: (BuildContext context, ControlsDetails details) {
        return Row(
          children: <Widget>[
            TextButton(
              onPressed: details.onStepContinue,
              child: const Text('Next'),
            ),
            TextButton(
              onPressed: details.onStepCancel,
              child: const Text('Back'),
            ),
          ],
        );
      },
    ),
  );
}

}
