import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/features/prompt/presentation/widgets/category_chips_selector.dart';
import 'package:step_ai/shared/styles/horizontal_spacing.dart';
import 'package:step_ai/shared/styles/vertical_spacing.dart';
import 'package:step_ai/shared/widgets/search_bar.dart';

import '../../../../shared/styles/colors.dart';
import '../state/public_prompt/public_filter_provider.dart';
import '../state/public_prompt/public_view_provider.dart';
import '../widgets/no_prompts_panel.dart';
import '../widgets/prompt_list_view.dart';

class PublicPromptsPanel extends StatefulWidget {
  const PublicPromptsPanel({super.key, required this.returnPrompt});
  final Function(String) returnPrompt;

  @override
  State<PublicPromptsPanel> createState() => _PublicPromptsPanelState();
}

class _PublicPromptsPanelState extends State<PublicPromptsPanel> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PublicViewState>().fetchPrompts();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PublicViewState promptsState = context.watch<PublicViewState>();
    final PublicFilterState filterState = context.watch<PublicFilterState>();

    return Scaffold(
      body: _buildBody(promptsState, filterState),
    );
  }

  Widget _buildBody(PublicViewState promptsState, PublicFilterState filterState) {
    return Column(
      children: [
        VSpacing.sm,
        Row(
          children: [
            Flexible(
              flex: 4,
              child: CustomSearchBar(
                onChanged: filterState.setSearchQuery,
              ),
            ),
            HSpacing.sm,
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                splashColor: TColor.northEastSnow.withOpacity(0.4),
                onTap: () => filterState.setFavorite(!filterState.isFavorite),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: TColor.petRock.withOpacity(0.5)),
                  ),
                  child: _buildFavoriteIcon(filterState.isFavorite),
                ),
              ),
            ),
          ],
        ),
        VSpacing.md,
        CollapsibleCategoryChips(
          categories: filterState.categories,
          selectedCategory: filterState.category,
          isExpanded: promptsState.isExpandedChips,
          onToggleExpanded: () {
            promptsState.setIsExpandedChips(!promptsState.isExpandedChips);
          },
          onCategorySelected: filterState.setCategory,
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

  Widget _buildLoader(PublicViewState promptsState) {
    return promptsState.isFetchingMore
        ? _twistingDotsLoadIndicator()
        : const SizedBox();
  }

  Widget _buildListView(PublicViewState promptsState) {
    if (promptsState.isLoading) {
      return Expanded(
        child: Center(
          child: _twistingDotsLoadIndicator(),
        ),
      );
    }

    if (promptsState.prompts.isNotEmpty) {
      return Consumer<PublicViewState>(
        builder: (BuildContext context, PublicViewState value, Widget? child) {
          return PromptListView(
            scrollController: _scrollController,
            prompts: promptsState.prompts,
            toggleFavorite: promptsState.toggleFavorite, returnPrompt: widget.returnPrompt,
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
    final promptsState = Provider.of<PublicViewState>(
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