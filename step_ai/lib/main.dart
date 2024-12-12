import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/features/authentication/domain/usecase/is_logged_in_usecase.dart';
import 'package:step_ai/features/chat/notifier/chat_notifier.dart';
import 'package:step_ai/features/chat/notifier/history_conversation_list_notifier.dart';
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
  await ServiceLocator.configureDependencies();
  // FlutterSecureStorage.setMockInitialValues({});

  //Define first page:
  final IsLoggedInUseCase isLoggedInUseCase = getIt<IsLoggedInUseCase>();
  final isLoggedIn = await isLoggedInUseCase.call(params: null);
  final initialRoute = isLoggedIn ? Routes.chat : Routes.authenticate;

  if (isLoggedIn) {
    final ChatNotifier chatNotifier = getIt<ChatNotifier>();
    await chatNotifier.getNumberRestToken();
    final HistoryConversationListNotifier historyConversationListNotifier =
        getIt<HistoryConversationListNotifier>();
    await historyConversationListNotifier.getHistoryConversationList();
  }

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
        ChangeNotifierProvider(create: (_) => getIt<PromptViewState>()),
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
        ChangeNotifierProvider.value(value: getIt<EditKnowledgeDialogNotifier>()),
        
        ChangeNotifierProvider.value(value: getIt<LocalFileNotifier>()),
        ChangeNotifierProvider.value(value: getIt<WebNotifier>()),
        ChangeNotifierProvider.value(value: getIt<SlackNotifier>()),
        ChangeNotifierProvider.value(value: getIt<DriveNotifier>()),
        ChangeNotifierProvider.value(value: getIt<ConfluenceNotifier>()),
      ],
      child: MaterialApp(
        title: 'Step AI',
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
