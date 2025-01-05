import 'dart:async';

import 'package:step_ai/core/usecases/use_case.dart';
import 'package:step_ai/shared/usecases/refresh_kb_token_usecase.dart';

import '../../data/models/bot_list_res_dto.dart';
import '../repository/bot_list_repository.dart';

class GetBotListUseCase extends UseCase<BotListResDto?, String?>{
  final BotListRepository _botListRepository;

  final RefreshKbTokenUseCase _refreshKbTokenUseCase;

  GetBotListUseCase(this._refreshKbTokenUseCase, this._botListRepository);

  @override
  Future<BotListResDto?> call({required String? params}) async{
    try {
      BotListResDto? bots = await _botListRepository.getBotList(params);
      return bots;
    }

    catch (e){
      //Unauthorized handle
      if (e == -1 || e == 401) {
        try {
          int code = await _refreshKbTokenUseCase.call(params: null);
          if (code == 200) {
            call(params: params);
          }
        } catch (e){
          rethrow;
        }
      }

      //Others
      else {
        rethrow;
      }
    }
  }

}