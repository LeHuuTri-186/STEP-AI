import 'package:flutter/material.dart';
import 'package:step_ai/features/prompt/data/models/prompt_model.dart';
import 'package:step_ai/features/prompt/presentation/widgets/private_prompt_tile.dart';
import 'package:step_ai/features/prompt/presentation/widgets/prompt_info_dialog.dart';
import 'package:step_ai/features/prompt/presentation/widgets/prompt_tile.dart';
import 'package:step_ai/features/prompt/presentation/widgets/prompt_update_dialog.dart';
import 'package:step_ai/shared/styles/horizontal_spacing.dart';
import 'package:step_ai/shared/styles/vertical_spacing.dart';

import '../../../../shared/styles/colors.dart';
import '../../../../shared/styles/varela_round_style.dart';
import 'delete_prompt_dialog.dart';

class PrivatePromptListView extends StatelessWidget {
  const PrivatePromptListView({
    super.key,
    required ScrollController scrollController,
    required this.prompts, required this.deleteIndex, required this.updatePrompt
  }) : _scrollController = scrollController;

  final ScrollController _scrollController;
  final List<PromptModel> prompts;
  final Function(int) deleteIndex;
  final Function(PromptModel) updatePrompt;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        controller: _scrollController,
        primary: false,
        shrinkWrap: true,
        itemCount: prompts.length,
        itemBuilder: (_, int index) {
          return PrivatePromptTile(prompt: prompts[index], index: index,
            onTap: () {},
            onEdit: () {
              showUpdateDialog(context: context, prompt: prompts[index], onUpdatePrompt: updatePrompt);
            },
            onDelete: () {
              showPromptDialog(context: context, index: index, deleteIndex: deleteIndex);
            },);
        },
        separatorBuilder: (_, int index) {
          return const Divider();
        },
      ),
    );
  }

  void showPromptDialog(
      {required BuildContext context,
        required int index,
      required Function(int) deleteIndex}) {
    showDialog(
      context: context,
      builder: (context) => deletePromptDialog(
        deleteIndex: deleteIndex,
        index: index,
      )
    );
  }

  void showUpdateDialog({
    required BuildContext context,
    required PromptModel prompt,
    required Function(PromptModel) onUpdatePrompt
  }) {
    showDialog(
      context: context,
      builder: (context) => PromptUpdateDialog(
        onCreatePrompt: onUpdatePrompt, prompt: prompt
      ),
    );
  }
}

