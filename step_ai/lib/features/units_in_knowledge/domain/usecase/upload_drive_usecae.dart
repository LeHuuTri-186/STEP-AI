import 'dart:async';

import 'package:step_ai/core/usecase/use_case.dart';
import 'package:step_ai/features/units_in_knowledge/domain/params/upload_drive_param.dart';
import 'package:step_ai/features/units_in_knowledge/domain/repository/unit_repository.dart';

class UploadDriveUsecae extends UseCase<void, UploadDriveParam> {
  UnitRepository _unitRepository;
  UploadDriveUsecae(this._unitRepository);
  @override
  Future<void> call({required UploadDriveParam params}) {
    return _unitRepository.uploadDrive(params);
  }
}
