import 'dart:async';

import 'package:step_ai/core/usecase/use_case.dart';
import 'package:step_ai/features/personal/data/models/bot_res_dto.dart';
import 'package:step_ai/features/personal/domain/repository/bot_list_repository.dart';
import 'package:step_ai/shared/usecases/refresh_kb_token_usecase.dart';

class DeleteBotUseCase extends UseCase<int, BotResDto>{
  final BotListRepository _botListRepository;

  final RefreshKbTokenUseCase _refreshKbTokenUseCase;

  DeleteBotUseCase(this._botListRepository, this._refreshKbTokenUseCase);

  @override
  FutureOr<int> call({required BotResDto params}) async{
    int code = await _botListRepository.deleteBot(params);
    if (code == 200) {
      //Done
      return 200;
    }
    if (code == 401){
      try {
        code = await _refreshKbTokenUseCase.call(params: null);
        if (code == 200) call(params: params);
      } catch (e) {
        rethrow;
      }
      return 401;
    }
    return 4000;
    // TODO: implement call
  }
}