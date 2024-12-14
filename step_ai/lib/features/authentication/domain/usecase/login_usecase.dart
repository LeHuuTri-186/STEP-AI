import 'dart:async';

import 'package:step_ai/core/data/local/securestorage/secure_storage_helper.dart';
import 'package:step_ai/core/usecase/use_case.dart';
import 'package:step_ai/core/data/model/token_model.dart';
import 'package:step_ai/features/authentication/domain/param/login_param.dart';
import 'package:step_ai/features/authentication/domain/usecase/login_kb_usecase.dart';

import '../repository/login_repository.dart';

class LoginUseCase extends UseCase<void, LoginParam>{
  final LoginRepository _loginRepository;

  final SecureStorageHelper _secureStorageHelper;

  final LoginKbUseCase _loginKbUseCase;

  LoginUseCase(
      this._loginRepository, this._secureStorageHelper, this._loginKbUseCase);
  @override
  FutureOr<void> call({required LoginParam params}) async{
    TokenModel? token = await
        _loginRepository.login(params.email, params.password);

    if (token == null){
      throw ('422');
    }
    else {
      await _secureStorageHelper.saveAccessToken(token.accessToken);
      await _secureStorageHelper.saveRefreshToken(token.refreshToken);
      await _loginKbUseCase.call(params: null);
      print('Save done');
    }
  }
}