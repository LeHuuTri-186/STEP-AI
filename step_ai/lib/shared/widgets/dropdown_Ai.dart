import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/features/chat/notifier/assistant_notifier.dart';
import 'package:step_ai/shared/styles/horizontal_spacing.dart';

import '../../core/di/service_locator.dart';

class DropdownAI extends StatelessWidget {
  DropdownAI({super.key});

  @override
  Widget build(BuildContext context) {
    final _assistantNotifier =
        Provider.of<AssistantNotifier>(context, listen: true);
    return Center(
      child: PopupMenuButton(
        offset:
            Offset(25, -(_assistantNotifier.assistants.length * 50.0) - 5.0),
        position: PopupMenuPosition.over,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
        itemBuilder: (context) {
          return _assistantNotifier.assistants.map((model) {
            return PopupMenuItem(
              value: model.id,
              child: Row(
                children: [
                  SizedBox(
                      width: 20,
                      height: 20,
                      child: Image.asset(model.logoPath!)),
                  HSpacing.sm,
                  Text(model.name!),
                ],
              ),
            );
          }).toList();
        },
        onSelected: (value) {
          _assistantNotifier.setCurrentAssistantId(value);
          // Handle selection here (e.g., navigate or update UI)
        },
        child: Row(
          children: [
            Image.asset(
              _assistantNotifier.currentAssistant.logoPath!,
              width: 25,
              height: 25,
            ),
            const Icon(Icons.arrow_drop_up),
          ],
        ),
      ),
    );
  }
}
