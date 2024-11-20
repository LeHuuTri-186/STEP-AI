import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/features/prompt/presentation/widgets/category_chips_selector.dart';
import 'package:step_ai/shared/styles/horizontal_spacing.dart';
import 'package:step_ai/shared/styles/vertical_spacing.dart';
import 'package:step_ai/shared/widgets/search_bar.dart';

import '../../../../shared/styles/colors.dart';

import '../state/private_prompt/private_filter_provider.dart';
import '../state/private_prompt/private_view_provider.dart';
import '../widgets/no_prompts_panel.dart';
import '../widgets/private_prompt_list_view.dart';
import '../widgets/prompt_list_view.dart';

class PrivatePromptsPanel extends StatefulWidget {
  const PrivatePromptsPanel({super.key});

  @override
  State<PrivatePromptsPanel> createState() => _PrivatePromptsPanelState();
}

class _PrivatePromptsPanelState extends State<PrivatePromptsPanel> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PrivateViewState>().fetchPrompts();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PrivateViewState promptsState = context.watch<PrivateViewState>();
    final PrivateFilterState filterState = context.watch<PrivateFilterState>();

    return Scaffold(
      body: _buildBody(promptsState, filterState),
    );
  }

  Widget _buildBody(PrivateViewState promptsState, PrivateFilterState filterState) {
    return Column(
      children: [
        VSpacing.sm,
        CustomSearchBar(
          onChanged: filterState.setSearchQuery,
        ),
        VSpacing.md,
        _buildListView(promptsState),
        VSpacing.md,
        _buildLoader(promptsState),
        VSpacing.md,
      ],
    );
  }

  Icon _buildFavoriteIcon(bool isFavorite) => isFavorite
      ? Icon(
    Icons.star_rounded,
    color: TColor.goldenState,
    semanticLabel: "Favorite",
    size: 25,
  )
      : Icon(
    Icons.star_border_rounded,
    color: TColor.petRock.withOpacity(0.5),
    semanticLabel: "Favorite",
    size: 25,
  );

  Widget _buildLoader(PrivateViewState promptsState) {
    return promptsState.isFetchingMore
        ? _twistingDotsLoadIndicator()
        : const SizedBox(width: 0, height: 0,);
  }

  Widget _buildListView(PrivateViewState promptsState) {
    if (promptsState.isLoading) {
      return Expanded(
        child: Center(
          child: _twistingDotsLoadIndicator(),
        ),
      );
    }

    if (promptsState.prompts.isNotEmpty) {
      return Consumer<PrivateViewState>(
        builder: (BuildContext context, PrivateViewState value, Widget? child) {
          return PrivatePromptListView(
            scrollController: _scrollController,
            prompts: promptsState.prompts,  deleteIndex: promptsState.onPromptDelete, updatePrompt: promptsState.onPromptUpdate,
          );
        },
      );
    }

    return Expanded(
      child: Center(
        child: _buildNoPromptPanel(),
      ),
    );
  }

  Widget _twistingDotsLoadIndicator() {
    return LoadingAnimationWidget.twistingDots(
      size: 50,
      leftDotColor: TColor.tamarama,
      rightDotColor: TColor.daJuice,
    );
  }

  Widget _buildNoPromptPanel() {
    return const NoPromptPanel();
  }

  void _onScroll() {
    final promptsState = Provider.of<PrivateViewState>(
      context,
      listen: false,
    );

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200 &&
        !promptsState.isFetchingMore &&
        promptsState.hasMore) {
      promptsState.fetchPrompts(
        loadMore: true,
      );
    }
  }
}