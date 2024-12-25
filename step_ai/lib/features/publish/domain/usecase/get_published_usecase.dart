import 'dart:async';
import 'dart:convert';

import 'package:step_ai/config/constants.dart';
import 'package:step_ai/core/api/api_service.dart';
import 'package:step_ai/core/data/local/securestorage/secure_storage_helper.dart';
import 'package:step_ai/core/usecase/use_case.dart';
import 'package:step_ai/features/chat/domain/entity/assistant.dart';
import 'package:step_ai/features/publish/domain/entity/telegram_publish.dart';
import 'package:step_ai/shared/usecase/refresh_kb_token_usecase.dart';

class GetPublishedUseCase extends UseCase<List<TelegramPublish>, Assistant> {
  final ApiService _rest = ApiService(Constant.kbApiUrl);
  final RefreshKbTokenUseCase _refresher;
  final SecureStorageHelper _storage;

  GetPublishedUseCase(this._refresher, this._storage);
  @override
  Future<List<TelegramPublish>> call({required Assistant params}) async{
    String? kbAccessToken = await _storage.kbAccessToken;
    // TODO: implement call
    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $kbAccessToken'
    };

    var request = await _rest.get(
        Constant.getPublishedEndpoint(params.id!),
        headers: headers
    );

    if (request.statusCode == 200) {
      String stream = await request.stream.bytesToString();
      print("Published: $stream");
      ResponseData res = ResponseData.fromJson(jsonDecode(stream));
      return res.items;
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
    else {
      return [];
    }

    throw UnimplementedError();
  }

}