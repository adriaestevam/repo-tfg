import 'package:flutter/material.dart';

import '../../../Data/Models/subject.dart';

class FormulaElement {
  String name;
  double weight;

  FormulaElement({required this.name, this.weight = 0.0});
}

class AddNewSubjectScreen extends StatefulWidget {
  @override
  _AddNewSubjectScreenState createState() => _AddNewSubjectScreenState();

  
}

class _AddNewSubjectScreenState extends State<AddNewSubjectScreen> {
  final _formKey = GlobalKey<FormState>();
  String _courseName = '';
  int _credits = 0;
  List<FormulaElement> formulaElements = [];

  void _addElement() {
    setState(() {
      formulaElements.add(FormulaElement(name: ''));
    });
  }

  void _removeElement(int index) {
    setState(() {
      formulaElements.removeAt(index);
    });
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate() && _isTotalWeightValid) {
      _formKey.currentState!.save();

      // Create a formula string from formula elements
      String formula = formulaElements.map((e) => '${e.name}: ${e.weight}%').join(', ');

      // Create a new Subject instance
      Subject newSubject = Subject(
        id: UniqueKey().toString(), // Generates a unique ID for the subject
        name: _courseName,
        credits: _credits,
        formula: formula,
      );

      // Return the new Subject instance to the previous screen
      Navigator.pop(context, newSubject);
    } else {
      // Show an error message or handle the error
    }
  }


  double get _totalWeight =>
      formulaElements.fold(0, (prev, element) => prev + element.weight);

  bool get _isTotalWeightValid => _totalWeight == 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Course'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Course Name'),
                  onSaved: (value) => _courseName = value!,
                  validator: (value) => value == null || value.isEmpty ? 'Please enter course name' : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Number of Credits'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => _credits = int.parse(value!),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter number of credits' : null,
                ),
                SizedBox(height: 16),
                ...formulaElements.map((element) => _buildFormulaElementField(element)).toList(),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _addElement,
                  child: Text('Add Element'),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        _totalWeight == 100 ? Icons.check_circle_outline : Icons.warning_amber_outlined,
                        color: _totalWeight == 100 ? Colors.green : Colors.red,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Total Weight: ${_totalWeight.toStringAsFixed(2)}%',
                        style: TextStyle(
                          color: _totalWeight == 100 ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_totalWeight > 100) 
                        Text(' - Exceeds 100%', style: TextStyle(color: Colors.red)),
                      if (_totalWeight < 100) 
                        Text(' - Less than 100%', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() && _isTotalWeightValid) {
                      _formKey.currentState!.save();
                      _handleSubmit();
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormulaElementField(FormulaElement element) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              initialValue: element.name,
              onChanged: (value) => element.name = value,
              decoration: InputDecoration(labelText: 'Element Name'),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: TextFormField(
              initialValue: element.weight.toStringAsFixed(2),
              onChanged: (value) => element.weight = double.tryParse(value) ?? 0.0,
              decoration: InputDecoration(labelText: 'Weight (%)'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _removeElement(formulaElements.indexOf(element)),
          ),
        ],
      ),
    );
  }
}

