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
import 'package:step_ai/features/chat/domain/usecase/get_history_conversation_list_usecase.dart';
import 'package:step_ai/features/chat/domain/usecase/get_messages_by_conversation_id_usecase.dart';
import 'package:step_ai/features/chat/domain/usecase/get_usage_token_usecase.dart';
import 'package:step_ai/features/chat/domain/usecase/send_message_usecase.dart';
import 'package:step_ai/features/chat/notifier/assistant_notifier.dart';
import 'package:step_ai/features/chat/notifier/chat_notifier.dart';
import 'package:step_ai/features/chat/notifier/history_conversation_list_notifier.dart';
import 'package:step_ai/features/knowledge_base/domain/usecase/add_knowledge_usecase.dart';
import 'package:step_ai/features/knowledge_base/domain/usecase/delete_knowledge_usecase.dart';
import 'package:step_ai/features/knowledge_base/domain/usecase/edit_knowledge_usecase.dart';
import 'package:step_ai/features/knowledge_base/domain/usecase/get_knowledge_list_usecase.dart';
import 'package:step_ai/features/knowledge_base/notifier/add_knowledge_dialog_notifier.dart';
import 'package:step_ai/features/knowledge_base/notifier/knowledge_notifier.dart';
import 'package:step_ai/features/units_in_knowledge/domain/entity/unit.dart';
import 'package:step_ai/features/units_in_knowledge/domain/usecase/delete_unit_usecase.dart';
import 'package:step_ai/features/units_in_knowledge/domain/usecase/get_unit_list_usecase.dart';
import 'package:step_ai/features/units_in_knowledge/domain/usecase/update_status_unit_usecase.dart';
import 'package:step_ai/features/units_in_knowledge/notifier/add_option_unit_notifier.dart';
import 'package:step_ai/features/units_in_knowledge/notifier/cupertino_notifier.dart';
import 'package:step_ai/features/units_in_knowledge/notifier/edit_knowledge_dialog_notifier.dart';
import 'package:step_ai/features/units_in_knowledge/notifier/unit_notifier.dart';

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
          getIt<GetHistoryConversationListUsecase>()),
    );
    //ChatNotifier:---------------------------------------------------------------------
    getIt.registerSingleton<ChatNotifier>(
      ChatNotifier(
        getIt<SendMessageUsecase>(),
        getIt<AssistantNotifier>(),
        getIt<HistoryConversationListNotifier>(),
        getIt<GetUsageTokenUsecase>(),
        getIt<GetMessagesByConversationIdUsecase>(),
      ),
    );

    //Slash prompts:------------------------------------------------------------
    getIt.registerSingleton<PromptListNotifier>(PromptListNotifier(
      getIt<GetPromptListUseCase>(),
    ));
    //Chat page:----------------------------------------------------------------
    getIt.registerSingleton<ChatBarNotifier>(ChatBarNotifier(
      getIt<LogoutUseCase>(),
    ));

    //Knowledge base:------------------------------------------------------------
    getIt.registerSingleton<KnowledgeNotifier>(KnowledgeNotifier(
        getIt<GetKnowledgeListUsecase>(),
        getIt<AddKnowledgeUsecase>(),
        getIt<DeleteKnowledgeUsecase>(),
        getIt<EditKnowledgeUsecase>()));
    getIt.registerSingleton<AddKnowledgeDialogNotifier>(
        AddKnowledgeDialogNotifier());
    //Units in knowledge:-------------------------------------------------------
    getIt.registerSingleton<UnitNotifier>(UnitNotifier(
        getIt<GetUnitListUsecase>(),
        getIt<DeleteUnitUsecase>(),
        getIt<UpdateStatusUnitUsecase>()));
    getIt.registerSingleton<AddOptionUnitNotifier>(AddOptionUnitNotifier());
    getIt.registerSingleton<EditKnowledgeDialogNotifier>(
        EditKnowledgeDialogNotifier());
    getIt.registerFactory<CupertinoNotifier>(() => CupertinoNotifier());
  }
}
