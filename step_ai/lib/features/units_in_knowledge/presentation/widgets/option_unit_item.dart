import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/features/units_in_knowledge/notifier/add_option_unit_notifier.dart';

class OptionUnitItem extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final String value;
  late AddOptionUnitNotifier addOptionUnitNotifier;
  OptionUnitItem(
      {super.key,
      required this.imagePath,
      required this.title,
      required this.subtitle,
      required this.value});

  @override
  Widget build(BuildContext context) {
    AddOptionUnitNotifier addOptionUnitNotifier =
        Provider.of<AddOptionUnitNotifier>(context, listen: true);
    return GestureDetector(
      onTap: () {
        addOptionUnitNotifier.setSelectedOption(value);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: addOptionUnitNotifier.selectedOption == value
                ? Colors.blue
                : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Image Source +Title
                  Row(
                    children: [
                      Image.asset(
                        imagePath,
                        width: 24,
                        height: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            //Ration select
            Radio<String>(
              value: value,
              groupValue: addOptionUnitNotifier.selectedOption,
              onChanged: (String? newValue) {
                addOptionUnitNotifier.selectedOption = newValue!;
              },
              activeColor: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
