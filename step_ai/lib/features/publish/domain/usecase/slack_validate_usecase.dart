import 'dart:async';

import 'package:step_ai/config/constants.dart';
import 'package:step_ai/core/api/api_service.dart';
import 'package:step_ai/core/data/local/securestorage/secure_storage_helper.dart';
import 'package:step_ai/core/usecase/use_case.dart';
import 'package:step_ai/features/publish/domain/params/slack_validate_param.dart';
import 'package:step_ai/shared/usecases/refresh_kb_token_usecase.dart';

class SlackValidateUseCase extends UseCase<void, SlackValidateParam>{
  final ApiService _rest = ApiService(Constant.kbApiUrl);
  final RefreshKbTokenUseCase _refresher;
  final SecureStorageHelper _storage;

  SlackValidateUseCase(this._refresher, this._storage);
  @override
  Future<void> call({required SlackValidateParam params}) async{
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
        Constant.slackValidateEndpoint,
        headers: headers,
        body: body
    );
    String stream = await request.stream.bytesToString();
    print("Slack validate: $stream");
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
    throw request.statusCode;
  }

}