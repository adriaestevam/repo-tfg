import 'package:flutter/material.dart';
import 'package:login_signup_v2/pages/home_page.dart';
import 'package:login_signup_v2/pages/notification_page.dart';
import 'package:login_signup_v2/pages/objectives_page.dart';
import 'package:tfg_v1/Presentation/lib/utilities/app_colors.dart';
import 'package:login_signup_v2/widgets/bottom_navigation_widget.dart';

class SubjectPage extends StatelessWidget {
  const SubjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subjects'),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: 8,
          itemBuilder: (context, index) {
            return SubjectCard(index + 1); // Subject cards with index starting from 1
          },
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
}

class SubjectCard extends StatelessWidget {
  final int subjectNumber;

  const SubjectCard(this.subjectNumber, {super.key});

  @override
  Widget build(BuildContext context) {
    Color cardColor = _generateRandomColor(); // Generate random color for each card

    return GestureDetector(
      onTap: () {
        // Handle onTap for the card
        // You can navigate to a detailed subject page or perform any other action
      },
      child: Card(
        color: cardColor,
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 8,
              right: 8,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Subject $subjectNumber',
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _generateRandomColor() {
    // Generate random color using app color palette
    List<Color> colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.accent,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.indigo,
    ];
    return colors[subjectNumber % colors.length]; // Get color based on subject number
  }
}
