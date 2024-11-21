import '../../data/models/prompt_model.dart';

abstract class PromptRepository {
  Future<List<PromptModel>> getPrompts({
    int offset = 0,
    int limit = 10,
    String? query,
    required bool isPublic,
    String category,
    bool isFavorite,
  });

  Future<void> addPromptToFavorite({required String id});
  Future<void> removePromptFromFavorite({required String id});

  Future<void> createPrompt({required PromptModel prompt});

  Future<void> deletePrompt({required String id});

  Future<void> updatePrompt({required PromptModel prompt});
}
