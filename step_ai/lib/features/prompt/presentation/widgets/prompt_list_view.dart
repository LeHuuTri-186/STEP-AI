import 'package:flutter/material.dart';
import 'package:step_ai/features/prompt/data/models/prompt_model.dart';
import 'package:step_ai/features/prompt/presentation/widgets/prompt_info_dialog.dart';
import 'package:step_ai/features/prompt/presentation/widgets/prompt_tile.dart';
import 'package:step_ai/shared/widgets/use_prompt_bottom_sheet.dart';

class PromptListView extends StatelessWidget {
  const PromptListView({
    super.key,
    required ScrollController scrollController,
    required this.prompts,
    required this.toggleFavorite,
    required this.returnPrompt,
  }) : _scrollController = scrollController;

  final ScrollController _scrollController;
  final List<PromptModel> prompts;
  final Function(int) toggleFavorite;
  final Function(String) returnPrompt;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        controller: _scrollController,
        primary: false,
        shrinkWrap: true,
        itemCount: prompts.length,
        itemBuilder: (_, int index) {
          return PromptTile(
              prompt: prompts[index],
              index: index,
              onTap: () async {
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
              },
              onGetInfoClick: () => showPromptDialog(
                  context: context,
                  prompt: prompts[index],
                  onUsePrompt: () => {Navigator.of(context).pop()},
                  index: index),
              onToggleFavorite: () => toggleFavorite(index));
        },
        separatorBuilder: (_, int index) {
          return const Divider();
        },
      ),
    );
  }

  void showPromptDialog(
      {required BuildContext context,
      required PromptModel prompt,
      required VoidCallback onUsePrompt,
      required int index}) {
    showDialog(
      context: context,
      builder: (context) => PromptDialog(
        prompt: prompt,
        onUsePrompt: () {},
        setFavorite: () => toggleFavorite(index),
      ),
    );
  }
}
