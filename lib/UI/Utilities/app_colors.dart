import 'dart:math';

import 'package:flutter/material.dart';

 Color _generateRandomColor() {
  // Generate random color using app color palette
  List<Color> colors = [
    Color.fromARGB(255, 68, 157, 122), // Green
    Color.fromARGB(255, 51, 153, 153), // Turquoise
    Color.fromARGB(255, 0, 128, 128), // Teal
    Color.fromARGB(255, 0, 102, 204), // Blue
    Color.fromARGB(255, 51, 153, 204), // Sky Blue
    Color.fromARGB(255, 153, 204, 255), // Light Blue
    Color.fromARGB(255, 153, 153, 153), // Gray
    Color.fromARGB(255, 102, 102, 102), // Dark Gray
    Color.fromARGB(255, 204, 204, 204), // Light Gray
  ];
  return colors[Random().nextInt(9)]; // Get color based on subject number
}
