import 'dart:async';

import 'package:step_ai/core/usecase/use_case.dart';
import 'package:step_ai/features/units_in_knowledge/domain/params/upload_slack_param.dart';
import 'package:step_ai/features/units_in_knowledge/domain/repository/unit_repository.dart';

class UploadSlackUsecase extends UseCase<void, UploadSlackParam> {
  UnitRepository _unitRepository;
  UploadSlackUsecase(this._unitRepository);
  @override
  Future<void> call({required UploadSlackParam params}) {
    return _unitRepository.uploadSlack(params);
  }
}
