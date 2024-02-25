import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tfg_v1/Data/Models/subject.dart';
import 'package:tfg_v1/Domain/Initial%20Configuration%20Bloc/initial_config_event.dart';
import 'package:tfg_v1/Domain/Initial%20Configuration%20Bloc/initial_config_state.dart';
import 'package:tfg_v1/Domain/NavigatorBloc/navigator_bloc.dart';
import 'package:tfg_v1/Domain/NavigatorBloc/navigator_event.dart';
import 'package:tfg_v1/UI/Views/Initial%20Configuration/addNewSubject.dart';

import '../../../Domain/Initial Configuration Bloc/initial_config_bloc.dart';

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
  List<Subject> subjects = [
  Subject(
    id: '1',
    name: 'Math',
    credits: 4,
    formula: 'Math Formula',
  ),
  Subject(
    id: '2',
    name: 'Physics',
    credits: 3,
    formula: 'Physics Formula',
  ),
  Subject(
    id: '3',
    name: 'Chemistry',
    credits: 4,
    formula: 'Chemistry Formula',
  ),
];
// Example subjects
  Map<Subject, bool> selectedSubjects = {};
  Map<Subject, String> objectives = {}; // Almacena 'Pass', 'Honors' o 'None'
  Map<String, TimeOfDay> studyStartTimes = {};
  Map<String, TimeOfDay> studyEndTimes = {};
  int _activeDayStep = 0; // Para manejar el día activo en el Stepper

  List<Step> _buildStudySteps() {
    ThemeData theme = Theme.of(context); // Obtenemos el tema actual
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
        title: Text(
          day,
          style: theme
              .textTheme.subtitle1, // Estilo de texto para el título del paso
        ),
        content: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Start Time:',
                  style: theme
                      .textTheme.bodyText1, // Estilo de texto para el cuerpo
                ),
                TextButton(
                  onPressed: () => _selectTime(context, day, true),
                  child: Text(
                    '${studyStartTimes[day]!.format(context)}',
                    style:
                        theme.textTheme.button, // Estilo de texto para botones
                  ),
                  style: TextButton.styleFrom(
                    primary: theme
                        .colorScheme.onSurface, // Color del texto del botón
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'End Time:',
                  style: theme
                      .textTheme.bodyText1, // Estilo de texto para el cuerpo
                ),
                TextButton(
                  onPressed: () => _selectTime(context, day, false),
                  child: Text(
                    '${studyEndTimes[day]!.format(context)}',
                    style:
                        theme.textTheme.button, // Estilo de texto para botones
                  ),
                  style: TextButton.styleFrom(
                    primary: theme
                        .colorScheme.onSurface, // Color del texto del botón
                  ),
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

  Widget _buildCircularStepIndicator(BuildContext context) {
    ThemeData theme = Theme.of(context); // Obtenemos el tema actual
    double progressValue = (_currentStep + 1) / _totalSteps;

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: CircularProgressIndicator(
            value: progressValue,
            backgroundColor: theme.colorScheme
                .background, // Usamos el color de fondo del tema para la barra de progreso
            valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary), // Color primario para el progreso
            strokeWidth: 6,
          ),
        ),
        Text(
          'Step ${_currentStep + 1} of $_totalSteps',
          style: theme.textTheme.bodyText2?.copyWith(
            // Asegúrate de que bodyText2 está definido en tu AppTheme
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme
                .onBackground, // Color de texto sobre fondo, para mejor contraste
          ),
        ),
      ],
    );
  }

  Widget _buildStepTitle(BuildContext context) {
    ThemeData theme = Theme.of(context); // Obtenemos el tema actual

    return Column(
      children: [
        Text(
          stepLabels[_currentStep],
          style: theme.textTheme.headline6?.copyWith(
            fontWeight: FontWeight.bold,
            // El color ya está definido en el estilo del tema, por lo que no es necesario especificarlo aquí
          ),
        ),
        if (_currentStep < _totalSteps - 1)
          Text(
            'Next: ${stepLabels[_currentStep + 1]}',
            style: theme.textTheme.subtitle1?.copyWith(
              color: theme.colorScheme
                  .secondary, // Utiliza el color secundario del esquema de colores del tema
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context); // Usamos el tema global
    final InitialConfigBloc initialConfigBloc = BlocProvider.of<InitialConfigBloc>(context);
    final NavigatorBloc navigatorBloc = BlocProvider.of<NavigatorBloc>(context);

    return BlocBuilder<InitialConfigBloc, InitialConfigState>(
      builder: (context, state) {
        return MaterialApp(
          theme: theme, // Aplicamos el tema a MaterialApp
          home: Scaffold(
            appBar: AppBar(
              title: Text('Initial Configuration',
                  style: theme.textTheme
                      .headline6), // Usamos el estilo de texto del tema para el título
              backgroundColor: theme.appBarTheme
                  .backgroundColor, // Color de fondo del AppBar del tema
              elevation: 0,
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildCircularStepIndicator(
                      context), // Asegúrate de que este método use también el tema
                ),
                _buildStepTitle(
                    context), // Asegúrate de que este método use también el tema
                Expanded(
                    child: _buildStepContent(
                        context)), // Asegúrate de que este método use también el tema
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentStep > 0)
                        OutlinedButton(
                          child: Text('Back', style: theme.textTheme.button),
                          onPressed: () {
                            setState(() {
                              if (_currentStep > 0) _currentStep--;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: theme.colorScheme.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ElevatedButton(
                        child: Text(
                            _currentStep == _totalSteps - 1 ? 'Finish' : 'Next',
                            style: theme.textTheme.button
                                ?.copyWith(color: Colors.white)),
                        onPressed: () {
                          if (_currentStep < _totalSteps - 1) {
                            setState(() {
                              _currentStep++;
                            });
                          } else {
                            initialConfigBloc.add(EndOfInitialConfiguration(
                              user_name: _nameController.text,
                              university: _universityController.text,
                              selectedSubjects: selectedSubjects,
                              objectives: objectives,
                              studyStartTimes: studyStartTimes,
                              studyEndTimes:  studyEndTimes
                            ));
                            navigatorBloc.add(GoToHomeEvent());
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: theme.colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStepContent(BuildContext context) {
    ThemeData theme = Theme.of(context); // Obtenemos el tema actual

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        color: theme.cardColor, // Usa el color de tarjeta definido en el tema
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _getStepContent(
              _currentStep), // Asegúrate de que este método también use el tema
        ),
      ),
    );
  }

  Widget _getStepContent(int stepIndex) {
    switch (stepIndex) {
      case 0:
        return _buildNameStep(context);
      case 1:
        return _buildUniversityStep(context);
      case 2:
        return _buildSubjectsStep(context);

      case 3:
        return _buildPrioritiesStep(context);
      case 4:
        return _buildObjectivesStep(context);
      case 5:
        return _buildStudyBlockStep(context);
      default:
        return Center(
            child: Text(
          'Unknown step',
        ));
    }
  }

  Widget _buildNameStep(BuildContext context) {
    ThemeData theme = Theme.of(context); // Obtenemos el tema actual

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Icon(
                Icons.emoji_emotions,
                color:
                    theme.colorScheme.primary, // Usa el color primario del tema
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Hello there! What name should we use for you?',
                  style: theme.textTheme.subtitle1?.copyWith(
                    fontWeight: FontWeight.bold,
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
            labelStyle: theme.textTheme.caption?.copyWith(
                color: theme
                    .colorScheme.secondary), // Usa el estilo de texto del tema
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            prefixIcon: Icon(Icons.person,
                color: theme
                    .colorScheme.secondary), // Usa el color secundario del tema
          ),
        ),
      ],
    );
  }

  Widget _buildUniversityStep(BuildContext context) {
    ThemeData theme = Theme.of(context); // Obtenemos el tema actual

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Icon(
                Icons.school,
                color:
                    theme.colorScheme.primary, // Usa el color primario del tema
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Which university are you affiliated with?',
                  style: theme.textTheme.subtitle1?.copyWith(
                    fontWeight: FontWeight.bold,
                    // El color ya está definido en el estilo del tema
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
            labelStyle: theme.textTheme.caption?.copyWith(
                color: theme
                    .colorScheme.secondary), // Usa el estilo de texto del tema
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            prefixIcon: Icon(
              Icons.search,
              color: theme
                  .colorScheme.secondary, // Usa el color secundario del tema
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectsStep(BuildContext context) {
    ThemeData theme = Theme.of(context); // Obtenemos el tema actual

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Icon(
                Icons.book,
                color:
                    theme.colorScheme.primary, // Usa el color primario del tema
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Do you take any of these subjects?',
                  style: theme.textTheme.subtitle1?.copyWith(
                    fontWeight: FontWeight.bold,
                    // El color ya está definido en el estilo del tema
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
                      title: Text(subject.name, style: theme.textTheme.bodyText1),
                      value: selectedSubjects[subject] ?? false,
                      onChanged: (bool? value) {
                        setState(() {
                          selectedSubjects[subject] = value!;
                        });
                      },
                      secondary: Icon(Icons.school,
                          color: theme.colorScheme.secondary),
                      activeColor: theme.colorScheme.primary,
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
            style: theme.textTheme.bodyText1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ElevatedButton.icon(
            icon: Icon(Icons.add, color: Colors.white),
            label: Text('Add Subject', style: TextStyle(color: Colors.white)),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddNewSubjectScreen()),
              );

              if (result is Subject){
                setState(() {
                  subjects.add(result as Subject);
                });
              }
            },
            style: ElevatedButton.styleFrom(
              primary: theme.colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrioritiesStep(BuildContext context) {
    ThemeData theme = Theme.of(context); // Obtenemos el tema actual

    // Filtrar y crear una lista de las materias seleccionadas
    List<Subject> selectedSubjectList = subjects
        .where((subject) => selectedSubjects[subject] ?? false)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Icon(
                Icons.sort,
                color:
                    theme.colorScheme.primary, // Usa el color primario del tema
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Sort your subjects by importance for you',
                  style: theme.textTheme.subtitle1?.copyWith(
                    fontWeight: FontWeight.bold,
                    // El color ya está definido en el estilo del tema
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
                final Subject item = selectedSubjectList.removeAt(oldIndex);
                selectedSubjectList.insert(newIndex, item);
              });
            },
            children: selectedSubjectList
                .asMap()
                .map((index, subject) => MapEntry(
                      index,
                      ListTile(
                        key: ValueKey('$subject-$index'),
                        title: Text(
                          subject.name,
                          style: theme.textTheme
                              .bodyText1, // Usa el estilo de texto del tema
                        ),
                        leading: Icon(
                          Icons.drag_handle,
                          color: theme.colorScheme
                              .secondary, // Usa el color secundario del tema
                        ),
                      ),
                    ))
                .values
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildObjectiveOptions(Subject subject, BuildContext context) {
    ThemeData theme = Theme.of(context); // Obtenemos el tema actual

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <String>['Pass', 'Honors', 'None'].map((String value) {
        bool isSelected = objectives[subject] == value;
        return Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(
                horizontal: 8), // Añade espacio entre las opciones
            child: ChoiceChip(
              label: Text(value),
              selected: isSelected,
              onSelected: (bool selected) {
                setState(() {
                  if (selected) {
                    objectives[subject] = value;
                  }
                });
              },
              selectedColor:
                  theme.colorScheme.primary, // Usa el color primario del tema
              labelStyle: theme.textTheme.button?.copyWith(
                color: isSelected
                    ? Colors.white
                    : theme.colorScheme
                        .onSurface, // Ajusta el color del texto según el estado del chip
                fontWeight: FontWeight.bold,
              ),
              backgroundColor: theme.colorScheme
                  .surface, // Usa el color de superficie del tema para el fondo
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme
                            .onSurface), // Borde con el color del tema
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildObjectivesStep(BuildContext context) {
    ThemeData theme = Theme.of(context); // Obtenemos el tema actual

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Set your goal for each subject',
            style: theme.textTheme.subtitle1?.copyWith(
              fontWeight: FontWeight.bold,
              // El color ya está definido en el estilo del tema
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: subjects.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  subjects[index].name,
                  style: theme
                      .textTheme.bodyText1, // Usa el estilo de texto del tema
                ),
                subtitle: _buildObjectiveOptions(subjects[index], context),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStudyBlockStep(BuildContext context) {
    ThemeData theme = Theme.of(context); // Obtenemos el tema actual

    return Stepper(
      type: StepperType.vertical,
      steps:
          _buildStudySteps(), // Asegúrate de que este método también use el tema
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
              child: Text('Next', style: theme.textTheme.button),
            ),
            TextButton(
              onPressed: details.onStepCancel,
              child: Text('Back', style: theme.textTheme.button),
            ),
          ],
        );
      },
    );
  }
}
