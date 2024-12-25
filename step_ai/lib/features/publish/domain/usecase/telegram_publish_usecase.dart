import 'dart:async';
import 'dart:convert';

import 'package:step_ai/config/constants.dart';
import 'package:step_ai/core/api/api_service.dart';
import 'package:step_ai/core/data/local/securestorage/secure_storage_helper.dart';
import 'package:step_ai/core/usecase/use_case.dart';
import 'package:step_ai/features/publish/domain/params/telegram_param.dart';
import 'package:step_ai/features/publish/domain/params/telegram_publish_param.dart';
import 'package:step_ai/shared/usecase/refresh_kb_token_usecase.dart';

class TelegramPublishUseCase extends UseCase<String, TelegramPublishParam>{
  final ApiService _rest = ApiService(Constant.kbApiUrl);
  final RefreshKbTokenUseCase _refresher;
  final SecureStorageHelper _storage;

  TelegramPublishUseCase(this._refresher, this._storage);
  @override
  Future<String> call({required TelegramPublishParam params}) async {
    // TODO: implement call
    String? kbAccessToken = await _storage.kbAccessToken;
    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $kbAccessToken',
      'Content-Type': 'application/json'
    };
    var body = {
      "botToken": params.botToken
    };

    var request = await _rest.post(
        Constant.telegramPublishEndpoint(params.assistant.id!),
        headers: headers,
        body: body
    );
    String stream = await request.stream.bytesToString();
    print("Telegram publish: $stream");
    if (request.statusCode == 200) {
      // ResponseData res = ResponseData.fromJson(jsonDecode(stream));
      return jsonDecode(stream)['redirect'];
    }

    if (request.statusCode == 401) {
      try {
        int innerCode = await _refresher.call(params: null);
        if (innerCode == 200) return call(params: params);
      }
      catch (e){
        rethrow;
      }
    }
    throw request.statusCode;
    throw UnimplementedError();
  }

}