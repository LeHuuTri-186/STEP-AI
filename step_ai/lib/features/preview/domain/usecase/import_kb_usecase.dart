import 'dart:async';
import 'dart:convert';

import 'package:step_ai/config/constants.dart';
import 'package:step_ai/core/api/api_service.dart';
import 'package:step_ai/core/data/local/securestorage/secure_storage_helper.dart';
import 'package:step_ai/core/usecase/use_case.dart';
import 'package:step_ai/features/preview/domain/params/import_kb_param.dart';
import 'package:step_ai/shared/usecase/refresh_kb_token_usecase.dart';

class ImportKbUseCase extends UseCase<int, ImportKbParam>{
  final ApiService _rest = ApiService(Constant.kbApiUrl);
  final RefreshKbTokenUseCase _refresher;
  final SecureStorageHelper _storage;

  ImportKbUseCase(this._refresher, this._storage);
  @override
  Future<int> call({required ImportKbParam params}) async{
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
    //refresh
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
      return -1;
    }

    // TODO: implement call
    throw UnimplementedError();
  }

}