import 'dart:async';

import 'package:step_ai/features/authentication/data/repository/auth_secure_storage_impl.dart';
import 'package:step_ai/features/authentication/data/repository/login_repository_impl.dart';
import 'package:step_ai/features/authentication/data/repository/logout_repository_impl.dart';
import 'package:step_ai/features/authentication/data/repository/register_repository_impl.dart';
import 'package:step_ai/features/authentication/domain/repository/auth_secure_storage_repository.dart';
import 'package:step_ai/features/authentication/domain/repository/login_repository.dart';
import 'package:step_ai/features/authentication/domain/repository/logout_repository.dart';
import 'package:step_ai/features/authentication/domain/repository/register_repository.dart';
import 'package:step_ai/features/authentication/domain/usecase/get_token_usecase.dart';

import '../../service_locator.dart';


class RepositoryModule {
  static Future<void> configureRepositoryModuleInjection() async {
    // repository:--------------------------------------------------------------
    //Authenticate:-------------------------------------------------------------
    getIt.registerSingleton<LoginRepository>(
       LoginRepositoryImpl() as LoginRepository);

    getIt.registerSingleton<AuthSecureStorageRepository>(
       AuthSecureStorageImpl() as AuthSecureStorageRepository);

    getIt.registerSingleton<RegisterRepository>(
     RegisterRepositoryImpl() as RegisterRepository);

    getIt.registerSingleton<LogoutRepository>(
      LogoutRepositoryImpl(
          getIt<AuthSecureStorageRepository>()) as LogoutRepository);
  }
}