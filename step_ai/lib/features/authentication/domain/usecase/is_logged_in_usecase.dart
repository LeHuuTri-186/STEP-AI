import 'dart:async';

import 'package:step_ai/core/usecases/use_case.dart';
import 'package:step_ai/features/authentication/domain/repository/login_repository.dart';

class IsLoggedInUseCase extends UseCase<bool, void> {
  final LoginRepository _loginRepository;

  IsLoggedInUseCase(this._loginRepository);

  @override
  Future<bool> call({required void params}) async {
    return await _loginRepository.isLoggedIn;
  }
}
