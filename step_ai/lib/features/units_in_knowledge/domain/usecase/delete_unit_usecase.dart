import 'dart:async';

import 'package:step_ai/core/usecase/use_case.dart';
import 'package:step_ai/features/units_in_knowledge/domain/params/delete_unit_param.dart';
import 'package:step_ai/features/units_in_knowledge/domain/repository/unit_repository.dart';

class DeleteUnitUsecase extends UseCase<void,DeleteUnitParam>{
  UnitRepository _unitRepository;
  DeleteUnitUsecase(this._unitRepository);
  @override
  Future<void> call({required DeleteUnitParam params}) {
    return _unitRepository.deleteUnit(params);
  }
}