import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../styles/colors.dart';

class CategoryChips extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory; // Currently selected category
  final Function(String) onCategorySelected; // Callback for category selection

  const CategoryChips({
    Key? key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: _buildChips(context),
    );
  }

  // Helper method to build category chips
  List<Widget> _buildChips(BuildContext context) {
    return categories.map((category) {
      final isSelected = selectedCategory == category;
      return ChoiceChip(
        side: isSelected ? BorderSide.none : BorderSide(color: TColor.petRock.withOpacity(0.3)),
        showCheckmark: false,
        label: Text(category),
        labelStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
          color: isSelected ? TColor.doctorWhite : TColor.squidInk,
            fontWeight: FontWeight.w800,
            fontSize: 13,
        ),
        selectedColor: TColor.tamarama, // Highlight color for selected chip
        backgroundColor: TColor.doctorWhite, // Background for non-selected chips
        selected: isSelected,
        onSelected: (_) => onCategorySelected(category), // External selection handler
      );
    }).toList();
  }
}
