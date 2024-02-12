import 'package:flutter/material.dart';
import 'package:tfg_v1/Presentation/lib/pages/initial_configuration/choose_priorities.dart';
import 'package:tfg_v1/Presentation/lib/utilities/app_colors.dart';

class ChooseSubjectsPage extends StatefulWidget {
  final String university;
  
  const ChooseSubjectsPage({super.key, required this.university});

  @override
  _ChooseSubjectsPageState createState() => _ChooseSubjectsPageState();
}

class _ChooseSubjectsPageState extends State<ChooseSubjectsPage> {
  List<String> subjects = [
    'Mathematics',
    'Physics',
    'Biology',
    'Chemistry',
    'Computer Science',
    'Literature',
    'History',
    'Art',
    'Economics',
    'Psychology',
  ];

  List<String> chosenSubjects = [];

  List<String> filteredSubjects = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredSubjects.addAll(subjects);
  }

  void filterSubjects(String query) {
    filteredSubjects.clear();
    if (query.isNotEmpty) {
      for (var subject in subjects) {
        if (subject.toLowerCase().contains(query.toLowerCase())) {
          filteredSubjects.add(subject);
        }
      }
    } else {
      filteredSubjects.addAll(subjects);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Subjects'),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          color: AppColors.accent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'University: ${widget.university}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24.0,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Select the subjects',
                style: TextStyle(
                  fontSize: 16.0,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search subjects',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: filterSubjects,
              ),
              const SizedBox(height: 20.0),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredSubjects.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(
                      filteredSubjects[index],
                      style: const TextStyle(
                        color: AppColors.text,
                      ),
                    ),
                    value: chosenSubjects.contains(filteredSubjects[index]),
                    onChanged: (value) {
                      setState(() {
                        if (value!) {
                          chosenSubjects.add(filteredSubjects[index]);
                        } else {
                          chosenSubjects.remove(filteredSubjects[index]);
                        }
                      });
                    },
                    activeColor: AppColors.primary,
                  );
                },
              ),
              const SizedBox(height: 20.0),
ElevatedButton(
                onPressed: () {
                  // Handle selection logic for the button
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChoosePrioritiesPage(subjects: chosenSubjects,)),
                    );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 0),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Done',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
