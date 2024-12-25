import 'dart:async';

import 'package:step_ai/core/data/local/securestorage/secure_storage_helper.dart';
import 'package:step_ai/core/data/local/sharedpref/shared_preferences_helper.dart';
import 'package:step_ai/features/authentication/domain/usecase/is_logged_in_usecase.dart';
import 'package:step_ai/features/authentication/domain/usecase/login_kb_usecase.dart';
import 'package:step_ai/features/authentication/domain/usecase/save_login_status_usecase.dart';
import 'package:step_ai/features/authentication/domain/repository/login_repository.dart';
import 'package:step_ai/features/authentication/domain/repository/logout_repository.dart';
import 'package:step_ai/features/authentication/domain/usecase/login_usecase.dart';
import 'package:step_ai/features/authentication/domain/usecase/logout_usecase.dart';
import 'package:step_ai/features/authentication/domain/usecase/register_usecase.dart';
import 'package:step_ai/features/chat/data/repository/bot_thread_repository_impl.dart';
import 'package:step_ai/features/chat/domain/repository/bot_thread_repository.dart';
import 'package:step_ai/features/chat/domain/repository/slash_prompt_repository.dart';
import 'package:step_ai/features/chat/domain/usecase/ask_bot_usecase.dart';
import 'package:step_ai/features/chat/domain/usecase/create_thread_usecase.dart';
import 'package:step_ai/features/chat/domain/usecase/get_featured_prompts_usecase.dart';
import 'package:step_ai/features/chat/domain/usecase/get_prompt_list_usecase.dart';
import 'package:step_ai/features/chat/domain/repository/conversation_repository.dart';
import 'package:step_ai/features/chat/domain/usecase/get_history_conversation_list_usecase.dart';
import 'package:step_ai/features/chat/domain/usecase/get_messages_by_conversation_id_usecase.dart';
import 'package:step_ai/features/chat/domain/usecase/get_usage_token_usecase.dart';
import 'package:step_ai/features/chat/domain/usecase/send_message_usecase.dart';
import 'package:step_ai/features/personal/domain/repository/bot_list_repository.dart';
import 'package:step_ai/features/personal/domain/usecase/create_bot_usecase.dart';
import 'package:step_ai/features/personal/domain/usecase/delete_bot_usecase.dart';
import 'package:step_ai/features/personal/domain/usecase/get_bot_list_usecase.dart';
import 'package:step_ai/features/personal/domain/usecase/update_bot_usecase.dart';
import 'package:step_ai/features/preview/domain/usecase/get_kb_in_bot_usecase.dart';
import 'package:step_ai/features/preview/domain/usecase/import_kb_usecase.dart';
import 'package:step_ai/features/preview/domain/usecase/remove_kb_usecase.dart';
import 'package:step_ai/features/publish/domain/usecase/get_published_usecase.dart';
import 'package:step_ai/features/publish/domain/usecase/telegram_disconnect_usecase.dart';
import 'package:step_ai/features/publish/domain/usecase/telegram_publish_usecase.dart';
import 'package:step_ai/features/publish/domain/usecase/telegram_validate_usecase.dart';
import 'package:step_ai/shared/usecase/refresh_kb_token_usecase.dart';
import 'package:step_ai/features/knowledge_base/domain/entity/knowledge.dart';
import 'package:step_ai/features/knowledge_base/domain/repository/knowledge_repository.dart';
import 'package:step_ai/features/knowledge_base/domain/usecase/add_knowledge_usecase.dart';
import 'package:step_ai/features/knowledge_base/domain/usecase/delete_knowledge_usecase.dart';
import 'package:step_ai/features/knowledge_base/domain/usecase/edit_knowledge_usecase.dart';
import 'package:step_ai/features/knowledge_base/domain/usecase/get_knowledge_list_usecase.dart';
import 'package:step_ai/features/units_in_knowledge/domain/params/update_status_unit_param.dart';
import 'package:step_ai/features/units_in_knowledge/domain/repository/unit_repository.dart';
import 'package:step_ai/features/units_in_knowledge/domain/usecase/delete_unit_usecase.dart';
import 'package:step_ai/features/units_in_knowledge/domain/usecase/get_unit_list_usecase.dart';
import 'package:step_ai/features/units_in_knowledge/domain/usecase/update_status_unit_usecase.dart';
import 'package:step_ai/features/units_in_knowledge/domain/usecase/upload_confluence_usecase.dart';
import 'package:step_ai/features/units_in_knowledge/domain/usecase/upload_drive_usecae.dart';
import 'package:step_ai/features/units_in_knowledge/domain/usecase/upload_local_file_usecase.dart';
import 'package:step_ai/features/units_in_knowledge/domain/usecase/upload_slack_usecase.dart';
import 'package:step_ai/features/units_in_knowledge/domain/usecase/upload_web_usecase.dart';
import 'package:step_ai/features/plan/domain/repository/subscription_repository.dart';
import 'package:step_ai/features/plan/domain/usecases/get_subscription_usecase.dart';
import 'package:step_ai/shared/usecases/refresh_token_usecase.dart';


