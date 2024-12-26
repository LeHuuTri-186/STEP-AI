import 'dart:async';
import 'dart:convert';

import 'package:step_ai/config/constants.dart';
import 'package:step_ai/core/api/api_service.dart';
import 'package:step_ai/core/data/local/securestorage/secure_storage_helper.dart';
import 'package:step_ai/core/di/service_locator.dart';
import 'package:step_ai/core/usecase/use_case.dart';
import 'package:step_ai/features/preview/domain/entity/kb_in_bot.dart';
import 'package:step_ai/shared/usecases/refresh_kb_token_usecase.dart';

class GetKbInBotUseCase extends UseCase<KbListInBot?, String>{
  final ApiService _rest = ApiService(Constant.kbApiUrl);
  final RefreshKbTokenUseCase _refresher;
  final SecureStorageHelper _storage;

  GetKbInBotUseCase(this._refresher, this._storage);

  @override
  Future<KbListInBot?> call({required String params}) async{
    String? kbAccessToken = await _storage.kbAccessToken;
    // TODO: implement call
    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $kbAccessToken'
    };

    var request = await _rest.get(
        '${Constant.botEndpoint}/$params${Constant.kbInBotQuery}',
        headers: headers
    );

    if (request.statusCode == 200) {
      String stream = await request.stream.bytesToString();
      print("In bot: $stream");
      KbListInBot kb = KbListInBot.fromJson(jsonDecode(stream));
      return kb;
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
      return null;
    }

    throw UnimplementedError();
  }

}