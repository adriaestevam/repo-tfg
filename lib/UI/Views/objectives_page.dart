import 'package:flutter/material.dart';
import 'package:tfg_v1/Presentation/lib/pages/home_page.dart';
import 'package:tfg_v1/Presentation/lib/pages/notification_page.dart';
import 'package:tfg_v1/Presentation/lib/pages/subjects_page.dart';
import 'package:tfg_v1/Presentation/lib/utilities/app_colors.dart';
import 'package:tfg_v1/Presentation/lib/widgets/bottom_navigation_widget.dart';

class ObjectivesPage extends StatelessWidget {
  const ObjectivesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Objectives'),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSectionTitle('Objectives'),
            _buildObjectivesList(),
            const SizedBox(height: 16),
            _buildSectionTitle('Priorities'),
            _buildPrioritiesList(),
            const SizedBox(height: 16),
            _buildSectionTitle('This Week Priorities'),
            _buildWeekPrioritiesList(),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        onTabTapped: (index) {
          switch(index){
            case 0:
              Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
              break;
            case 1:
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ObjectivesPage()));
              break;
            case 2:
              Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationPage()));
              break;
            case 3:
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SubjectPage()));
              break;
            default:
              break; 
          }
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: AppColors.text,
        ),
      ),
    );
  }

  Widget _buildObjectivesList() {
    List<String> objectives = [
      'Pass all subjects',
      'Honors in Mathematics',
      'Honors in Chemistry',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: objectives.map((objective) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              const Icon(Icons.drag_indicator, color: AppColors.secondary), // Sort icon
              const SizedBox(width: 8.0),
              Text(
                objective,
                style: const TextStyle(color: AppColors.text),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPrioritiesList() {
    List<String> priorities = [
      'Mathematics',
      'Chemistry',
      'Physics',
      'Biology',
      'History',
      'Geography',
      'Literature',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Priorities',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle sorting logic
              },
              child: const Text('Sort'),
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        ...priorities.map((priority) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                const Icon(Icons.drag_indicator, color: AppColors.secondary), // Sort icon
                const SizedBox(width: 8.0),
                Container(
                  width: 12.0,
                  height: 12.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _getSubjectColor(priority), // Get color based on subject
                  ),
                ),
                const SizedBox(width: 8.0),
                Text(
                  priority,
                  style: const TextStyle(color: AppColors.text),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildWeekPrioritiesList() {
    List<String> weekPriorities = [
      'First exam of Mathematics',
      'Assignment of Biology',
      'Chemistry test',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'This Week Priorities',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle sorting logic
              },
              child: const Text('Sort'),
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        ...weekPriorities.map((priority) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                const Icon(Icons.drag_indicator, color: AppColors.secondary), // Sort icon
                const SizedBox(width: 8.0),
                Container(
                  width: 12.0,
                  height: 12.0,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.accent, // Color for this week priorities
                  ),
                ),
                const SizedBox(width: 8.0),
                Text(
                  priority,
                  style: const TextStyle(color: AppColors.text),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Color _getSubjectColor(String subject) {
    // Define colors for each subject
    switch (subject) {
      case 'Mathematics':
        return Colors.blue;
      case 'Chemistry':
        return Colors.green;
      case 'Physics':
        return Colors.orange;
      case 'Biology':
        return Colors.red;
      case 'History':
        return Colors.purple;
      case 'Geography':
        return Colors.teal;
      case 'Literature':
        return Colors.indigo;
      default:
        return Colors.grey; 
    }
  }
}
