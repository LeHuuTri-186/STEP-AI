import 'dart:async';

import 'package:step_ai/core/data/local/securestorage/secure_storage_helper.dart';
import 'package:step_ai/core/data/local/sharedpref/shared_preferences_helper.dart';
import 'package:step_ai/features/authentication/domain/usecase/is_logged_in_usecase.dart';
import 'package:step_ai/features/authentication/domain/usecase/save_login_status_usecase.dart';
import 'package:step_ai/features/authentication/domain/repository/login_repository.dart';
import 'package:step_ai/features/authentication/domain/repository/logout_repository.dart';
import 'package:step_ai/features/authentication/domain/usecase/login_usecase.dart';
import 'package:step_ai/features/authentication/domain/usecase/logout_usecase.dart';
import 'package:step_ai/features/authentication/domain/usecase/register_usecase.dart';
import 'package:step_ai/features/chat/domain/repository/slash_prompt_repository.dart';
import 'package:step_ai/features/chat/domain/usecase/get_prompt_list_usecase.dart';
import 'package:step_ai/features/chat/domain/repository/conversation_repository.dart';
import 'package:step_ai/features/chat/domain/usecase/get_history_conversation_list_usecase.dart';
import 'package:step_ai/features/chat/domain/usecase/get_messages_by_conversation_id_usecase.dart';
import 'package:step_ai/features/chat/domain/usecase/get_usage_token_usecase.dart';
import 'package:step_ai/features/chat/domain/usecase/send_message_usecase.dart';
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
import 'package:step_ai/shared/usecase/refresh_token_usecase.dart';

import '../../../../features/authentication/domain/repository/register_repository.dart';
import '../../../di/service_locator.dart';

class UseCaseModule {
  static Future<void> configureUseCaseModuleInjection() async {
    //login:--------------------------------------------------------------------
    getIt.registerSingleton<LoginUseCase>(
      LoginUseCase(
        getIt<LoginRepository>(),
        getIt<SecureStorageHelper>(),
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

    //Refresh token:------------------------------------------------------------
    getIt.registerSingleton<RefreshTokenUseCase>(
      RefreshTokenUseCase(
        getIt<SecureStorageHelper>(),
      ),
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

    ///Knowledge base:-----------------------------------------------------------
    getIt.registerSingleton<GetKnowledgeListUsecase>(
      GetKnowledgeListUsecase(
        getIt<KnowledgeRepository>(),
      ),
    );
    getIt.registerSingleton<AddKnowledgeUsecase>(
      AddKnowledgeUsecase(
        getIt<KnowledgeRepository>(),
      ),
    );
    getIt.registerSingleton<DeleteKnowledgeUsecase>(
      DeleteKnowledgeUsecase(
        getIt<KnowledgeRepository>(),
      ),
    );
    getIt.registerSingleton<EditKnowledgeUsecase>(
      EditKnowledgeUsecase(
        getIt<KnowledgeRepository>(),
      ),
    );

    ///Units:--------------------------------------------------------------------
    getIt.registerSingleton<GetUnitListUsecase>(
      GetUnitListUsecase(
        getIt<UnitRepository>(),
      ),
    );
    getIt.registerSingleton<DeleteUnitUsecase>(
      DeleteUnitUsecase(
        getIt<UnitRepository>(),
      ),
    );
    getIt.registerSingleton<UpdateStatusUnitUsecase>(
        UpdateStatusUnitUsecase(getIt<UnitRepository>()));
    //Upload:-------------------------------------------------------------------
    getIt.registerSingleton<UploadLocalFileUsecase>(
        UploadLocalFileUsecase(getIt<UnitRepository>()));
    getIt.registerSingleton<UploadWebUsecase>(
        UploadWebUsecase(getIt<UnitRepository>()));
    getIt.registerSingleton<UploadSlackUsecase>(
        UploadSlackUsecase(getIt<UnitRepository>()));
    getIt.registerSingleton<UploadDriveUsecae>(
        UploadDriveUsecae(getIt<UnitRepository>()));
    getIt.registerSingleton<UploadConfluenceUsecase>(
        UploadConfluenceUsecase(getIt<UnitRepository>()));
  }
}
