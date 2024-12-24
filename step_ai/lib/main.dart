import 'package:flutter/material.dart';

import 'package:flutter/rendering.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/core/data/local/securestorage/secure_storage_helper.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/config/enum/task_status.dart';
import 'package:step_ai/features/authentication/domain/usecase/is_logged_in_usecase.dart';
import 'package:step_ai/features/authentication/domain/usecase/save_login_status_usecase.dart';
import 'package:step_ai/features/chat/notifier/chat_notifier.dart';
import 'package:step_ai/features/chat/notifier/history_conversation_list_notifier.dart';
import 'package:step_ai/features/chat/notifier/personal_assistant_notifier.dart';
import 'package:step_ai/features/preview/presentation/notifier/preview_chat_notifier.dart';
import 'package:step_ai/features/knowledge_base/notifier/add_knowledge_dialog_notifier.dart';
import 'package:step_ai/features/knowledge_base/notifier/knowledge_notifier.dart';
import 'package:step_ai/features/prompt/presentation/state/prompt_view_provider.dart';
import 'package:step_ai/features/units_in_knowledge/notifier/add_option_unit_notifier.dart';
import 'package:step_ai/features/units_in_knowledge/notifier/confluence_notifier.dart';
import 'package:step_ai/features/units_in_knowledge/notifier/drive_notifier.dart';
import 'package:step_ai/features/units_in_knowledge/notifier/edit_knowledge_dialog_notifier.dart';
import 'package:step_ai/features/units_in_knowledge/notifier/local_file_notifier.dart';
import 'package:step_ai/features/units_in_knowledge/notifier/slack_notifier.dart';
import 'package:step_ai/features/units_in_knowledge/notifier/unit_notifier.dart';
import 'package:step_ai/features/units_in_knowledge/notifier/web_notifier.dart';

import 'config/routes/routes.dart';
import 'config/theme/app_theme.dart';
import 'core/di/service_locator.dart';

import 'features/personal/presentation/notifier/bot_list_notifier.dart';
import 'features/chat/notifier/assistant_notifier.dart';
import 'features/chat/presentation/notifier/chat_bar_notifier.dart';
import 'features/chat/presentation/notifier/prompt_list_notifier.dart';
import 'features/prompt/presentation/state/form_model/form_provider.dart';
import 'features/prompt/presentation/state/private_prompt/private_filter_provider.dart';
import 'features/prompt/presentation/state/private_prompt/private_view_provider.dart';
import 'features/prompt/presentation/state/public_prompt/public_filter_provider.dart';
import 'features/prompt/presentation/state/public_prompt/public_view_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  RequestConfiguration requestConfiguration = RequestConfiguration(
    testDeviceIds: ["448b50b89e91785ddbf4df161da40386"],
  );
  MobileAds.instance.updateRequestConfiguration(requestConfiguration);
  await ServiceLocator.configureDependencies();
  // FlutterSecureStorage.setMockInitialValues({});

  //Define first page:
  final IsLoggedInUseCase isLoggedInUseCase = getIt<IsLoggedInUseCase>();
  final SaveLoginStatusUseCase saveLoginStatusUseCase =
      getIt<SaveLoginStatusUseCase>();
  final ChatNotifier chatNotifier = getIt<ChatNotifier>();
  final HistoryConversationListNotifier historyConversationListNotifier =
      getIt<HistoryConversationListNotifier>();
  var isLoggedIn = await isLoggedInUseCase.call(params: null);
  
  if (isLoggedIn) {
    try {
      await chatNotifier.getNumberRestToken();
      await historyConversationListNotifier.getHistoryConversationList();
    } catch (e) {
      print(e);
      if (e is TaskStatus && e == TaskStatus.UNAUTHORIZED) {
        isLoggedIn = false;
        saveLoginStatusUseCase.call(params: false);
      }
      if (e is TaskStatus && e == TaskStatus.NO_INTERNET) {
        print("------------------------------->No internet in main");
      }
    }
  }
  final initialRoute = isLoggedIn ? Routes.chat : Routes.authenticate;
  // final helper = getIt<SecureStorageHelper>();
  // if(isLoggedIn) print(await helper.accessToken);

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<PublicFilterState>()),
        ChangeNotifierProvider(create: (_) => getIt<PrivateFilterState>()),
        ChangeNotifierProvider(create: (_) => getIt<PublicViewState>()),
        ChangeNotifierProvider(create: (_) => getIt<PrivateViewState>()),
        ChangeNotifierProvider(create: (_) => getIt<FormModel>()),
        ChangeNotifierProvider(create: (_) => getIt<BotListNotifier>()),
        ChangeNotifierProvider(create: (_) => getIt<PromptViewState>()),
        ChangeNotifierProvider(create: (_) => getIt<PersonalAssistantNotifier>()),
        ChangeNotifierProvider(create: (_) => getIt<PreviewChatNotifier>()),
        ChangeNotifierProvider.value(value: getIt<ChatBarNotifier>()),
        ChangeNotifierProvider.value(value: getIt<PromptListNotifier>()),
        ChangeNotifierProvider.value(value: getIt<AssistantNotifier>()),
        ChangeNotifierProvider.value(value: getIt<ChatNotifier>()),
        ChangeNotifierProvider.value(
            value: getIt<HistoryConversationListNotifier>()),
        ChangeNotifierProvider.value(value: getIt<KnowledgeNotifier>()),
        ChangeNotifierProvider.value(
            value: getIt<AddKnowledgeDialogNotifier>()),
        ChangeNotifierProvider.value(value: getIt<UnitNotifier>()),
        ChangeNotifierProvider.value(value: getIt<AddOptionUnitNotifier>()),
        ChangeNotifierProvider.value(
            value: getIt<EditKnowledgeDialogNotifier>()),
        ChangeNotifierProvider.value(value: getIt<LocalFileNotifier>()),
        ChangeNotifierProvider.value(value: getIt<WebNotifier>()),
        ChangeNotifierProvider.value(value: getIt<SlackNotifier>()),
        ChangeNotifierProvider.value(value: getIt<DriveNotifier>()),
        ChangeNotifierProvider.value(value: getIt<ConfluenceNotifier>()),
      ],
      child: MaterialApp(
        title: 'STEP AI',
        theme: AppTheme.light,
        debugShowCheckedModeBanner: false,
        routes: Routes.routes,
        initialRoute: initialRoute,
      ),
    );
    // return MaterialApp(
    //   home: const PromptBottomSheet(),
    //   theme: AppTheme.light,
    // );
  }
}
