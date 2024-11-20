import 'dart:async';

import 'package:step_ai/core/usecase/use_case.dart';
import 'package:step_ai/features/authentication/domain/repository/login_repository.dart';

class SaveLoginStatusUseCase extends UseCase<void, bool>{
  final LoginRepository _loginRepository;
  SaveLoginStatusUseCase(this._loginRepository);

  @override
  FutureOr<void> call({required bool params}) {
    print('Login: $params');
    return _loginRepository.saveLoginStatus(params);
  }
}