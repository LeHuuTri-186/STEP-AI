import 'dart:convert';

import 'package:step_ai/features/preview/domain/entity/kb_in_bot.dart';
import 'package:step_ai/features/preview/domain/entity/preview_message.dart';
import 'package:step_ai/features/preview/domain/params/import_kb_param.dart';
import 'package:step_ai/features/preview/domain/params/remove_kb_param.dart';
import 'package:step_ai/features/preview/domain/repository/kb_in_bot_repository.dart';

import '../../../../config/constants.dart';
import '../../../../core/api/api_service.dart';
import '../../../../core/data/local/securestorage/secure_storage_helper.dart';

class KbInBotRepositoryImpl extends KbInBotRepository {
  final ApiService _rest = ApiService(Constant.kbApiUrl);

  final SecureStorageHelper _storage;

  KbInBotRepositoryImpl(this._storage);
  @override
  Future<KbListInBot> getKbInBot(String botId) async{
    String? kbAccessToken = await _storage.kbAccessToken;
    // TODO: implement getKbInBot
    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $kbAccessToken'
    };

    var request = await _rest.get(
        '${Constant.botEndpoint}/$botId${Constant.kbInBotQuery}',
        headers: headers
    );
    String stream = await request.stream.bytesToString();
    if (request.statusCode == 200) {
      KbListInBot kb = KbListInBot.fromJson(jsonDecode(stream));
      return kb;
    }
    else {
      throw request.statusCode;
    }

  }

  @override
  Future<int> importKbInBot(ImportKbParam params) async{
    // TODO: implement importKbInBot
    String? kbAccessToken = await _storage.kbAccessToken;
    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $kbAccessToken'
    };

    var request = await _rest.post(
        '${Constant.botEndpoint}/${params.bot.id}/knowledges/${params.kb.id}',
        headers: headers
    );

    if (request.statusCode == 200) {
      String result = await request.stream.bytesToString();
      print("Result: $result");
      return request.statusCode;
    }
    else {
      throw request.statusCode;
    }
    throw UnimplementedError();
  }

  @override
  Future<int> removeKbInBot(RemoveKbParam params) async{
    // TODO: implement removeKbInBot
    // TODO: implement call
    String? kbAccessToken = await _storage.kbAccessToken;
    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $kbAccessToken'
    };

    var request = await _rest.delete(
        '${Constant.botEndpoint}/${params.bot.id}/knowledges/${params.kb.id}',
        headers: headers
    );

    if (request.statusCode == 200) {
      String result = await request.stream.bytesToString();
      print("Result: $result");
      return request.statusCode;
    }
    else {
      throw request.statusCode;
    }
    throw UnimplementedError();
  }

  @override
  Future<List<PreviewMessage>> retrieveHistory(String threadId) async{
    String? kbAccessToken = await _storage.kbAccessToken;
    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $kbAccessToken'
    };
    
    print('${Constant.botEndpoint}/thread/$threadId/messages',);
    var request = await _rest.get(
        '${Constant.botEndpoint}/thread/$threadId/messages',
        headers: headers
    );
    String stream  = await request.stream.bytesToString();
    final List<dynamic> parsedJson = jsonDecode(stream);
    final List<PreviewMessage> previewMessages = parsedJson.map((json) =>
        PreviewMessage.fromJson(json)).toList();

    return previewMessages;
  }

}