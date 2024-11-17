import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:step_ai/features/personal/presentation/widgets/search_bar_widget.dart';
import 'package:step_ai/shared/styles/vertical_spacing.dart';
import 'package:step_ai/shared/widgets/search_bar.dart';

class PrivatePromptsPanel extends StatefulWidget {
  const PrivatePromptsPanel({super.key});

  @override
  State<PrivatePromptsPanel> createState() => _PrivatePromptsPanelState();
}

class _PrivatePromptsPanelState extends State<PrivatePromptsPanel> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VSpacing.sm,
        CustomSearchBar(onChanged: (e) {
          if (kDebugMode) {
            print(e);
          }
        }),
      ],
    );
  }
}
