import 'dart:async';

import 'package:step_ai/core/usecases/use_case.dart';
import 'package:step_ai/features/chat/domain/entity/thread_dto.dart';
import 'package:step_ai/features/chat/domain/repository/bot_thread_repository.dart';
import 'package:step_ai/shared/usecases/refresh_kb_token_usecase.dart';

class CreateThreadUseCase extends UseCase<ThreadDto?, String>{
  final RefreshKbTokenUseCase _refreshUC;

  final BotThreadRepository _botThreadRepositoryImpl;

  CreateThreadUseCase(this._refreshUC, this._botThreadRepositoryImpl);

  @override
  Future<ThreadDto?> call({required String params}) async{
    try {
      ThreadDto? thread = await _botThreadRepositoryImpl.createThread(params);
      print(thread!.threadName);
      return thread;

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
    // TODO: implement call
    throw UnimplementedError();
  }

}