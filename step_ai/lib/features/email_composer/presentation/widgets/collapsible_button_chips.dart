import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../config/constants.dart';
import '../../../../shared/styles/colors.dart';
import '../../../prompt/presentation/widgets/language_custom_dropdown.dart';

class CollapsibleChipListScreen extends StatefulWidget {
  final Map<String, String>
  actions; // Map for chip labels and their corresponding actions
  final void Function(String, String?) onClick;
  CollapsibleChipListScreen({
    required this.actions,
    required this.onClick,
  });

  @override
  State<CollapsibleChipListScreen> createState() =>
      _CollapsibleChipListScreenState();
}

class _CollapsibleChipListScreenState extends State<CollapsibleChipListScreen> {
  // Callback for chip click
  String _selectedLanguage = Constant.languages.values.first;

  final _languages = Constant.languages;

  bool _canceled = true;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0, // Horizontal spacing between chips
      runSpacing: 8.0, // Vertical spacing between rows of chips
      children: widget.actions.entries.map((entry) {
        return ActionChip(
          side: BorderSide.none,
          label: Text(entry.key),
          onPressed: () async {
            if (entry.key.contains("Translate to")) {
              await _showLanguageSelectorDialog(context);
              if (!_canceled) {
                _canceled = true;
                return widget.onClick(entry.key, _selectedLanguage);
              }

              return;
            }
            widget.onClick(entry.key, null); // Trigger callback with action
          },
          backgroundColor: TColor.tamarama,
          labelStyle: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(
              color: TColor.doctorWhite,
            fontSize: 14,
            fontWeight: FontWeight.w600
          ),
        );
      }).toList(),
    );
  }

  Future<void> _showLanguageSelectorDialog(BuildContext context) {
    setState(() {
      _selectedLanguage = _languages.values.first;
    });
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: StatefulBuilder(builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Select Language',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        onTap: () {
                          _canceled = true;
                          Navigator.of(context).pop();
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.close),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  LanguageCustomDropdown(
                      value: _selectedLanguage,
                      items: _languages,
                      onChanged: (l) {
                        setState(() {
                          _selectedLanguage = l!;
                        });
                      },
                      hintText: "Select language"),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                            _canceled = true;
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Ink(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Text('Cancel'),
                            ),
                          ),
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            _canceled = false;
                            Navigator.of(context).pop();
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Ink(
                            decoration: BoxDecoration(
                              color: TColor.tamarama,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Text(
                                'OK',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }
}
