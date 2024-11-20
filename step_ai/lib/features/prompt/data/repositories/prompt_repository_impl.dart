import 'package:dio/dio.dart';
import 'package:step_ai/features/prompt/data/models/prompt_query_response_model.dart';
import 'package:step_ai/features/prompt/domain/repositories/prompt_repository.dart';

import '../models/prompt_model.dart';

class PromptRepositoryImpl extends PromptRepository {
  final Dio dio;

  PromptRepositoryImpl({required this.dio});

  final Map<String, dynamic> headers = {
    'x-jarvis-guid': '361331f8-fc9b-4dfe-a3f7-6d9a1e8b289b',
    'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjVhMGUwN2RkLWQ3ZDgtNDA3MS1iMmFmLWM3ZTA0ZGE1YjU0MyIsImVtYWlsIjoiYWxleGllOTkxMUBnbWFpbC5jb20iLCJpYXQiOjE3MzE4NTQ3MTcsImV4cCI6MTczMTg1NDc3N30.I8L7OGHsWubeE7kIxvQ53P0X8vcsmtXIEV1RVbyqg-s',
    'Content-Type': 'application/json',
  };

  @override
  Future<List<PromptModel>> getPrompts({int offset = 0, int limit = 10, String? query, required bool isPublic, String category = "all", bool isFavorite = false}) async {

    // Query Parameters
    Map<String, dynamic> queryParameters = {
      'offset': offset,
      'limit': limit,
      'isPublic': isPublic,
    };

    // Conditionally add non-null parameters
    if (query != null && query.isNotEmpty) {
      queryParameters['query'] = query;
    }

    if (isFavorite) {
      queryParameters['isFavorite'] = true;
    }

    if (category.toLowerCase() != 'all') {
      queryParameters['category'] = category.toLowerCase();
    }

    var response = await dio.get(
      '/api/v1/prompts',
      queryParameters: queryParameters,
      options: Options(
        headers: headers,
      )
    );

    return PromptQueryResponse.fromJson(response.data).items;
  }

  @override
  Future<void> addPromptToFavorite({required String id}) async {
    var response = await dio.post(
        '/api/v1/prompts/$id/favorite',
        options: Options(
          headers: headers,
        )
    );
  }

  @override
  Future<void> removePromptFromFavorite({required String id}) async {
    var response = await dio.delete(
        '/api/v1/prompts/$id/favorite',
        options: Options(
          headers: headers,
        )
    );
  }

  @override
  Future<void> createPrompt({required PromptModel prompt}) async {
    Map<String, dynamic> data = {
      "title": prompt.title,
      "category": prompt.category,
      "content": prompt.content,
      "description": prompt.description,
      "isPublic": prompt.isPublic,
      "language": prompt.language,
    };

    var response = await dio.post(
        '/api/v1/prompts',
        data: data,
        options: Options(
          headers: headers,
        )
    );
  }

  @override
  Future<void> deletePrompt({required String id}) async {
    var response = await dio.delete(
        '/api/v1/prompts/$id',
        options: Options(
          headers: headers,
        )
    );
  }

  @override
  Future<void> updatePrompt({required PromptModel prompt}) async {
    Map<String, dynamic> data = {
      "title": prompt.title,
      "category": prompt.category,
      "content": prompt.content,
      "description": prompt.description,
      "isPublic": prompt.isPublic,
      "language": prompt.language,
    };

    var response = await dio.patch(
        '/api/v1/prompts/${prompt.id}',
        data: data,
        options: Options(
          headers: headers,
        )
    );
  }
}
