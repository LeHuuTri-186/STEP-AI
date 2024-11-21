import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/features/chat/notifier/assistant_notifier.dart';
import 'package:step_ai/shared/styles/horizontal_spacing.dart';

import '../../core/di/service_locator.dart';
import '../styles/colors.dart';

class DropdownAI extends StatefulWidget {
  const DropdownAI({super.key});

  @override
  State<DropdownAI> createState() => _DropdownAIState();
}

class _DropdownAIState extends State<DropdownAI> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final _assistantNotifier = Provider.of<AssistantNotifier>(context, listen: true);

    return Center(
      child: PopupMenuButton(
        onOpened: () => setState(() {
          _isExpanded = true;
        }),
        onCanceled: () => setState(() {
          _isExpanded = false;
        }),
        popUpAnimationStyle: AnimationStyle(
          duration: const Duration()
        ),
        color: TColor.doctorWhite,
        offset: Offset(0, -(_assistantNotifier.assistants.length * 48.0) - 10.0),
        position: PopupMenuPosition.over,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        itemBuilder: (context) {
          return [
            // Custom header with a button
            PopupMenuItem(
              enabled: false, // Disable selection for the header
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {},
                          child: Ink(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: TColor.daJuice.withOpacity(0.3),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
                              child: Text(
                                "+ Create Assistant",
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: TColor.petRock,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Text(
                    "Base model",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: TColor.petRock.withOpacity(0.6),
                      fontSize: 15,
                    ),
                  ),// Add a divider to separate the header
                ],
              ),
            ),
            // Add the list of assistants
            ..._assistantNotifier.assistants.map((model) {
              return PopupMenuItem(
                value: model.id,
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: TColor.slate.withOpacity(0.9),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(model.logoPath!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    HSpacing.md,
                    Text(
                      model.name!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: TColor.petRock,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ];
        },
        onSelected: (value) {
          _assistantNotifier.setCurrentAssistantId(value);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: TColor.northEastSnow,
            borderRadius: BorderRadius.circular(24.0),
            border: Border.all(
              color: Colors.grey.shade300,
              width: 0.0,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: TColor.slate.withOpacity(0.9),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(_assistantNotifier.currentAssistant.logoPath!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              HSpacing.sm,
              Text(
                _assistantNotifier.currentAssistant.name!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: TColor.petRock,
                ),
              ),
              Icon(
                _isExpanded
                    ? Icons.arrow_drop_up_rounded
                    : Icons.arrow_drop_down_rounded,
                size: 24,
                color: TColor.petRock,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
