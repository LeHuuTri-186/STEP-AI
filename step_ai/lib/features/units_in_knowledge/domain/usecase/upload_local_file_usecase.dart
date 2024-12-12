import 'dart:async';

import 'package:step_ai/core/usecase/use_case.dart';
import 'package:step_ai/features/units_in_knowledge/domain/params/upload_local_file_param.dart';
import 'package:step_ai/features/units_in_knowledge/domain/repository/unit_repository.dart';

class UploadLocalFileUsecase extends UseCase<void,UploadLocalFileParam>{
  UnitRepository _unitRepository;
  UploadLocalFileUsecase(this._unitRepository);
  @override
  Future<void> call({required UploadLocalFileParam params}) {
    return _unitRepository.uploadLocalFile(params);
  }

}