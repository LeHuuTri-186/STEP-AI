import 'dart:async';

import 'package:step_ai/core/usecase/use_case.dart';
import 'package:step_ai/features/personal/data/models/bot_res_dto.dart';
import 'package:step_ai/features/personal/domain/repository/bot_list_repository.dart';
import 'package:step_ai/shared/usecase/refresh_kb_token_usecase.dart';

class UpdateBotUseCase extends UseCase<int, BotResDto> {
  final BotListRepository _botListRepository;
  final RefreshKbTokenUseCase _refreshKbTokenUseCase;

  UpdateBotUseCase(this._botListRepository, this._refreshKbTokenUseCase);
  @override
  Future<int> call({required BotResDto params}) async{
    int code = await _botListRepository.updateBot(params);

    if (code == 200){
      return 200;
    }

    if (code == 401) {
      try {
        int innerCode = await _refreshKbTokenUseCase.call(params: null);
        if (innerCode == 200) return call(params: params);
      } catch (e) {
        rethrow;
      }
    }
    print(code);
    throw code;
  }
}