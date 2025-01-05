import 'dart:async';
import 'dart:convert';

import 'package:step_ai/config/constants.dart';
import 'package:step_ai/core/api/api_service.dart';
import 'package:step_ai/core/data/local/securestorage/secure_storage_helper.dart';
import 'package:step_ai/core/usecases/use_case.dart';
import 'package:step_ai/features/preview/domain/params/import_kb_param.dart';
import 'package:step_ai/features/preview/domain/repository/kb_in_bot_repository.dart';
import 'package:step_ai/shared/usecases/refresh_kb_token_usecase.dart';

class ImportKbUseCase extends UseCase<int, ImportKbParam>{
  final RefreshKbTokenUseCase _refresher;
  final KbInBotRepository _kbInBotRepository;

  ImportKbUseCase(this._refresher, this._kbInBotRepository);
  @override
  Future<int> call({required ImportKbParam params}) async{
    try {
      await _kbInBotRepository.importKbInBot(params);
    } catch (e) {
      //refresh
      if (e == 401) {
        try {
          int innerCode = await _refresher.call(params: null);
          if (innerCode == 200) return call(params: params);
        }
        catch (e){
          rethrow;
        }
      }
      else {
        rethrow;
      }
    }
    return 200;
  }
}