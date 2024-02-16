import 'package:flutter/cupertino.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:tfg_v1/UI/Utilities/app_colors.dart';
import 'package:tfg_v1/UI/Utilities/bottom_nav_bar_state.dart'; 

class CustomBottomNav extends StatelessWidget {
  final Function(int) onTabTapped; // Callback function for navigation

  const CustomBottomNav({super.key, required this.onTabTapped}); // Constructor

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavBarState>(
      builder: (context, bottomNavBarState, child) {
        return GNav(
          gap: 9,
          tabs: [
            GButton(
              icon: CupertinoIcons.home,
              text: 'Home',
              iconColor: AppColors.text,
              iconActiveColor: AppColors.primary,
              textStyle: const TextStyle(color: AppColors.text),
              onPressed: () => onTabTapped(0), // Navigate to Home page
              leading: bottomNavBarState.selectedIndex == 0
                  ? const Icon(CupertinoIcons.home, color: AppColors.primary)
                  : null,
            ),
            GButton(
              icon: CupertinoIcons.check_mark_circled_solid,
              text: 'Objectives',
              iconColor: AppColors.text,
              iconActiveColor: AppColors.primary,
              textStyle: const TextStyle(color: AppColors.text),
              onPressed: () => onTabTapped(1), // Navigate to Objectives page
              leading: bottomNavBarState.selectedIndex == 1
                  ? const Icon(CupertinoIcons.check_mark_circled_solid, color: AppColors.primary)
                  : null,
            ),
            GButton(
              icon: CupertinoIcons.bell,
              text: 'Notifications',
              iconColor: AppColors.text,
              iconActiveColor: AppColors.primary,
              textStyle: const TextStyle(color: AppColors.text),
              onPressed: () => onTabTapped(2), // Navigate to Notifications page
              leading: bottomNavBarState.selectedIndex == 2
                  ? const Icon(CupertinoIcons.bell, color: AppColors.primary)
                  : null,
            ),
            GButton(
              icon: CupertinoIcons.book,
              text: 'Subjects',
              iconColor: AppColors.text,
              iconActiveColor: AppColors.primary,
              textStyle: const TextStyle(color: AppColors.text),
              onPressed: () => onTabTapped(3), // Navigate to Subjects page
              leading: bottomNavBarState.selectedIndex == 3
                  ? const Icon(CupertinoIcons.book, color: AppColors.primary)
                  : null,
            ),
          ],
          // Update the active index in the state management solution (Provider)
          selectedIndex: bottomNavBarState.selectedIndex,
          onTabChange: (index) {
            Provider.of<BottomNavBarState>(context, listen: false).setIndex(index);
          },
        );
      },
    );
  }
}
