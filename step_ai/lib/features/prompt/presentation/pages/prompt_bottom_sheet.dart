import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/features/prompt/presentation/pages/private_prompts.dart';
import 'package:step_ai/features/prompt/presentation/pages/public_prompts.dart';
import 'package:step_ai/features/prompt/presentation/state/form_model/form_provider.dart';
import 'package:step_ai/features/prompt/presentation/state/public_prompt/public_filter_provider.dart';
import 'package:step_ai/features/prompt/presentation/widgets/buttons_pair.dart';
import 'package:step_ai/features/prompt/presentation/widgets/prompt_create_dialog.dart';
import 'package:step_ai/shared/styles/colors.dart';
import 'package:step_ai/shared/styles/vertical_spacing.dart';

import '../state/prompt_view_provider.dart';

class PromptBottomSheet extends StatefulWidget {
  const PromptBottomSheet({super.key, required this.returnPrompt});
  final Function(String) returnPrompt;

  @override
  State<PromptBottomSheet> createState() => _PromptBottomSheetState();
}

class _PromptBottomSheetState extends State<PromptBottomSheet> {
  @override
  Widget build(BuildContext context) {

    final promptState = context.watch<PromptViewState>();

    return Container(
      decoration: BoxDecoration(
        color: TColor.doctorWhite,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Scaffold(
        appBar: _buildAppBar(context, promptState),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ButtonsPair(
                isFirstSelected: promptState.isPrivate,
                firstOnTap: () => promptState.togglePrivate(true),
                secondOnTap: () => promptState.togglePrivate(false),
                firstButtonText: 'My prompts',
                secondButtonText: 'Public prompts',
              ),
              VSpacing.sm,
              Expanded(
                child: promptState.isPrivate
                    ? PrivatePromptsPanel(returnPrompt: widget.returnPrompt,)
                    : PublicPromptsPanel(returnPrompt:  widget.returnPrompt,),
              )
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, PromptViewState promptState) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Text("Prompt Library"),
      titleTextStyle: Theme.of(context).textTheme.titleLarge,
      centerTitle: false,
      actions: [
        Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          child: InkWell(
            onTap: () {
              showPromptDialog(context: context, promptState: promptState);
            },
            splashColor: TColor.daJuice.withOpacity(0.4),
            highlightColor: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(50),
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    TColor.tamarama, // Starting color
                    TColor.daJuice, // Ending color
                  ],
                  begin: Alignment.topLeft, // Gradient starts from top left
                  end: Alignment.bottomRight, // Gradient ends at bottom right
                ),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Icon(Icons.add, color: TColor.doctorWhite),
              ),
            ),
          ),
        ),
        const CloseButton(),
      ],
    );
  }

  void showPromptDialog({
    required BuildContext context,
    required PromptViewState promptState,
  }) {
    showDialog(
      context: context,
      builder: (context) => PromptCreateDialog(
        onCreatePrompt: promptState.onPromptCreate,
      ),
    );
  }
}
