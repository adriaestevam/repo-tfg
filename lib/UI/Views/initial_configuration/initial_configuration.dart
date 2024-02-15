import 'package:flutter/material.dart';
import 'package:tfg_v1/Presentation/lib/utilities/app_colors.dart';

class InitialConfigurationStepper extends StatefulWidget {
  const InitialConfigurationStepper({super.key});

  @override
  _InitialConfigurationStepperState createState() =>
      _InitialConfigurationStepperState();
}

class _InitialConfigurationStepperState
    extends State<InitialConfigurationStepper> {
  int _currentStep = 0;
  late List<Step> _steps;

  List<String> universities = [
    'Harvard University',
    'Stanford University',
    'Massachusetts Institute of Technology',
    'University of Cambridge',
    'University of Oxford',
    'California Institute of Technology',
    'University of Chicago',
    'Princeton University',
    'Yale University',
    'Columbia University',
    'University of California, Berkeley',
    'University of Pennsylvania',
    'University of Michigan',
    'Johns Hopkins University',
    'Northwestern University',
    'University of California, Los Angeles',
    'University of Tokyo',
    'Kyoto University',
    'University of Toronto',
    'University of Hong Kong',
  ];

  List<String> filteredUniversities = [];
  late TextEditingController _searchController;
  List<String> selectedSubjects = [];
  List<String> selectedPriorities = [];
  List<String> selectedObjectives = [];

  @override
  void initState() {
    super.initState();
    filteredUniversities.addAll(universities);
    _searchController = TextEditingController();
    _steps = [
      Step(
        title: const Text('Choose University'),
        content: _buildUniversityList(),
        isActive: true,
      ),
      Step(
        title: const Text('Choose Subjects'),
        content: _buildSubjectList(),
        isActive: false,
      ),
      Step(
        title: const Text('Choose Priorities'),
        content: _buildPriorityList(),
        isActive: false,
      ),
      Step(
        title: const Text('Choose Objectives'),
        content: _buildObjectiveList(),
        isActive: false,
      ),
    ];
  }

  void filterUniversities(String query) {
    setState(() {
      filteredUniversities.clear();
      if (query.isNotEmpty) {
        for (var university in universities) {
          if (university.toLowerCase().contains(query.toLowerCase())) {
            filteredUniversities.add(university);
          }
        }
      } else {
        filteredUniversities.addAll(universities);
      }
    });
  }

  void selectSubject(String subject) {
    setState(() {
      selectedSubjects.add(subject);
    });
  }

  void selectPriority(String priority) {
    setState(() {
      selectedPriorities.add(priority);
    });
  }

  void selectObjective(String objective) {
    setState(() {
      selectedObjectives.add(objective);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Initial Configuration'),
        backgroundColor: AppColors.primary,
      ),
      body: Stepper(
        steps: _steps,
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < _steps.length - 1) {
            setState(() {
              _currentStep++;
            });
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() {
              _currentStep--;
            });
          }
        },
        onStepTapped: (step) {
          setState(() {
            _currentStep = step;
          });
        },
      ),
    );
  }

  Widget _buildUniversityList() {
    return Column(
      children: [
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search university',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: filterUniversities,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredUniversities.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(filteredUniversities[index]),
                onTap: () {
                  // Handle the selection of a university
                  print('Selected university: ${filteredUniversities[index]}');
                  // You can add your logic here to handle the selected university
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectList() {
    return ListView.builder(
      itemCount: universities.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(universities[index]),
          onTap: () {
            selectSubject(universities[index]);
          },
        );
      },
    );
  }

  Widget _buildPriorityList() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Priority ${index + 1}'),
          onTap: () {
            selectPriority('Priority ${index + 1}');
          },
        );
      },
    );
  }

  Widget _buildObjectiveList() {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Objective ${index + 1}'),
          onTap: () {
            selectObjective('Objective ${index + 1}');
          },
        );
      },
    );
  }
}
