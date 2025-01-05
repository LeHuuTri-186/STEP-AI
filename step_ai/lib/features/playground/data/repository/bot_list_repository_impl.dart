import 'dart:convert';

import 'package:step_ai/config/constants.dart';
import 'package:step_ai/core/api/api_service.dart';
import 'package:step_ai/core/data/local/securestorage/secure_storage_helper.dart';

import '../../domain/repository/bot_list_repository.dart';
import '../models/bot_list_res_dto.dart';
import '../models/bot_model.dart';
import '../models/bot_res_dto.dart';

class BotListRepositoryImpl extends BotListRepository {
  final ApiService _restClient = ApiService(Constant.kbApiUrl);
  final SecureStorageHelper _secureStorageHelper;

  BotListRepositoryImpl(this._secureStorageHelper);
  @override
  Future<BotListResDto?> getBotList(String? query) async{
    String? kbAccessToken = await _secureStorageHelper.kbAccessToken;
    if (kbAccessToken == null) {
      throw -1;
    }

    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $kbAccessToken'
    };

    String finalQuery = query??"";
    var request = await _restClient.get(
      "${Constant.botGetEndpoint}=$finalQuery${Constant.botGetOrderSet}${Constant.botOffset}${Constant.botLimit}",
      headers: headers
    );

    if (request.statusCode == 200) {
      BotListResDto bots = BotListResDto.fromJson(
          jsonDecode(await request.stream.bytesToString())
      );
      return bots;
    } //
    else {
      print("Error + ${request.statusCode}: ${request.reasonPhrase}");
      throw request.statusCode;
    }
  }

  @override
  Future<int> createBot(BotModel bot) async{
    String? kbAccessToken = await _secureStorageHelper.kbAccessToken;
    if (kbAccessToken == null) {
      return 401;
    }
    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $kbAccessToken',
      'Content-Type': 'application/json'
    };
    var body = {
      "assistantName": bot.name,
      "instructions": "You are an assistant of the Jarvis system ...",
      "description": bot.description
    };

    var request = await _restClient.post(
      Constant.createBotEndpoint,
      body: body,
      headers: headers
    );

    if (request.statusCode == 201) {
      return 201;
    } else {
      print('Error ${request.statusCode} + ${request.reasonPhrase}');
      return request.statusCode;
    }
  }


  @override
  Future<int> deleteBot(BotResDto bot) async{
    String? kbAccessToken = await _secureStorageHelper.kbAccessToken;
    if (kbAccessToken == null) return 401;

    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $kbAccessToken'
    };

    var response = await _restClient.delete(
      "${Constant.deleteBotEndpoint}${bot.id}",
      headers: headers
    );

    if (response.statusCode == 200) {
      return 200;
    }
    else {
      print('Error ${response.statusCode} + ${response.reasonPhrase}');
      return response.statusCode;
    }
  }

  @override
  Future<int> updateBot(BotResDto bot) async{
    String? kbAccessToken = await _secureStorageHelper.kbAccessToken;
    if (kbAccessToken == null) return 401;

    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $kbAccessToken',
      'Content-Type': 'application/json'
    };
    var body = {
      "assistantName": bot.assistantName,
      "instructions": bot.instructions,
      "description": bot.description
    };
    
    var response = await _restClient.patch(
      '${Constant.updateBotEndpoint}${bot.id}',
      headers: headers,
      body: body
    );

    if (response.statusCode == 200) {
      return 200;
    }
    else {
      print('Error ${response.statusCode} + ${response.reasonPhrase}');
      return response.statusCode;
    }
  }
}