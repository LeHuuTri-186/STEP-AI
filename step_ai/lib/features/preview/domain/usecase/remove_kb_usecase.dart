import 'dart:async';

import 'package:step_ai/config/constants.dart';
import 'package:step_ai/core/api/api_service.dart';
import 'package:step_ai/core/usecase/use_case.dart';
import 'package:step_ai/features/preview/domain/params/remove_kb_param.dart';
import 'package:step_ai/features/preview/domain/repository/kb_in_bot_repository.dart';
import 'package:step_ai/shared/usecases/refresh_kb_token_usecase.dart';

class RemoveKbUseCase extends UseCase<int, RemoveKbParam> {
  final ApiService _rest = ApiService(Constant.kbApiUrl);
  final RefreshKbTokenUseCase _refresher;
  final KbInBotRepository _kbInBotRepository;

  RemoveKbUseCase(this._refresher, this._kbInBotRepository);
  @override
  Future<int> call({required RemoveKbParam params}) async{
    try {
      await _kbInBotRepository.removeKbInBot(params);
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