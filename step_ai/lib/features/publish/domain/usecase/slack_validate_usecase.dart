import 'dart:async';

import 'package:step_ai/config/constants.dart';
import 'package:step_ai/core/api/api_service.dart';
import 'package:step_ai/core/data/local/securestorage/secure_storage_helper.dart';
import 'package:step_ai/core/usecases/use_case.dart';
import 'package:step_ai/features/publish/domain/params/slack_validate_param.dart';
import 'package:step_ai/features/publish/domain/repository/publisher_repository.dart';
import 'package:step_ai/shared/usecases/refresh_kb_token_usecase.dart';

class SlackValidateUseCase extends UseCase<void, SlackValidateParam>{
  final RefreshKbTokenUseCase _refresher;
  final PublisherRepository _publisherRepository;


  SlackValidateUseCase(this._refresher, this._publisherRepository);
  @override
  Future<void> call({required SlackValidateParam params}) async{
    try {
      return await _publisherRepository.validateSlack(params);
    } catch (e){
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