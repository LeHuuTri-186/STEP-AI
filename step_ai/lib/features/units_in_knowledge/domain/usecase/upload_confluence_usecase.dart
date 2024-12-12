import 'dart:async';

import 'package:step_ai/core/usecase/use_case.dart';
import 'package:step_ai/features/units_in_knowledge/domain/params/upload_confluence_param.dart';
import 'package:step_ai/features/units_in_knowledge/domain/repository/unit_repository.dart';

class UploadConfluenceUsecase extends UseCase<void, UploadConfluenceParam> {
  UnitRepository _unitRepository;
  UploadConfluenceUsecase(this._unitRepository);
  @override
  Future<void> call({required UploadConfluenceParam params}) {
    return _unitRepository.uploadConfluence(params);
  }
}
