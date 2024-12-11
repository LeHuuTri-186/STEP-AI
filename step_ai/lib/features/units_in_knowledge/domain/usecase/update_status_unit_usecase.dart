import 'dart:async';

import 'package:step_ai/core/usecase/use_case.dart';
import 'package:step_ai/features/units_in_knowledge/domain/params/delete_unit_param.dart';
import 'package:step_ai/features/units_in_knowledge/domain/params/update_status_unit_param.dart';
import 'package:step_ai/features/units_in_knowledge/domain/repository/unit_repository.dart';

class UpdateStatusUnitUsecase extends UseCase<void,UpdateStatusUnitParam>{
  UnitRepository _unitRepository;
  UpdateStatusUnitUsecase(this._unitRepository);
  @override
  Future<void> call({required UpdateStatusUnitParam params}) {
    return _unitRepository.updateStatusUnit(params);
  }
}