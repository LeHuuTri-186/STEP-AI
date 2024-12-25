import 'package:flutter/material.dart';
import 'package:step_ai/features/prompt/data/models/prompt_model.dart';
import 'package:step_ai/features/prompt/presentation/widgets/private_prompt_tile.dart';
import 'package:step_ai/features/prompt/presentation/widgets/prompt_update_dialog.dart';

import '../../../../config/routes/routes.dart';

import '../../../../shared/widgets/use_prompt_bottom_sheet.dart';
import 'delete_prompt_dialog.dart';

class PrivatePromptListView extends StatelessWidget {
  const PrivatePromptListView({
    super.key,
    required ScrollController scrollController,
    required this.prompts, required this.deleteIndex, required this.updatePrompt, required this.returnPrompt
  }) : _scrollController = scrollController;

  final ScrollController _scrollController;
  final List<PromptModel> prompts;
  final Function(int) deleteIndex;
  final Function(PromptModel) updatePrompt;
  final Function(String)  returnPrompt;

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
            onTap: () async {
              await _buildUsePrompt(context, index);},
            onEdit: () {
              showUpdateDialog(context: context, prompt: prompts[index], onUpdatePrompt: updatePrompt);
            },
            onDelete: () {
              try {
                showPromptDialog(context: context, index: index, deleteIndex: deleteIndex);
              }
              catch (e) {
                print("e is 401 and return to login screen");
                print(e);
                Navigator.of(context).pushNamedAndRemoveUntil(
                  Routes.authenticate,
                      (Route<dynamic> route) => false,
                );
              }
            },);
        },
        separatorBuilder: (_, int index) {
          return const Divider();
        },
      ),
    );
  }

  Future<void> _buildUsePrompt(BuildContext context, int index) async {
    await showModalBottomSheet(
        context: context,
        builder: (_) {
          return PromptEditor(
            promptModel: prompts[index],
            returnPrompt: (value) {
              returnPrompt(value);
              Navigator.of(context).pop();
            },
          );
        });
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

