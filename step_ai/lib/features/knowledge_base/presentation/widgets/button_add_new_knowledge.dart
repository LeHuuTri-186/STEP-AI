import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:step_ai/features/knowledge_base/presentation/widgets/add_knowledge_dialog.dart';
import 'package:step_ai/shared/styles/colors.dart';

class ButtonAddNewKnowledge extends StatelessWidget {
  const ButtonAddNewKnowledge({super.key});
  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddKnowledgeDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 2.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: TColor.tamarama),
      child: TextButton(
        onPressed: () => _showAddDialog(context),
        child: SizedBox(
          width: 160,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "+ Create knowledge",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
