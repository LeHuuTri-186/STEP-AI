import 'dart:async';

import 'package:http/http.dart';
import 'package:step_ai/core/di/service_locator.dart';
import 'package:step_ai/features/authentication/domain/usecase/login_kb_usecase.dart';
import 'package:step_ai/features/authentication/domain/usecase/login_usecase.dart';
import 'package:step_ai/features/authentication/domain/usecase/logout_usecase.dart';
import 'package:step_ai/features/authentication/domain/usecase/register_usecase.dart';
import 'package:step_ai/features/authentication/domain/usecase/save_login_status_usecase.dart';
import 'package:step_ai/features/authentication/notifier/login_notifier.dart';
import 'package:step_ai/features/authentication/notifier/register_notifier.dart';
import 'package:step_ai/features/authentication/notifier/ui_notifier.dart';
import 'package:step_ai/features/chat/domain/usecase/ask_bot_usecase.dart';
import 'package:step_ai/features/chat/domain/usecase/create_thread_usecase.dart';
import 'package:step_ai/features/chat/domain/usecase/get_current_user_usecase.dart';

import 'package:step_ai/features/chat/domain/usecase/get_featured_prompts_usecase.dart';
import 'package:step_ai/features/chat/domain/usecase/get_prompt_list_usecase.dart';
import 'package:step_ai/features/chat/notifier/personal_assistant_notifier.dart';
import 'package:step_ai/features/chat/presentation/notifier/chat_bar_notifier.dart';
import 'package:step_ai/features/chat/presentation/notifier/prompt_list_notifier.dart';
import 'package:step_ai/features/chat/domain/usecase/get_history_conversation_list_usecase.dart';
import 'package:step_ai/features/chat/domain/usecase/get_messages_by_conversation_id_usecase.dart';
import 'package:step_ai/features/chat/domain/usecase/get_usage_token_usecase.dart';
import 'package:step_ai/features/chat/domain/usecase/send_message_usecase.dart';
import 'package:step_ai/features/chat/notifier/assistant_notifier.dart';
import 'package:step_ai/features/chat/notifier/chat_notifier.dart';
import 'package:step_ai/features/chat/notifier/history_conversation_list_notifier.dart';
import 'package:step_ai/features/preview/domain/usecase/get_kb_in_bot_usecase.dart';
import 'package:step_ai/features/preview/domain/usecase/import_kb_usecase.dart';
import 'package:step_ai/features/preview/domain/usecase/remove_kb_usecase.dart';
import 'package:step_ai/features/preview/presentation/notifier/preview_chat_notifier.dart';
import 'package:step_ai/features/knowledge_base/domain/usecase/add_knowledge_usecase.dart';
import 'package:step_ai/features/knowledge_base/domain/usecase/delete_knowledge_usecase.dart';
import 'package:step_ai/features/knowledge_base/domain/usecase/edit_knowledge_usecase.dart';
import 'package:step_ai/features/knowledge_base/domain/usecase/get_knowledge_list_usecase.dart';
import 'package:step_ai/features/knowledge_base/notifier/add_knowledge_dialog_notifier.dart';
import 'package:step_ai/features/knowledge_base/notifier/knowledge_notifier.dart';
import 'package:step_ai/features/publish/domain/usecase/get_published_usecase.dart';
import 'package:step_ai/features/publish/domain/usecase/messenger_publish_usecase.dart';
import 'package:step_ai/features/publish/domain/usecase/messenger_validate_usecase.dart';
import 'package:step_ai/features/publish/domain/usecase/slack_publish_usecase.dart';
import 'package:step_ai/features/publish/domain/usecase/slack_validate_usecase.dart';
import 'package:step_ai/features/publish/domain/usecase/telegram_disconnect_usecase.dart';
import 'package:step_ai/features/publish/domain/usecase/telegram_publish_usecase.dart';
import 'package:step_ai/features/publish/domain/usecase/telegram_validate_usecase.dart';
import 'package:step_ai/features/publish/presentation/notifier/publish_notifier.dart';
import 'package:step_ai/features/units_in_knowledge/domain/usecase/delete_unit_usecase.dart';
import 'package:step_ai/features/units_in_knowledge/domain/usecase/get_unit_list_usecase.dart';
import 'package:step_ai/features/units_in_knowledge/domain/usecase/update_status_unit_usecase.dart';
import 'package:step_ai/features/units_in_knowledge/domain/usecase/upload_confluence_usecase.dart';
import 'package:step_ai/features/units_in_knowledge/domain/usecase/upload_drive_usecae.dart';
import 'package:step_ai/features/units_in_knowledge/domain/usecase/upload_local_file_usecase.dart';
import 'package:step_ai/features/units_in_knowledge/domain/usecase/upload_slack_usecase.dart';
import 'package:step_ai/features/units_in_knowledge/domain/usecase/upload_web_usecase.dart';
import 'package:step_ai/features/units_in_knowledge/notifier/add_option_unit_notifier.dart';
import 'package:step_ai/features/units_in_knowledge/notifier/confluence_notifier.dart';
import 'package:step_ai/features/units_in_knowledge/notifier/cupertino_notifier.dart';
import 'package:step_ai/features/units_in_knowledge/notifier/drive_notifier.dart';
import 'package:step_ai/features/units_in_knowledge/notifier/edit_knowledge_dialog_notifier.dart';
import 'package:step_ai/features/units_in_knowledge/notifier/local_file_notifier.dart';
import 'package:step_ai/features/units_in_knowledge/notifier/slack_notifier.dart';
import 'package:step_ai/features/units_in_knowledge/notifier/unit_notifier.dart';
import 'package:step_ai/features/units_in_knowledge/notifier/web_notifier.dart';
import 'package:step_ai/features/plan/domain/usecases/get_subscription_usecase.dart';
import 'package:step_ai/features/plan/presentation/notifier/subscription_notifier.dart';

