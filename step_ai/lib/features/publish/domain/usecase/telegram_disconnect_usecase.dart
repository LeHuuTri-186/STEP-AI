import 'dart:async';

import 'package:step_ai/config/constants.dart';
import 'package:step_ai/core/api/api_service.dart';
import 'package:step_ai/core/data/local/securestorage/secure_storage_helper.dart';
import 'package:step_ai/core/usecase/use_case.dart';
import 'package:step_ai/features/publish/domain/params/disconnector_param.dart';
import 'package:step_ai/shared/usecase/refresh_kb_token_usecase.dart';

class TelegramDisconnectUseCase extends UseCase<void, DisconnectorParam> {
  final ApiService _rest = ApiService(Constant.kbApiUrl);
  final RefreshKbTokenUseCase _refresher;
  final SecureStorageHelper _storage;

  TelegramDisconnectUseCase(this._refresher, this._storage);
  @override
  Future<void> call({required DisconnectorParam params}) async{
    String? kbAccessToken = await _storage.kbAccessToken;
    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $kbAccessToken',
    };

    var request = await _rest.delete(
        Constant.disconnectBotEndpoint(params.assistant.id!, params.type),
        headers: headers,
    );
    String stream = await request.stream.bytesToString();
    print("${request.statusCode} - Disconnect: $stream");
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