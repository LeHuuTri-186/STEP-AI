
import 'dart:async';

import 'package:step_ai/core/di/service_locator.dart';
import 'package:step_ai/features/authentication/domain/usecase/login_usecase.dart';
import 'package:step_ai/features/authentication/domain/usecase/logout_usecase.dart';
import 'package:step_ai/features/authentication/domain/usecase/register_usecase.dart';
import 'package:step_ai/features/authentication/domain/usecase/save_login_status_usecase.dart';
import 'package:step_ai/features/authentication/notifier/login_notifier.dart';
import 'package:step_ai/features/authentication/notifier/register_notifier.dart';
import 'package:step_ai/features/authentication/notifier/ui_notifier.dart';
import 'package:step_ai/features/chat/domain/usecase/get_prompt_list_usecase.dart';
import 'package:step_ai/features/chat/presentation/notifier/chat_bar_notifier.dart';
import 'package:step_ai/features/chat/presentation/notifier/prompt_list_notifier.dart';

class ProviderModule {
  static Future<void> configureStoreModuleInjection() async {
    // Providers:---------------------------------------------------------------

    // Authenticate:------------------------------------------------------------
    getIt.registerSingleton<LoginNotifier>(
        LoginNotifier(
          getIt<LoginUseCase>(),
          getIt<SaveLoginStatusUseCase>(),
        )
    );

    getIt.registerSingleton<AuthenticateUINotifier>(
      AuthenticateUINotifier(),
    );

    getIt.registerSingleton<RegisterNotifier>(
        RegisterNotifier(
            getIt<LoginUseCase>(), getIt<RegisterUseCase>(),
        )
    );

    //Slash prompts:------------------------------------------------------------
    getIt.registerSingleton<PromptListNotifier>(
      PromptListNotifier(
        getIt<GetPromptListUseCase>(),
      )
    );
    //Chat page:----------------------------------------------------------------
    getIt.registerSingleton<ChatBarNotifier>(
      ChatBarNotifier(
        getIt<LogoutUseCase>(),
      )
    );
  }
}
