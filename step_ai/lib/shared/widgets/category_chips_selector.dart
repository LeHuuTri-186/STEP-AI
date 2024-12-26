import 'package:flutter/material.dart';
import 'package:step_ai/shared/styles/colors.dart';

class CollapsibleCategoryChips extends StatelessWidget {
  final List<String> categories; // List of categories
  final String selectedCategory; // Currently selected category
  final bool isExpanded; // Determines if chips are expanded
  final Function(String) onCategorySelected; // Callback for category selection
  final VoidCallback onToggleExpanded; // Callback for expand/collapse toggle

  const CollapsibleCategoryChips({
    Key? key,
    required this.categories,
    required this.selectedCategory,
    required this.isExpanded,
    required this.onCategorySelected,
    required this.onToggleExpanded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row for chips and arrow
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: AnimatedSize(
                duration: const Duration(milliseconds: 500),
                curve: Curves.fastEaseInToSlowEaseOut,
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: _buildChips(
                    isExpanded: isExpanded,
                  ),
                ),
              ),
            ),

            // Expand/Collapse Arrow Button
            InkWell(
              splashColor: TColor.northEastSnow,
              borderRadius: BorderRadius.circular(12),
              onTap: onToggleExpanded,
              child: SizedBox(
                width: 40,
                height: 40,
                child: Icon(
                  isExpanded
                      ? Icons.arrow_drop_up_rounded
                      : Icons.arrow_drop_down_rounded,
                  color: TColor.tamarama,
                  semanticLabel: isExpanded ? "Collapses" : "Expands",
                  size: 35,
                ),
              ), // External toggle handler
            ),
          ],
        ),
      ],
    );
  }

  // Helper method to build category chips
  List<Widget> _buildChips({required bool isExpanded}) {
    final chips = categories.map((category) {
      final isSelected = selectedCategory == category;
      return ChoiceChip(
        side: BorderSide.none,
        showCheckmark: false,
        label: Text(category),
        labelStyle: TextStyle(
          color: isSelected ? TColor.doctorWhite : TColor.squidInk,
        ),
        selectedColor: TColor.tamarama, // Highlight color for selected chip
        backgroundColor: TColor.northEastSnow, // Background for non-selected chips
        selected: isSelected,
        onSelected: (_) => onCategorySelected(category), // External selection handler
      );
    }).toList();

    // Show all chips if expanded; otherwise limit the visible chips
    return isExpanded ? chips : chips.take(4).toList();
  }
}
