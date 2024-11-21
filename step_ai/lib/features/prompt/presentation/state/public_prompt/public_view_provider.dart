import 'package:flutter/material.dart';
import 'package:step_ai/features/prompt/presentation/state/public_prompt/public_filter_provider.dart';

import '../../../data/models/prompt_model.dart';
import '../../../domain/repositories/prompt_repository.dart';

class PublicViewState extends ChangeNotifier {
  final PromptRepository repository;
  final PublicFilterState filterState;

  List<PromptModel> _prompts = [];
  bool _isLoading = false;
  bool _isAdding = false;
  bool _isFetchingMore = false;
  final int _itemsRetrieve = 10;
  bool _hasMore = true;
  bool _isExpandedChips = false;

  PublicViewState({
    required this.repository,
    required this.filterState,
  }) {
    filterState.addListener(_onFilterChanged);
  }

  List<PromptModel> get prompts => _prompts;
  bool get isLoading => _isLoading;
  bool get isFetchingMore => _isFetchingMore;
  bool get hasMore => _hasMore;
  bool get isExpandedChips => _isExpandedChips;

  Future<void> toggleFavorite(int index) async {
    try {
      if (_prompts[index].isFavorite) {
        await repository.removePromptFromFavorite(id: _prompts[index].id);
        _prompts.removeAt(index);
      } else {
        await repository.addPromptToFavorite(id: _prompts[index].id);
        _prompts[index] = _prompts[index].copyWith(isFavorite: true);
      }
    } finally {
      notifyListeners();
    }
  }

  void setIsExpandedChips(bool value) {
    _isExpandedChips = value;
    notifyListeners();
  }

  Future<void> onPromptAdded(PromptModel prompt) async {
    try {
      _isAdding = true;
      notifyListeners();

      await repository.createPrompt(prompt: prompt);

      await refreshView();
    } finally {
      _isAdding = false;
      notifyListeners();
    }
  }

  Future<void> fetchPrompts({bool loadMore = false}) async {
    if (loadMore && (!_hasMore || _isFetchingMore)) {
      return;
    }

    _isLoading = !loadMore;
    _isFetchingMore = loadMore;
    notifyListeners();

    try {
      final newPrompts = await repository.getPrompts(
        offset: _prompts.length,
        limit: _itemsRetrieve,
        query: filterState.searchQuery,
        isPublic: true,
        isFavorite: filterState.isFavorite,
        category: filterState.category,
      );

      if (newPrompts.isEmpty) {
        _hasMore = false;
      } else {
        _prompts.addAll(newPrompts);
      }
    } catch (e) {
      debugPrint("Error fetching prompts: $e");
    } finally {
      _isLoading = false;
      _isFetchingMore = false;
      notifyListeners();
    }
  }

  Future<void> _onFilterChanged() async {
    _resetPrompts();
    await fetchPrompts();
  }

  void _resetPrompts() {
    _prompts = [];
    _hasMore = true;
    notifyListeners();
  }

  @override
  void dispose() {
    filterState.removeListener(_onFilterChanged);
    super.dispose();
  }

  Future<void> refreshView() async {
    _resetPrompts();
    await fetchPrompts();
  }
}
