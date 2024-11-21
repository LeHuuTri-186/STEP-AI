import 'package:flutter/material.dart';

import '../../../../shared/styles/colors.dart';
import '../../../../shared/styles/horizontal_spacing.dart';
import '../../../../shared/styles/vertical_spacing.dart';

class PrivateForm extends StatefulWidget {
  const PrivateForm({super.key, required this.formKey, required this.onTitleChanged, required this.onContentChanged,});
  final GlobalKey<FormState> formKey;
  final ValueChanged<String> onTitleChanged;
  final ValueChanged<String> onContentChanged;

  @override
  State<PrivateForm> createState() => _PrivateFormState();
}

class _PrivateFormState extends State<PrivateForm> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  String getTitle() => _titleController.text;
  String getContent() => _contentController.text;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text.rich(
              TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: TColor.petRock,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    wordSpacing: 1,
                  ),
                  children: [
                    const TextSpan(text: 'Title'),
                    TextSpan(
                        text: ' *',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: TColor.poppySurprise,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        )),
                  ]),
            ),
          ),
          VSpacing.sm,
          TextFormField(
            onChanged: widget.onTitleChanged,
            controller: _titleController,
            cursorColor: TColor.tamarama,
            decoration: InputDecoration(
              filled: true,
              fillColor: TColor.northEastSnow,
              focusColor: TColor.grahamHair,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
                gapPadding: 4.0,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: TColor.tamarama
                ),
                borderRadius: BorderRadius.circular(15),
                gapPadding: 4.0,
              ),
              hintText: "Title of the prompt",
              hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: TColor.petRock.withOpacity(0.5),
                fontSize: 15,
                fontWeight: FontWeight.w500,
                wordSpacing: 1,
              ),
            ),
          ),
          VSpacing.sm,
          Align(
            alignment: Alignment.centerLeft,
            child: Text.rich(
              TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: TColor.petRock,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    wordSpacing: 1,
                  ),
                  children: [
                    const TextSpan(text: 'Prompt'),
                    TextSpan(
                        text: ' *',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: TColor.poppySurprise,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        )),
                  ]),
            ),
          ),
          VSpacing.sm,
          Container(
            decoration: BoxDecoration(
              color: TColor.tamarama.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                children: [
                  Icon(Icons.info_rounded, color: TColor.tamarama,),
                  HSpacing.sm,
                  Text(
                    "Use square brackets [ ] to specify user input.",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: TColor.squidInk
                    ),
                  ),
                ],
              ),
            ),
          ),
          VSpacing.sm,
          TextFormField(
            onChanged: widget.onContentChanged,
            controller: _contentController,
            maxLines: 3,
            cursorColor: TColor.tamarama,
            decoration: InputDecoration(
              filled: true,
              fillColor: TColor.northEastSnow,
              focusColor: TColor.grahamHair,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
                gapPadding: 4.0,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: TColor.tamarama
                ),
                borderRadius: BorderRadius.circular(15),
                gapPadding: 4.0,
              ),
              hintText: "e.g: Write a [cover letter/resume/thank you note] for a [Job Title] position at [Company Name].",
              hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: TColor.petRock.withOpacity(0.5),
                fontSize: 15,
                fontWeight: FontWeight.w500,
                wordSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
