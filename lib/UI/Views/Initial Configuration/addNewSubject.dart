import 'package:flutter/material.dart';

class AddNewSubject extends StatefulWidget {
  @override
  _AddNewSubjectState createState() => _AddNewSubjectState();
}

class _AddNewSubjectState extends State<AddNewSubject> {
  final _subjectNameController = TextEditingController();

  @override
  void dispose() {
    _subjectNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Subject'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter the name of the new subject',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _subjectNameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Subject Name',
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Aquí puedes añadir la lógica para guardar la nueva asignatura
                  String newSubject = _subjectNameController.text;
                  print("New Subject Added: $newSubject"); // Para propósitos de demostración
                  Navigator.pop(context); // Volver a la página anterior
                },
                child: Text('Save Subject'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
