import 'dart:async';

import 'package:step_ai/core/data/model/usage_token_model.dart';
import 'package:step_ai/core/usecase/use_case.dart';
import 'package:step_ai/features/email_composer/domain/repository/usage_repository.dart';

class GetUsageUsecase extends NoParamUseCase<UsageTokenModel> {

  final UsageRepository _repository;

  GetUsageUsecase({required UsageRepository repo}): _repository = repo;

  @override
  FutureOr<UsageTokenModel> call() {
    return _repository.getUsageToken();
  }
}