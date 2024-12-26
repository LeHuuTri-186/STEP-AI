import 'package:flutter/material.dart';
import '../../../email_composer/domain/entity/assistant.dart';
import 'package:step_ai/shared/styles/horizontal_spacing.dart';
import '../../../../shared/styles/colors.dart';

class AiSelector extends StatefulWidget {
  final List<Assistant> assistants; // Assistants to be displayed in the dropdown
  final Function(dynamic) onAssistantSelected; // Callback for when an item is selected
  final Assistant selectedAssistant;

  const AiSelector({
    Key? key,
    required this.assistants,
    required this.onAssistantSelected,
    required this.selectedAssistant,
  }) : super(key: key);

  @override
  State<AiSelector> createState() => _AiSelectorState();
}

class _AiSelectorState extends State<AiSelector> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      splashRadius: 0,
      surfaceTintColor: Colors.transparent,
      onOpened: () => setState(() => _isExpanded = true),
      onCanceled: () => setState(() => _isExpanded = false),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      color: TColor.doctorWhite,
      position: PopupMenuPosition.over,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      itemBuilder: (context) {
        return
          widget.assistants.map((assistant) {
            return PopupMenuItem(
              value: assistant,
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: TColor.slate.withOpacity(0.9),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(assistant.logoPath!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  HSpacing.md,
                  Text(
                    assistant.name!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TColor.petRock,
                    ),
                  ),
                ],
              ),
            );
          }).toList();
      },
      onSelected: widget.onAssistantSelected,
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
                    image: AssetImage(widget.selectedAssistant.logoPath!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            HSpacing.sm,
            Text(
              widget.selectedAssistant.name!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: TColor.petRock,
              ),
            ),
            Icon(
              _isExpanded ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
              size: 24,
              color: TColor.petRock,
            ),
          ],
        ),
      ),
    );
  }
}
