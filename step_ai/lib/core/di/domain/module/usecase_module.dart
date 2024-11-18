import 'dart:async';

import 'package:step_ai/features/authentication/domain/repository/auth_secure_storage_repository.dart';
import 'package:step_ai/features/authentication/domain/repository/login_repository.dart';
import 'package:step_ai/features/authentication/domain/usecase/login_usecase.dart';
import 'package:step_ai/features/authentication/domain/usecase/register_usecase.dart';
import 'package:step_ai/features/authentication/domain/usecase/save_token_usecase.dart';

import '../../../../features/authentication/domain/repository/register_repository.dart';
import '../../../di/service_locator.dart';

class UseCaseModule {
  static Future<void> configureUseCaseModuleInjection() async {
    //token:--------------------------------------------------------------------
    getIt.registerSingleton<SaveTokenUseCase>(
      SaveTokenUseCase(getIt<AuthSecureStorageRepository>()),
    );

    //login:--------------------------------------------------------------------
    getIt.registerSingleton<LoginUseCase>(
      LoginUseCase(
          getIt<LoginRepository>(), getIt<AuthSecureStorageRepository>()
      ),
    );

    //Register:-----------------------------------------------------------------
    getIt.registerSingleton<RegisterUseCase>(
      RegisterUseCase(
          getIt<RegisterRepository>(), getIt<LoginUseCase>()
      ),
    );

  }
}