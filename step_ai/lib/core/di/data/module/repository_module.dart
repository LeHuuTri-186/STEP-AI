import 'dart:async';

import 'package:step_ai/features/authentication/data/repository/auth_secure_storage_impl.dart';
import 'package:step_ai/features/authentication/data/repository/login_repository_impl.dart';
import 'package:step_ai/features/authentication/domain/repository/auth_secure_storage_repository.dart';
import 'package:step_ai/features/authentication/domain/repository/login_repository.dart';

import '../../service_locator.dart';


class RepositoryModule {
  static Future<void> configureRepositoryModuleInjection() async {
    // repository:--------------------------------------------------------------
   getIt.registerSingleton<LoginRepository>(
       LoginRepositoryImpl() as LoginRepository);

   getIt.registerSingleton<AuthSecureStorageRepository>(
       AuthSecureStorageImpl() as AuthSecureStorageRepository);

  }
}