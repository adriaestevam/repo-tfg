import 'package:flutter/material.dart';

class BottomNavBarState extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void setIndex(int index) {
    _selectedIndex = index;
    notifyListeners(); // Notify listeners when the index changes
  }
}
