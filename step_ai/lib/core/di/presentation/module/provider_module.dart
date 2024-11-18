
import 'dart:async';

import 'package:step_ai/core/di/service_locator.dart';
import 'package:step_ai/features/authentication/domain/usecase/login_usecase.dart';
import 'package:step_ai/features/authentication/domain/usecase/register_usecase.dart';
import 'package:step_ai/features/authentication/domain/usecase/save_token_usecase.dart';
import 'package:step_ai/features/authentication/notifier/auth_notifier.dart';
import 'package:step_ai/features/authentication/notifier/login_notifier.dart';
import 'package:step_ai/features/authentication/notifier/register_notifier.dart';
import 'package:step_ai/features/authentication/notifier/ui_notifier.dart';

class ProviderModule {
  static Future<void> configureStoreModuleInjection() async {
    // Providers:---------------------------------------------------------------

    // Authenticate:------------------------------------------------------------
    getIt.registerSingleton<AuthNotifier>(
      AuthNotifier(
          getIt<SaveTokenUseCase>()
      ),
    );

    getIt.registerSingleton<LoginNotifier>(
        LoginNotifier(
            getIt<SaveTokenUseCase>(),
            getIt<LoginUseCase>()
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
  }
}
