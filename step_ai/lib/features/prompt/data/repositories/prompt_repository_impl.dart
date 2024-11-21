import 'package:step_ai/features/prompt/data/models/prompt_query_response_model.dart';
import 'package:step_ai/features/prompt/domain/repositories/prompt_repository.dart';
import 'package:step_ai/features/prompt/data/models/prompt_model.dart';
import 'package:step_ai/core/api/api_service.dart';

import '../network/prompt_api.dart';

class PromptRepositoryImpl extends PromptRepository {
  final PromptApi _promptApi;

  PromptRepositoryImpl(this._promptApi);

  @override
  Future<List<PromptModel>> getPrompts({
    int offset = 0,
    int limit = 10,
    String? query,
    required bool isPublic,
    String category = "all",
    bool isFavorite = false,
  }) async {
    // Query Parameters for the GET request
    final queryParameters = {
      'offset': offset,
      'limit': limit,
      'isPublic': isPublic,
      if (query != null && query.isNotEmpty) 'query': query,
      if (isFavorite) 'isFavorite': true,
      if (category.toLowerCase() != 'all') 'category': category.toLowerCase(),
    };

    // API call using PromptApi
    final response = await _promptApi.get(
      '/api/v1/prompts',
      queryParams: queryParameters,
    );

    // Deserialize response data into models
    return PromptQueryResponse.fromJson(response.data).items;
  }

  @override
  Future<void> addPromptToFavorite({required String id}) async {
    await _promptApi.post('/api/v1/prompts/$id/favorite');
  }

  @override
  Future<void> removePromptFromFavorite({required String id}) async {
    await _promptApi.delete('/api/v1/prompts/$id/favorite');
  }

  @override
  Future<void> createPrompt({required PromptModel prompt}) async {
    // Map PromptModel to request body
    final data = {
      "title": prompt.title,
      "category": prompt.category,
      "content": prompt.content,
      "description": prompt.description,
      "isPublic": prompt.isPublic,
      "language": prompt.language,
    };

    await _promptApi.post('/api/v1/prompts', data: data);
  }

  @override
  Future<void> deletePrompt({required String id}) async {
    await _promptApi.delete('/api/v1/prompts/$id');
  }

  @override
  Future<void> updatePrompt({required PromptModel prompt}) async {
    // Map PromptModel to request body
    final data = {
      "title": prompt.title,
      "category": prompt.category,
      "content": prompt.content,
      "description": prompt.description,
      "isPublic": prompt.isPublic,
      "language": prompt.language,
    };

    await _promptApi.patch('/api/v1/prompts/${prompt.id}', data: data);
  }
}
