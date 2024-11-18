import 'dart:async';

import 'package:step_ai/core/data/local/securestorage/secure_storage_helper.dart';
import 'package:step_ai/core/data/local/sharedpref/shared_preferences_helper.dart';
import 'package:step_ai/features/authentication/data/repository/login_repository_impl.dart';
import 'package:step_ai/features/authentication/data/repository/logout_repository_impl.dart';
import 'package:step_ai/features/authentication/data/repository/register_repository_impl.dart';
import 'package:step_ai/features/authentication/domain/repository/login_repository.dart';
import 'package:step_ai/features/authentication/domain/repository/logout_repository.dart';
import 'package:step_ai/features/authentication/domain/repository/register_repository.dart';
import 'package:step_ai/features/chat/data/repository/conversation_repository_impl.dart';
import 'package:step_ai/features/chat/domain/repository/conversation_repository.dart';

import '../../service_locator.dart';

class RepositoryModule {
  static Future<void> configureRepositoryModuleInjection() async {
    // repository:--------------------------------------------------------------
    //Authenticate:-------------------------------------------------------------
    getIt.registerSingleton<LoginRepository>(LoginRepositoryImpl(
      getIt<SharedPreferencesHelper>(),
    ) as LoginRepository);

    getIt.registerSingleton<RegisterRepository>(
        RegisterRepositoryImpl() as RegisterRepository);

    getIt.registerSingleton<LogoutRepository>(
        LogoutRepositoryImpl(getIt<SecureStorageHelper>()) as LogoutRepository);
    //Chat:---------------------------------------------------------------------
    getIt.registerSingleton<ConversationRepository>(
        ConversationRepositoryImpl() as ConversationRepository);
  }
}
