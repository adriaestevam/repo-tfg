import 'package:flutter/material.dart';
import 'package:tfg_v1/Presentation/lib/utilities/app_colors.dart';
import 'choose_subjects.dart';

class UniversitySearchPage extends StatefulWidget {
  const UniversitySearchPage({super.key});

    @override
  _UniversitySearchPageState createState() => _UniversitySearchPageState();
}

String _selectedUniversity = '';

class _UniversitySearchPageState extends State<UniversitySearchPage> {
  List<String> universities = [
    'Harvard University',
    'Stanford University',
    'Massachusetts Institute of Technology',
    'University of Cambridge',
    'University of Oxford',
    'California Institute of Technology',
    'University of Chicago',
    'Princeton University',
    'Yale University',
    'Columbia University',
    'University of California, Berkeley',
    'University of Pennsylvania',
    'University of Michigan',
    'Johns Hopkins University',
    'Northwestern University',
    'University of California, Los Angeles',
    'University of Tokyo',
    'Kyoto University',
    'University of Toronto',
    'University of Hong Kong',
  ];

  List<String> filteredUniversities = [];
  String query = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredUniversities.addAll(universities);
  }

  void filterUniversities(String newQuery) {
    setState(() {
      query = newQuery;
      filteredUniversities.clear();
      if (query.isNotEmpty) {
        for (var university in universities) {
          if (university.toLowerCase().contains(query.toLowerCase())) {
            filteredUniversities.add(university);
          }
        }
      } else {
        filteredUniversities.addAll(universities);
      }
    });
  }

  void selectUniversity(String university) {
    // Handle the selection of the university
    print('Selected university: $university');

    // Set the selected university
    _selectedUniversity = university;

    // Clear the search query and hide the keyboard
    _searchController.clear();
    FocusScope.of(context).unfocus();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Choose University',
          style: TextStyle(color: AppColors.text),
        ),
        backgroundColor: AppColors.primary,
      ),
      body: Container(
        color: AppColors.accent,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
                        const Text(
              'Choose the university you study',
              style: TextStyle(
                fontSize: 18.0,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search university',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: filterUniversities,
            ),
            if (filteredUniversities.isNotEmpty &&
                filteredUniversities.length != universities.length) ...[
              Expanded(
                child: ListView.builder(
                  itemCount: filteredUniversities.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(filteredUniversities[index]),
                      onTap: () {
                        selectUniversity(filteredUniversities[index]);
                      },
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_selectedUniversity.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChooseSubjectsPage(university: _selectedUniversity)),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary, // Use primary color from theme
                  minimumSize: const Size(double.infinity, 0), // Set minimum width
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0), // Adjust padding
                  child: Text(
                    'Select',
                    style: TextStyle(fontSize: 16.0, color: Colors.white), // Set text color to white
                  ),
                ),
              ),
            ] else ...[
              if (query.isNotEmpty) ...[
                const Expanded(
                  child: Center(
                    child: Text(
                      'No universities found',
                      style: TextStyle(
                        color: AppColors.text,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
