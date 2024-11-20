import 'package:flutter/material.dart';
import 'package:step_ai/features/prompt/data/models/prompt_model.dart';
import 'package:step_ai/features/prompt/presentation/widgets/prompt_info_dialog.dart';
import 'package:step_ai/features/prompt/presentation/widgets/prompt_tile.dart';

class PromptListView extends StatelessWidget {
  const PromptListView({
    super.key,
    required ScrollController scrollController,
    required this.prompts,
    required this.toggleFavorite,
  }) : _scrollController = scrollController;

  final ScrollController _scrollController;
  final List<PromptModel> prompts;
  final Function(int) toggleFavorite;

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
              onTap: () {},
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
        onUsePrompt: onUsePrompt,
        setFavorite: () => toggleFavorite(index),
      ),
    );
  }
}
