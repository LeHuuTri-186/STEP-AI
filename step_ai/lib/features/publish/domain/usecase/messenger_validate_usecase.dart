import 'dart:async';
import 'dart:convert';

import 'package:step_ai/config/constants.dart';
import 'package:step_ai/core/api/api_service.dart';
import 'package:step_ai/core/data/local/securestorage/secure_storage_helper.dart';
import 'package:step_ai/core/usecase/use_case.dart';
import 'package:step_ai/features/publish/domain/params/messenger_validate_param.dart';
import 'package:step_ai/features/publish/domain/params/telegram_param.dart';
import 'package:step_ai/shared/usecase/refresh_kb_token_usecase.dart';

class MessengerValidateUseCase extends UseCase<void, MessengerValidateParam>{
  final ApiService _rest = ApiService(Constant.kbApiUrl);
  final RefreshKbTokenUseCase _refresher;
  final SecureStorageHelper _storage;

  MessengerValidateUseCase(this._refresher, this._storage);
  @override
  Future<void> call({required MessengerValidateParam params}) async{
    // TODO: implement call
    String? kbAccessToken = await _storage.kbAccessToken;
    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $kbAccessToken',
      'Content-Type': 'application/json'
    };
    var body = {
      "botToken": params.botToken,
      "pageId": params.pageId,
      "appSecret": params.appSecret
    };

    var request = await _rest.post(
        Constant.messengerValidateEndpoint,
        headers: headers,
        body: body
    );
    String stream = await request.stream.bytesToString();
    print("Messenger validate: $stream");
    if (request.statusCode == 200) {
      return;
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
    print(request.statusCode);
    throw request.statusCode;
  }

}