import 'dart:convert';

import 'package:step_ai/config/constants.dart';
import 'package:step_ai/core/api/api_service.dart';
import 'package:step_ai/core/data/local/securestorage/secure_storage_helper.dart';
import 'package:step_ai/features/chat/data/model/search_prompt_model.dart';
import 'package:step_ai/features/chat/domain/repository/slash_prompt_repository.dart';

import '../../domain/entity/slash_prompt.dart';
import '../../domain/entity/slash_prompt_list.dart';

class SlashPromptRepositoryImpl extends SlashPromptRepository {
  final SecureStorageHelper _secureStorageHelper;
  final ApiService api = ApiService(Constant.apiBaseUrl);

  SlashPromptRepositoryImpl(this._secureStorageHelper);
  @override
  Future<SlashPromptList?> getPromptList(String key) async {
    String endpoint = '${Constant.promptSearchBaseEndpoint}'
        '${Constant.promptSearchQuery}$key&'
        '${Constant.promptSearchLimit}5&'
        '${Constant.promptSearchIsPublic}true';

    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer ${await _secureStorageHelper.accessToken}'
    };

    var response = await api.get(endpoint, headers: headers);

    if (response.statusCode == 200) {
      var json = jsonDecode(await response.stream.bytesToString());
      var promptList = json['items'] as List;
      List<SearchPromptModel> prompts =
          promptList.map((i) => SearchPromptModel.fromJson(i)).toList();

      List<SlashPrompt> slashPrompts =
          prompts.map((i) => SlashPrompt.fromModel(i)).toList();

      SlashPromptList slashList = SlashPromptList(prompts: slashPrompts);
      return slashList;
    }
    throw (response.statusCode);
  }

  @override
  Future<List<SlashPrompt>?> getFeaturedPrompt({int offset = 3}) async {
    String endpoint = '${Constant.promptSearchBaseEndpoint}'
        '${Constant.promptSearchLimit}$offset&'
        '${Constant.promptSearchIsPublic}true';

    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer ${await _secureStorageHelper.accessToken}'
    };

    var response = await api.get(endpoint, headers: headers);

    if (response.statusCode == 200) {
      var json = jsonDecode(await response.stream.bytesToString());
      var promptList = json['items'] as List;

      List<SearchPromptModel> prompts =
      promptList.map((i) => SearchPromptModel.fromJson(i)).toList();

      List<SlashPrompt> slashPrompts =
      prompts.map((i) => SlashPrompt.fromModel(i)).toList();

      return slashPrompts;
    }

    throw (response.statusCode);
  }
}
