import 'dart:async';

import 'package:dio/dio.dart';
import 'package:step_ai/core/usecase/use_case.dart';
import 'package:step_ai/features/authentication/domain/usecase/logout_usecase.dart';
import 'package:step_ai/features/units_in_knowledge/domain/params/delete_unit_param.dart';
import 'package:step_ai/features/units_in_knowledge/domain/repository/unit_repository.dart';
import 'package:step_ai/shared/usecases/refresh_kb_token_usecase.dart';

class DeleteUnitUsecase extends UseCase<void, DeleteUnitParam> {
  UnitRepository _unitRepository;
  RefreshKbTokenUseCase refreshKbTokenUseCase;
  LogoutUseCase logoutUseCase;
  DeleteUnitUsecase(
      this._unitRepository, this.refreshKbTokenUseCase, this.logoutUseCase);
  @override
  Future<void> call({required DeleteUnitParam params}) async {
    try {
      return await _unitRepository.deleteUnit(params);
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 401) {
          int isKBRefreshSuccess =
              await refreshKbTokenUseCase.call(params: null);
          if (isKBRefreshSuccess == 200) {
            return await call(params: params);
          }
          await logoutUseCase.call(params: null);
          rethrow;
        }
        //if no internet connection example
        rethrow;
      }
      print(e);
      rethrow;
    }
  }
}
