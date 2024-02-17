import 'package:flutter/material.dart';

class InitialConfigurationScreen extends StatefulWidget {
  @override
  _InitialConfigurationScreenState createState() => _InitialConfigurationScreenState();
}

class _InitialConfigurationScreenState extends State<InitialConfigurationScreen> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Initial Configuration'),
      ),
      body: Stepper(
        type: StepperType.vertical,
        currentStep: _currentStep,
        onStepContinue: () {
          setState(() {
            if (_currentStep < 5) {
              _currentStep += 1;
            }
          });
        },
        onStepCancel: () {
          setState(() {
            if (_currentStep > 0) {
              _currentStep -= 1;
            }
          });
        },
        steps: [
          Step(
            title: Text('Step 1'),
            content: Column(
              children: [
                Text('Step 1 content'),
                // Add your step 1 content here
              ],
            ),
            isActive: _currentStep >= 0,
          ),
          Step(
            title: Text('Step 2'),
            content: Column(
              children: [
                Text('Step 2 content'),
                // Add your step 2 content here
              ],
            ),
            isActive: _currentStep >= 1,
          ),
          Step(
            title: Text('Step 3'),
            content: Column(
              children: [
                Text('Step 3 content'),
                // Add your step 3 content here
              ],
            ),
            isActive: _currentStep >= 2,
          ),
          Step(
            title: Text('Step 4'),
            content: Column(
              children: [
                Text('Step 4 content'),
                // Add your step 4 content here
              ],
            ),
            isActive: _currentStep >= 3,
          ),
          Step(
            title: Text('Step 5'),
            content: Column(
              children: [
                Text('Step 5 content'),
                // Add your step 5 content here
              ],
            ),
            isActive: _currentStep >= 4,
          ),
          Step(
            title: Text('Step 6'),
            content: Column(
              children: [
                Text('Step 6 content'),
                // Add your step 6 content here
              ],
            ),
            isActive: _currentStep >= 5,
          ),
        ],
      ),
    );
  }
}

