import 'dart:async';

import 'package:step_ai/core/usecase/use_case.dart';
import 'package:step_ai/features/units_in_knowledge/domain/entity/unit_list.dart';
import 'package:step_ai/features/units_in_knowledge/domain/repository/unit_repository.dart';

class GetUnitListUsecase extends UseCase<UnitList, String> {
  UnitRepository _unitRepository;
  GetUnitListUsecase(this._unitRepository);
  @override
  Future<UnitList> call({required String params}) {
    return _unitRepository.getUnitList(params);
  }
}
