import 'dart:async';

import 'package:step_ai/core/usecase/use_case.dart';
import 'package:step_ai/shared/usecases/refresh_kb_token_usecase.dart';

import '../../data/models/bot_model.dart';
import '../repository/bot_list_repository.dart';

class CreateBotUseCase extends UseCase<int, BotModel> {
  final RefreshKbTokenUseCase _refreshUC;

  final BotListRepository _botListRepositoryImpl;


  CreateBotUseCase(this._refreshUC, this._botListRepositoryImpl);
  @override
  FutureOr<int> call({required BotModel params}) async {
    int statusCode = await _botListRepositoryImpl.createBot(params);
    if (statusCode == 401) {
      try {
        int code = await _refreshUC.call(params: null);
        if (code == 200){
          call(params: params);
        }
      } catch (e) {
        if (e == 401) {
          return 401;
        }
      }
    }
    return statusCode;
  }
}