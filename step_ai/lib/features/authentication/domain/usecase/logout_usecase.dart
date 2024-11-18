import 'dart:async';

import 'package:step_ai/core/usecase/use_case.dart';
import 'package:step_ai/features/authentication/domain/repository/logout_repository.dart';
import 'package:step_ai/shared/business_logic/token_logic/domain/usecase/delete_token_usecase.dart';

import '../../../../config/constants.dart';

class LogoutUseCase extends UseCase<void, void>{
  final DeleteTokenUseCase _deleteTokenUseCase;
  final LogoutRepository _logoutRepository;

  LogoutUseCase(this._deleteTokenUseCase, this._logoutRepository);
  @override
  FutureOr<void> call({required void params}) async{
    int statusCode = await _logoutRepository.logout();
    if (statusCode == 401){
      await _deleteTokenUseCase.call(params: Constant.access);
      await _deleteTokenUseCase.call(params: Constant.refresh);
      return;
    }
    throw ('Error at logout use case');
  }
}