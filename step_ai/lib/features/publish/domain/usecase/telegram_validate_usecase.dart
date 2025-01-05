import 'dart:async';
import 'package:step_ai/core/usecases/use_case.dart';
import 'package:step_ai/features/publish/domain/params/telegram_param.dart';
import 'package:step_ai/features/publish/domain/repository/publisher_repository.dart';
import 'package:step_ai/shared/usecases/refresh_kb_token_usecase.dart';

class TelegramValidateUseCase extends UseCase<void, TelegramParam>{
  final RefreshKbTokenUseCase _refresher;
  final PublisherRepository _publisherRepository;

  TelegramValidateUseCase(this._refresher, this._publisherRepository);
  @override
  Future<void> call({required TelegramParam params}) async{
    try {
      return await _publisherRepository.validateTelegram(params);
    }
    catch (e){
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