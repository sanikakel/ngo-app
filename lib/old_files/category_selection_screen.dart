

/*
import 'package:flutter/material.dart';
import 'info_screens/senior_citizen_info_screen.dart';
import 'info_screens/specially_abled_info_screen.dart';
import 'info_screens/underprivileged_girls_screen.dart';

class CategorySelectionScreen extends StatefulWidget {
  final Function(String) onCategorySelected;

  CategorySelectionScreen({required this.onCategorySelected});

  @override
  _CategorySelectionScreenState createState() => _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  String? selectedCategory;

  final List<String> categories = [
    'Underprivileged Girl',
    'Senior Citizen',
    'Specially-Abled',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Your Category')),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'Please select your category:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            ...categories.map((cat) {
              return RadioListTile<String>(
                title: Text(cat),
                value: cat,
                groupValue: selectedCategory,
                onChanged: (val) {
                  setState(() {
                    selectedCategory = val;
                  });
                },
              );
            }).toList(),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                if (selectedCategory == 'Senior Citizen') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SeniorCitizenScreen()),
                  );
                } else if (selectedCategory == 'Specially-Abled') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SpeciallyAbledScreen()),
                  );
                } else if (selectedCategory == 'Underprivileged Girl') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UnderprivilegedGirlsScreen()),
                  );
                }
              },
              child: Text('Continue'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/