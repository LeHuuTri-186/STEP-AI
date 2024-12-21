import 'dart:convert';

import 'package:step_ai/config/constants.dart';
import 'package:step_ai/core/api/api_service.dart';
import 'package:step_ai/core/data/local/securestorage/secure_storage_helper.dart';

import 'package:step_ai/features/chat/domain/entity/thread_dto.dart';
import 'package:step_ai/features/chat/domain/params/thread_chat_param.dart';
import 'package:step_ai/features/chat/domain/repository/bot_thread_repository.dart';

class BotThreadRepositoryImpl extends BotThreadRepository{
  final ApiService _restClient = ApiService(Constant.kbApiUrl);
  final SecureStorageHelper _secureStorageHelper;

  BotThreadRepositoryImpl(this._secureStorageHelper);
  @override
  Future<ThreadDto?> createThread(String? botId) async{
    // TODO: implement createThread
    String? kbAccessToken = await _secureStorageHelper.kbAccessToken;
    if (kbAccessToken == null) {
      throw -1;
    }

    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $kbAccessToken',
      'Content-Type': 'application/json'
    };

    var body = {
      "assistantId": botId,
      "firstMessage": ""
    };

    var request = await _restClient.post(
      Constant.createThreadEndpoint, headers: headers, body: body
    );

    if (request.statusCode == 201) {
      ThreadDto thread = ThreadDto.fromJson(
          jsonDecode(await request.stream.bytesToString())
      );
      return thread;
    } //
    else {
      print("Error + ${request.statusCode}: ${request.reasonPhrase}");
      throw request.statusCode;
    }
  }


  @override
  Future<int> getMessageHistory(String threadId) {
    // TODO: implement getMessageHistory
    throw UnimplementedError();
  }

  @override
  Future<String> askBotInThread(ThreadChatParam params) async {
    // TODO: implement askBotInThread
    String? kbAccessToken = await _secureStorageHelper.kbAccessToken;
    if (kbAccessToken == null) {
      throw -1;
    }

    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $kbAccessToken',
      'Content-Type': 'application/json'
    };

    var body = {
      "message": params.message,
      "openAiThreadId": params.openAiThreadId,
      "additionalInstruction": params.additionalInstruction ?? "",
    };
    var request = await _restClient.post(
        '${Constant.askBotInThreadEndpoint}/${params.assistantId}/ask',
        headers: headers,
        body: body
    );
    String res = await request.stream.bytesToString();
    print("Response: $res");
    return res;
  }
}