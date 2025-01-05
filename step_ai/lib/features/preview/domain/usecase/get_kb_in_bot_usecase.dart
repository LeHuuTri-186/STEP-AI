import 'dart:async';
import 'dart:convert';

import 'package:step_ai/config/constants.dart';
import 'package:step_ai/core/api/api_service.dart';
import 'package:step_ai/core/data/local/securestorage/secure_storage_helper.dart';
import 'package:step_ai/core/di/service_locator.dart';
import 'package:step_ai/core/usecases/use_case.dart';
import 'package:step_ai/features/preview/domain/entity/kb_in_bot.dart';
import 'package:step_ai/features/preview/domain/repository/kb_in_bot_repository.dart';
import 'package:step_ai/shared/usecases/refresh_kb_token_usecase.dart';

class GetKbInBotUseCase extends UseCase<KbListInBot?, String>{
  final KbInBotRepository _kbInBotRepository;
  final RefreshKbTokenUseCase _refresher;

  GetKbInBotUseCase(this._kbInBotRepository, this._refresher);

  @override
  Future<KbListInBot?> call({required String params}) async{
    try {
      return await _kbInBotRepository.getKbInBot(params);
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
    // TODO: implement call

    throw UnimplementedError();
  }

}