import '../../../../features/authentication/domain/repository/register_repository.dart';
import '../../../di/service_locator.dart';

class UseCaseModule {
  static Future<void> configureUseCaseModuleInjection() async {
    //Refresh token:------------------------------------------------------------
    getIt.registerSingleton<RefreshTokenUseCase>(
      RefreshTokenUseCase(
        getIt<SecureStorageHelper>(),
      ),
    );

    //Bot login kb:
    getIt.registerSingleton<LoginKbUseCase>(
      LoginKbUseCase(
        getIt<SecureStorageHelper>(),
        getIt<RefreshTokenUseCase>(),
      ),
    );

    getIt.registerSingleton<RefreshKbTokenUseCase>(RefreshKbTokenUseCase(
        getIt<SecureStorageHelper>(),
        getIt<RefreshTokenUseCase>(),
        getIt<LoginKbUseCase>()));
    //login:--------------------------------------------------------------------
    getIt.registerSingleton<LoginUseCase>(
      LoginUseCase(
        getIt<LoginRepository>(),
        getIt<SecureStorageHelper>(),
        getIt<LoginKbUseCase>(),
      ),
    );

    getIt.registerSingleton<IsLoggedInUseCase>(
      IsLoggedInUseCase(
        getIt<LoginRepository>(),
      ),
    );

    getIt.registerSingleton<SaveLoginStatusUseCase>(SaveLoginStatusUseCase(
      getIt<LoginRepository>(),
    ));


    //Register:-----------------------------------------------------------------
    getIt.registerSingleton<RegisterUseCase>(
      RegisterUseCase(getIt<RegisterRepository>(), getIt<LoginUseCase>()),
    );

    //Logout:-------------------------------------------------------------------
    getIt.registerSingleton<LogoutUseCase>(LogoutUseCase(
      getIt<LogoutRepository>(),
      getIt<SharedPreferencesHelper>(),
      getIt<SecureStorageHelper>(),
    ));

    //Slash command:------------------------------------------------------------
    getIt.registerSingleton<GetPromptListUseCase>(GetPromptListUseCase(
      getIt<SlashPromptRepository>(),
      getIt<RefreshTokenUseCase>(),
      getIt<LogoutUseCase>(),
    ));

    getIt.registerSingleton<GetFeaturedPromptUseCase>(GetFeaturedPromptUseCase(
        getIt<SlashPromptRepository>(),
        getIt<RefreshTokenUseCase>(),
        getIt<LogoutUseCase>()));

    //Chat:---------------------------------------------------------------------
    getIt.registerSingleton<SendMessageUsecase>(
      SendMessageUsecase(
        getIt<ConversationRepository>(),
      ),
    );
    getIt.registerSingleton<GetMessagesByConversationIdUsecase>(
      GetMessagesByConversationIdUsecase(
        getIt<ConversationRepository>(),
      ),
    );
    getIt.registerSingleton<GetHistoryConversationListUsecase>(
      GetHistoryConversationListUsecase(
        getIt<ConversationRepository>(),
      ),
    );
    getIt.registerSingleton<GetUsageTokenUsecase>(
      GetUsageTokenUsecase(
        getIt<ConversationRepository>(),
      ),
    );

    //Bot:----------------------------------------------------------------------
    getIt.registerSingleton<CreateBotUseCase>(
      CreateBotUseCase(
          getIt<RefreshKbTokenUseCase>(), getIt<BotListRepository>()),
    );

    getIt.registerSingleton<GetBotListUseCase>(GetBotListUseCase(
        getIt<RefreshKbTokenUseCase>(), getIt<BotListRepository>()));

    getIt.registerSingleton<DeleteBotUseCase>(DeleteBotUseCase(
        getIt<BotListRepository>(), getIt<RefreshKbTokenUseCase>()));

    getIt.registerSingleton<UpdateBotUseCase>(UpdateBotUseCase(
        getIt<BotListRepository>(), getIt<RefreshKbTokenUseCase>()));

    getIt.registerSingleton<CreateThreadUseCase>(CreateThreadUseCase(
        getIt<RefreshKbTokenUseCase>(), getIt<BotThreadRepository>()));

    getIt.registerSingleton<AskBotUseCase>(AskBotUseCase(
        getIt<RefreshKbTokenUseCase>(), getIt<BotThreadRepository>()));

    getIt.registerSingleton<GetKbInBotUseCase>(
      GetKbInBotUseCase(getIt<RefreshKbTokenUseCase>(), getIt<SecureStorageHelper>())
    );
    getIt.registerSingleton<ImportKbUseCase>(
      ImportKbUseCase(getIt<RefreshKbTokenUseCase>(), getIt<SecureStorageHelper>())
    );

    getIt.registerSingleton<RemoveKbUseCase>(
        RemoveKbUseCase(getIt<RefreshKbTokenUseCase>(), getIt<SecureStorageHelper>())
    );

    getIt.registerSingleton<GetPublishedUseCase>(
      GetPublishedUseCase(getIt<RefreshKbTokenUseCase>(), getIt<SecureStorageHelper>())
    );

    getIt.registerSingleton<TelegramValidateUseCase>(
      TelegramValidateUseCase(getIt<RefreshKbTokenUseCase>(), getIt<SecureStorageHelper>()
      )
    );

    getIt.registerSingleton<TelegramPublishUseCase>(
      TelegramPublishUseCase(getIt<RefreshKbTokenUseCase>(), getIt<SecureStorageHelper>()
      )
    );

    getIt.registerSingleton<TelegramDisconnectUseCase>(
        TelegramDisconnectUseCase(getIt<RefreshKbTokenUseCase>(), getIt<SecureStorageHelper>()
        )
    );
    ///Knowledge base:-----------------------------------------------------------
    getIt.registerSingleton<GetKnowledgeListUsecase>(GetKnowledgeListUsecase(
      getIt<KnowledgeRepository>(),
      getIt<RefreshKbTokenUseCase>(),
      getIt<LogoutUseCase>(),
    ));

    getIt.registerSingleton<AddKnowledgeUsecase>(
      AddKnowledgeUsecase(
        getIt<KnowledgeRepository>(),
        getIt<RefreshKbTokenUseCase>(),
        getIt<LogoutUseCase>(),
      ),
    );
    getIt.registerSingleton<DeleteKnowledgeUsecase>(
      DeleteKnowledgeUsecase(
        getIt<KnowledgeRepository>(),
        getIt<RefreshKbTokenUseCase>(),
        getIt<LogoutUseCase>(),
      ),
    );
    getIt.registerSingleton<EditKnowledgeUsecase>(
      EditKnowledgeUsecase(
        getIt<KnowledgeRepository>(),
        getIt<RefreshKbTokenUseCase>(),
        getIt<LogoutUseCase>(),
      ),
    );

    ///Units:--------------------------------------------------------------------
    getIt.registerSingleton<GetUnitListUsecase>(
      GetUnitListUsecase(
        getIt<UnitRepository>(),
        getIt<RefreshKbTokenUseCase>(),
        getIt<LogoutUseCase>(),
      ),
    );
    getIt.registerSingleton<DeleteUnitUsecase>(
      DeleteUnitUsecase(
        getIt<UnitRepository>(),
        getIt<RefreshKbTokenUseCase>(),
        getIt<LogoutUseCase>(),
      ),
    );
    getIt.registerSingleton<UpdateStatusUnitUsecase>(UpdateStatusUnitUsecase(
      getIt<UnitRepository>(),
      getIt<RefreshKbTokenUseCase>(),
      getIt<LogoutUseCase>(),
    ));
    //Upload:-------------------------------------------------------------------
    getIt.registerSingleton<UploadLocalFileUsecase>(UploadLocalFileUsecase(
      getIt<UnitRepository>(),
      getIt<RefreshKbTokenUseCase>(),
      getIt<LogoutUseCase>(),
    ));
    getIt.registerSingleton<UploadWebUsecase>(UploadWebUsecase(
      getIt<UnitRepository>(),
      getIt<RefreshKbTokenUseCase>(),
      getIt<LogoutUseCase>(),
    ));
    getIt.registerSingleton<UploadSlackUsecase>(UploadSlackUsecase(
      getIt<UnitRepository>(),
      getIt<RefreshKbTokenUseCase>(),
      getIt<LogoutUseCase>(),
    ));
    getIt.registerSingleton<UploadDriveUsecae>(UploadDriveUsecae(
      getIt<UnitRepository>(),
      getIt<RefreshKbTokenUseCase>(),
      getIt<LogoutUseCase>(),
    ));
    getIt.registerSingleton<UploadConfluenceUsecase>(UploadConfluenceUsecase(
      getIt<UnitRepository>(),
      getIt<RefreshKbTokenUseCase>(),
      getIt<LogoutUseCase>(),
    ));
    getIt.registerSingleton<GetSubscriptionUsecase>(GetSubscriptionUsecase(
      getIt<SubscriptionRepository>(),
    ));
  }
}
