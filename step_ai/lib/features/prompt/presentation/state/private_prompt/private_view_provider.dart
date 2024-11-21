import 'package:flutter/material.dart';
import 'package:step_ai/features/prompt/presentation/state/private_prompt/private_filter_provider.dart';

import '../../../data/models/prompt_model.dart';
import '../../../domain/repositories/prompt_repository.dart';

class PrivateViewState extends ChangeNotifier {
  final PromptRepository repository;
  final PrivateFilterState filterState;

  List<PromptModel> _prompts = [];
  bool _isLoading = false;
  bool _isFetchingMore = false;
  final int _itemsRetrieve = 10;
  bool _hasMore = true;
  bool _isAdding = false;
  bool _isUpdating = false;

  bool get isAdding => _isAdding;

  PrivateViewState({
    required this.repository,
    required this.filterState,
  }) {
    filterState.addListener(_onFilterChanged);
  }

  List<PromptModel> get prompts => _prompts;
  bool get isLoading => _isLoading;
  bool get isFetchingMore => _isFetchingMore;
  bool get hasMore => _hasMore;

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
        isPublic: false,
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

  Future<void> onPromptUpdate(PromptModel prompt) async {
    try {
      _isUpdating = true;
      notifyListeners();

      await repository.updatePrompt(prompt: prompt);

      await refreshView();
    } finally {
      _isUpdating = false;

      notifyListeners();
    }
  }

  Future<void> onPromptDelete(int index) async {
    try {
      await repository.deletePrompt(id: _prompts[index].id);

      await refreshView();
    } finally {
      notifyListeners();
    }
  }

  void _onFilterChanged() {
    _resetPrompts();
    fetchPrompts();
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
