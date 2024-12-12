import 'dart:async';

import 'package:step_ai/core/usecase/use_case.dart';
import 'package:step_ai/features/units_in_knowledge/domain/params/upload_web_param.dart';
import 'package:step_ai/features/units_in_knowledge/domain/repository/unit_repository.dart';

class UploadWebUsecase extends UseCase<void, UploadWebParam> {
  UnitRepository _unitRepository;
  UploadWebUsecase(this._unitRepository);
  @override
  Future<void> call({required UploadWebParam params}) {
    return _unitRepository.uploadWeb(params);
  }
}
