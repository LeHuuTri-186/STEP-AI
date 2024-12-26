import 'dart:async';
import 'dart:convert';

import 'package:step_ai/config/constants.dart';
import 'package:step_ai/core/api/api_service.dart';
import 'package:step_ai/core/data/local/securestorage/secure_storage_helper.dart';
import 'package:step_ai/core/usecase/use_case.dart';
import 'package:step_ai/features/publish/domain/params/slack_publish_param.dart';
import 'package:step_ai/shared/usecases/refresh_kb_token_usecase.dart';

class SlackPublishUseCase extends UseCase<String, SlackPublishParam>{
  final ApiService _rest = ApiService(Constant.kbApiUrl);
  final RefreshKbTokenUseCase _refresher;
  final SecureStorageHelper _storage;

  SlackPublishUseCase(this._refresher, this._storage);
  @override
  Future<String> call({required SlackPublishParam params}) async {
    // TODO: implement call
    String? kbAccessToken = await _storage.kbAccessToken;
    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $kbAccessToken',
      'Content-Type': 'application/json'
    };
    var body = {
      "botToken": params.botToken,
      "clientId": params.clientId,
      "clientSecret": params.clientSecret,
      "signingSecret": params.signingSecret
    };

    var request = await _rest.post(
        Constant.slackPublishEndpoint(params.assistant.id!),
        headers: headers,
        body: body
    );
    String stream = await request.stream.bytesToString();
    print("Slack publish: $stream");
    if (request.statusCode == 200) {
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
  }

}