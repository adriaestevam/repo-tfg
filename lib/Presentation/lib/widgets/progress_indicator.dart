import 'package:flutter/material.dart';

class ProgressIndicator extends StatelessWidget {
  final int currentStep;

  const ProgressIndicator({Key? key, required this.currentStep}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildCircle(1, currentStep >= 1),
          _buildLine(currentStep >= 2),
          _buildCircle(2, currentStep >= 2),
          _buildLine(currentStep >= 3),
          _buildCircle(3, currentStep >= 3),
          _buildLine(currentStep >= 4),
          _buildCircle(4, currentStep >= 4),
        ],
      ),
    );
  }

  Widget _buildCircle(int step, bool isActive) {
    return Container(
      width: 30.0,
      height: 30.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.blue : Colors.grey,
      ),
      child: Center(
        child: Text(
          '$step',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildLine(bool isActive) {
    return Expanded(
      child: Container(
        height: 2.0,
        color: isActive ? Colors.blue : Colors.grey,
      ),
    );
  }
}
