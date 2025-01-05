import 'dart:async';
import 'dart:convert';

import 'package:step_ai/config/constants.dart';
import 'package:step_ai/core/api/api_service.dart';
import 'package:step_ai/core/data/local/securestorage/secure_storage_helper.dart';
import 'package:step_ai/core/usecase/use_case.dart';
import 'package:step_ai/features/publish/domain/params/messenger_publish_param.dart';
import 'package:step_ai/features/publish/domain/repository/publisher_repository.dart';
import 'package:step_ai/shared/usecases/refresh_kb_token_usecase.dart';

class MessengerPublishUseCase extends UseCase<String, MessengerPublishParam>{
  final RefreshKbTokenUseCase _refresher;
  final PublisherRepository _publisherRepository;

  MessengerPublishUseCase(this._refresher, this._publisherRepository);
  @override
  Future<String> call({required MessengerPublishParam params}) async {
    try {
      return await _publisherRepository.publishToMessenger(params);
    } catch (e) {
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