import 'dart:async';

import 'package:step_ai/core/usecase/use_case.dart';
import 'package:step_ai/features/authentication/data/models/token_model.dart';
import 'package:step_ai/features/authentication/domain/param/login_param.dart';
import 'package:step_ai/features/authentication/domain/param/save_token_param.dart';
import 'package:step_ai/features/authentication/domain/repository/auth_secure_storage_repository.dart';
import 'package:step_ai/features/authentication/domain/usecase/save_token_usecase.dart';

import '../../../../config/constants.dart';
import '../repository/login_repository.dart';

class LoginUseCase extends UseCase<void, LoginParam>{
  final LoginRepository _loginRepository;

  final AuthSecureStorageRepository _authSecureStorageRepository;

  LoginUseCase(this._loginRepository, this._authSecureStorageRepository);
  @override
  FutureOr<void> call({required LoginParam params}) async{
    TokenModel? token = await
        _loginRepository.login(params.email, params.password);
    if (token == null){
      throw ('422');
    }
    else {
      await _authSecureStorageRepository.saveToken(
          Constant.access, token.accessToken);

      await _authSecureStorageRepository.saveToken(
          Constant.refresh, token.refreshToken);
      print('Save done');
    }
  }
}