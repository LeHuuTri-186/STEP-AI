import 'dart:async';

import 'package:step_ai/config/constants.dart';
import 'package:step_ai/core/api/api_service.dart';
import 'package:step_ai/core/data/local/securestorage/secure_storage_helper.dart';
import 'package:step_ai/core/usecase/use_case.dart';
import 'package:step_ai/features/preview/domain/params/import_kb_param.dart';
import 'package:step_ai/features/preview/domain/params/remove_kb_param.dart';
import 'package:step_ai/shared/usecases/refresh_kb_token_usecase.dart';

class RemoveKbUseCase extends UseCase<int, RemoveKbParam> {
  final ApiService _rest = ApiService(Constant.kbApiUrl);
  final RefreshKbTokenUseCase _refresher;
  final SecureStorageHelper _storage;

  RemoveKbUseCase(this._refresher, this._storage);
  @override
  Future<int> call({required RemoveKbParam params}) async{
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
    throw UnimplementedError();
  }

}