import '../../../../features/playground/domain/usecase/create_bot_usecase.dart';
import '../../../../features/playground/domain/usecase/delete_bot_usecase.dart';
import '../../../../features/playground/domain/usecase/get_bot_list_usecase.dart';
import '../../../../features/playground/domain/usecase/update_bot_usecase.dart';
import '../../../../features/playground/presentation/notifier/bot_list_notifier.dart';

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

    getIt.registerSingleton<PersonalAssistantNotifier>(
      PersonalAssistantNotifier(),
    );

    getIt.registerSingleton<BotListNotifier>(BotListNotifier(
      getIt<CreateBotUseCase>(),
      getIt<LogoutUseCase>(),
      getIt<GetBotListUseCase>(),
      getIt<DeleteBotUseCase>(),
      getIt<UpdateBotUseCase>(),
    ));
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
        getIt<PersonalAssistantNotifier>(),
        getIt<CreateThreadUseCase>(),
        getIt<AskBotUseCase>(),
        getIt<LogoutUseCase>(),
        getIt<GetCurrentUserUsecase>(),
      ),
    );

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
        getIt<UpdateStatusUnitUsecase>(),
        getIt<UploadLocalFileUsecase>(),
        getIt<UploadWebUsecase>(),
        getIt<UploadSlackUsecase>(),
        getIt<UploadDriveUsecae>(),
        getIt<UploadConfluenceUsecase>()));
    getIt.registerSingleton<AddOptionUnitNotifier>(AddOptionUnitNotifier());
    getIt.registerSingleton<EditKnowledgeDialogNotifier>(
        EditKnowledgeDialogNotifier());
    getIt.registerFactory<CupertinoNotifier>(() => CupertinoNotifier());
    //Unit options:-------------------------------------------------------------
    getIt.registerSingleton<LocalFileNotifier>(LocalFileNotifier());
    getIt.registerSingleton<WebNotifier>(WebNotifier());
    getIt.registerSingleton<DriveNotifier>(DriveNotifier());
    getIt.registerSingleton<ConfluenceNotifier>(ConfluenceNotifier());
    getIt.registerSingleton<SlackNotifier>(SlackNotifier());
    getIt.registerSingleton<PromptListNotifier>(PromptListNotifier(
        getIt<GetPromptListUseCase>(), getIt<GetFeaturedPromptUseCase>()));

    //Preview page:-------------------------------------------------------------
    getIt.registerSingleton<PreviewChatNotifier>(
      PreviewChatNotifier(
        getIt<PersonalAssistantNotifier>(),
        getIt<AskBotUseCase>(),
        getIt<CreateThreadUseCase>(),
        getIt<LogoutUseCase>(),
        getIt<GetKbInBotUseCase>(),
        getIt<GetKnowledgeListUsecase>(),
        getIt<ImportKbUseCase>(),
        getIt<RemoveKbUseCase>(),
      ),
    );

    //Publish page:-------------------------------------------------------------
    getIt.registerSingleton<PublishNotifier>(PublishNotifier(
      getIt<GetPublishedUseCase>(),
      getIt<LogoutUseCase>(),
      getIt<TelegramValidateUseCase>(),
      getIt<TelegramPublishUseCase>(),
      getIt<TelegramDisconnectUseCase>(),
      getIt<MessengerValidateUseCase>(),
      getIt<MessengerPublishUseCase>(),
      getIt<SlackValidateUseCase>(),
      getIt<SlackPublishUseCase>(),
    ));
    //Chat page:----------------------------------------------------------------

    getIt.registerSingleton<SubscriptionNotifier>(SubscriptionNotifier(
        getIt<LogoutUseCase>(), getIt<GetSubscriptionUsecase>()));
  }
}
