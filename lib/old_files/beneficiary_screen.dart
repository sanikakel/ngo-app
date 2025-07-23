
/*
import 'package:flutter/material.dart';
import 'beneficiary_dashboard_screen.dart';
import 'category_selection_screen.dart'; // If this exists

class BeneficiaryScreen extends StatefulWidget {
  @override
  _BeneficiaryScreenState createState() => _BeneficiaryScreenState();
}

class _BeneficiaryScreenState extends State<BeneficiaryScreen> {
  String? category;

  @override
  Widget build(BuildContext context) {
    if (category == null) {
      // Show category selection first
      return CategorySelectionScreen(
        onCategorySelected: (selectedCat) {
          setState(() {
            category = selectedCat;
          });
        },
      );
    } else {
      // Show dashboard with category info (pass category if needed)
      return BeneficiaryDashboardScreen(category: category!);
    }
  }
}
*/