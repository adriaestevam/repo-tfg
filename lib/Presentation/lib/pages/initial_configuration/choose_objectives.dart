import 'package:flutter/material.dart';
import 'package:tfg_v1/Presentation/lib/pages/home_page.dart';
import 'package:tfg_v1/Presentation/lib/utilities/app_colors.dart';


class ChooseObjectivePage extends StatefulWidget {
  final List<String> subjects;
  
  const ChooseObjectivePage({Key? key, required this.subjects}) : super(key: key);

  @override
  _ChooseObjectivePageState createState() => _ChooseObjectivePageState();
}

class _ChooseObjectivePageState extends State<ChooseObjectivePage> {
  late List<bool> passSelections;
  late List<bool> honorSelections;

  @override
  void initState() {
    super.initState();
    passSelections = List.generate(widget.subjects.length, (index) => false);
    honorSelections = List.generate(widget.subjects.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Objective'),
        backgroundColor: AppColors.primary,
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        color: AppColors.accent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'I want to pass:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 10.0),
            CheckboxListTile(
              title: const Text('All'),
              value: passSelections.every((element) => element),
              onChanged: (value) {
                setState(() {
                  passSelections = List.generate(widget.subjects.length, (index) => value!);
                });
              },
              activeColor: AppColors.primary, // Match with primary color
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.subjects.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(widget.subjects[index]),
                    value: passSelections[index],
                    onChanged: (value) {
                      setState(() {
                        passSelections[index] = value!;
                      });
                    },
                    activeColor: AppColors.primary, // Match with primary color
                  );
                },
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'I want honors on:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 10.0),
            CheckboxListTile(
              title: const Text('All'),
              value: honorSelections.every((element) => element),
              onChanged: (value) {
                setState(() {
                  honorSelections = List.generate(widget.subjects.length, (index) => value!);
                });
              },
              activeColor: AppColors.primary, // Match with primary color
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.subjects.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(widget.subjects[index]),
                    value: honorSelections[index],
                    onChanged: (value) {
                      setState(() {
                        honorSelections[index] = value!;
                      });
                    },
                    activeColor: AppColors.primary, // Match with primary color
                  );
                },
              ),
            ),
            const SizedBox(height: 20.0), // Add spacing here
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary, // Match with primary color
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
