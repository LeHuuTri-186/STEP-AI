import 'dart:async';

import 'package:step_ai/core/di/service_locator.dart';
import 'package:step_ai/features/authentication/domain/usecase/login_usecase.dart';
import 'package:step_ai/features/authentication/domain/usecase/register_usecase.dart';
import 'package:step_ai/features/authentication/domain/usecase/save_login_status_usecase.dart';
import 'package:step_ai/features/authentication/notifier/login_notifier.dart';
import 'package:step_ai/features/authentication/notifier/register_notifier.dart';
import 'package:step_ai/features/authentication/notifier/ui_notifier.dart';
import 'package:step_ai/features/chat/domain/usecase/get_history_conversation_list_usecase.dart';
import 'package:step_ai/features/chat/domain/usecase/get_messages_by_conversation_id_usecase.dart';
import 'package:step_ai/features/chat/domain/usecase/get_usage_token_usecase.dart';
import 'package:step_ai/features/chat/domain/usecase/send_message_usecase.dart';
import 'package:step_ai/features/chat/notifier/assistant_notifier.dart';
import 'package:step_ai/features/chat/notifier/chat_notifier.dart';
import 'package:step_ai/features/chat/notifier/history_conversation_list_notifier.dart';

class ProviderModule {
  static Future<void> configureStoreModuleInjection() async {
    // Providers:---------------------------------------------------------------

    // Authenticate:------------------------------------------------------------
    getIt.registerSingleton<LoginNotifier>(LoginNotifier(
      getIt<LoginUseCase>(),
      getIt<SaveLoginStatusUseCase>(),
    ));

    getIt.registerSingleton<AuthenticateUINotifier>(
      AuthenticateUINotifier(),
    );

    getIt.registerSingleton<RegisterNotifier>(RegisterNotifier(
      getIt<LoginUseCase>(),
      getIt<RegisterUseCase>(),
    ));

    //Assistants:---------------------------------------------------------------
    //Note: It must be registered before chatNotifier
    getIt.registerSingleton<AssistantNotifier>(
      AssistantNotifier(),
    );
    //HistoryConversationListNotifier:-----------------------------------------------------
    getIt.registerSingleton<HistoryConversationListNotifier>(
      HistoryConversationListNotifier(
          getIt<GetMessagesByConversationIdUsecase>(),getIt<GetHistoryConversationListUsecase>()),
    );
    //ChatNotifier:---------------------------------------------------------------------
    getIt.registerSingleton<ChatNotifier>(
      ChatNotifier(
          getIt<SendMessageUsecase>(),
          getIt<AssistantNotifier>(),
          getIt<HistoryConversationListNotifier>(),
          getIt<GetUsageTokenUsecase>()),
    );
  }
}
