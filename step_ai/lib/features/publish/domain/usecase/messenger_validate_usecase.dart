import 'dart:async';
import 'dart:convert';

import 'package:step_ai/config/constants.dart';
import 'package:step_ai/core/api/api_service.dart';
import 'package:step_ai/core/data/local/securestorage/secure_storage_helper.dart';
import 'package:step_ai/core/usecase/use_case.dart';
import 'package:step_ai/features/publish/domain/params/messenger_validate_param.dart';
import 'package:step_ai/features/publish/domain/params/telegram_param.dart';
import 'package:step_ai/features/publish/domain/repository/publisher_repository.dart';
import 'package:step_ai/shared/usecases/refresh_kb_token_usecase.dart';

class MessengerValidateUseCase extends UseCase<void, MessengerValidateParam> {
  final RefreshKbTokenUseCase _refresher;
  final PublisherRepository _publisherRepository;

  MessengerValidateUseCase(this._refresher, this._publisherRepository);

  @override
  Future<void> call({required MessengerValidateParam params}) async {
    // TODO: implement call
    try {
      var request = await _publisherRepository.validateMessenger(params);
      return request;
    }
    catch (e) {
      if (e == 401) {
        try {
          int innerCode = await _refresher.call(params: null);
          if (innerCode == 200) return call(params: params);
        }
        catch (e) {
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