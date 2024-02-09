import 'package:flutter/material.dart';
import 'package:login_signup_v2/utilities/app_colors.dart';
import 'package:login_signup_v2/pages/initial_configuration/choose_objectives.dart';

class ChoosePrioritiesPage extends StatefulWidget {
  final List<String> subjects;
  
  const ChoosePrioritiesPage({super.key, required this.subjects});

  @override
  _ChoosePrioritiesPageState createState() => _ChoosePrioritiesPageState();
}

class _ChoosePrioritiesPageState extends State<ChoosePrioritiesPage> {
  late List<String> selectedPriorities;

  @override
  void initState() {
    super.initState();
    selectedPriorities = List.from(widget.subjects);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Priorities'),
        backgroundColor: AppColors.primary,
      ),
      body: Container(
        color: AppColors.accent,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20.0),
            const Text(
              'Choose Your Priorities',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 10.0),
            const Text(
              'Order the subjects according to importance to you',
              style: TextStyle(
                fontSize: 16.0,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: ReorderableListView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                children: List.generate(
                  selectedPriorities.length,
                  (index) => Container(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    key: Key('$index'),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      border: Border.all(
                        color: AppColors.primary,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ListTile(
                      title: Text(
                        selectedPriorities[index],
                        style: const TextStyle(
                          color: AppColors.text,
                        ),
                      ),
                    ),
                  ),
                ),
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    final item = selectedPriorities.removeAt(oldIndex);
                    selectedPriorities.insert(newIndex, item);
                  });
                },
              ),
            ),
            const SizedBox(height: 20.0),
ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChooseObjectivePage(subjects: selectedPriorities),
                  ),
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
    );
  }
}
