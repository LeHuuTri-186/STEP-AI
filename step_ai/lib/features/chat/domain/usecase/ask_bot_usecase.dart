import 'dart:async';

import 'package:step_ai/core/usecase/use_case.dart';
import 'package:step_ai/features/chat/domain/params/thread_chat_param.dart';
import 'package:step_ai/features/chat/domain/repository/bot_thread_repository.dart';
import 'package:step_ai/shared/usecase/refresh_kb_token_usecase.dart';

class AskBotUseCase extends UseCase<String, ThreadChatParam>{
  final RefreshKbTokenUseCase _refreshUC;

  final BotThreadRepository _botThreadRepositoryImpl;

  AskBotUseCase(this._refreshUC, this._botThreadRepositoryImpl);
  @override
  Future<String> call({required ThreadChatParam params}) async {
    // TODO: implement call
    try {
      String? response = await _botThreadRepositoryImpl.askBotInThread(params);
      return response;

    } catch (e){
      if (e == 401 || e == -1) {
        try {
          int code = await _refreshUC.call(params: null);
          if (code == 200){
            call(params: params);
          }
        } catch (innerError) {
          rethrow;
        }
      } else {

        rethrow;
      }
    }
    throw UnimplementedError();
  }

}