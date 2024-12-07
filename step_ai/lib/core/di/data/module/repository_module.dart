import 'dart:async';

import 'package:step_ai/core/data/local/securestorage/secure_storage_helper.dart';
import 'package:step_ai/core/data/local/sharedpref/shared_preferences_helper.dart';
import 'package:step_ai/features/authentication/data/repository/login_repository_impl.dart';
import 'package:step_ai/features/authentication/data/repository/logout_repository_impl.dart';
import 'package:step_ai/features/authentication/data/repository/register_repository_impl.dart';
import 'package:step_ai/features/authentication/domain/repository/login_repository.dart';
import 'package:step_ai/features/authentication/domain/repository/logout_repository.dart';
import 'package:step_ai/features/authentication/domain/repository/register_repository.dart';
import 'package:step_ai/features/chat/data/repository/slash_prompt_repository_impl.dart';
import 'package:step_ai/features/chat/domain/repository/slash_prompt_repository.dart';
import 'package:step_ai/features/chat/data/network/api_client_chat.dart';
import 'package:step_ai/features/chat/data/repository/conversation_repository_impl.dart';
import 'package:step_ai/features/chat/domain/repository/conversation_repository.dart';
import 'package:step_ai/features/knowledge_base/data/network/knowledge_api.dart';
import 'package:step_ai/features/knowledge_base/data/repository/knowledge_repository_impl.dart';
import 'package:step_ai/features/knowledge_base/domain/repository/knowledge_repository.dart';

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
    //Slash command:------------------------------------------------------------
    getIt.registerSingleton<SlashPromptRepository>(SlashPromptRepositoryImpl(
      getIt<SecureStorageHelper>(),
    ) as SlashPromptRepository);
    //Chat:---------------------------------------------------------------------
    getIt.registerSingleton<ConversationRepository>(
        ConversationRepositoryImpl(getIt<ApiClientChat>())
            as ConversationRepository);
    //Knowledge:----------------------------------------------------------------
    getIt.registerSingleton<KnowledgeRepository>(
        KnowledgeRepositoryImpl(getIt<KnowledgeApi>()) as KnowledgeRepository);
  }
}
