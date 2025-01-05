import 'dart:async';

import 'package:step_ai/core/usecase/use_case.dart';
import 'package:step_ai/features/preview/domain/entity/preview_message.dart';
import 'package:step_ai/features/preview/domain/repository/kb_in_bot_repository.dart';
import 'package:step_ai/shared/usecases/refresh_kb_token_usecase.dart';

class RetrieveHistoryUseCase extends UseCase<List<PreviewMessage>, String>{
  final KbInBotRepository _kbInBotRepository;
  final RefreshKbTokenUseCase _refresher;

  RetrieveHistoryUseCase(this._kbInBotRepository, this._refresher);

  @override
  Future<List<PreviewMessage>> call({required String params}) async{

    try {
      print(params);
      return await _kbInBotRepository.retrieveHistory(params);
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
    throw -1;
  }
}