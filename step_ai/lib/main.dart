import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:step_ai/features/authentication/domain/usecase/is_logged_in_usecase.dart';
import 'package:step_ai/features/authentication/presentation/pages/authenticate.dart';
import 'package:step_ai/features/chat/domain/usecase/get_usage_token_usecase.dart';
import 'package:step_ai/features/chat/notifier/chat_notifier.dart';
import 'package:step_ai/features/chat/notifier/history_conversation_list_notifier.dart';
import 'package:step_ai/features/chat/presentation/pages/chat_page.dart';
import 'package:step_ai/features/plan/presentation/pages/planPricingPage.dart';
import 'package:step_ai/features/prompt/presentation/pages/prompt_bottom_sheet.dart';

import 'config/theme/app_theme.dart';
import 'core/di/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ServiceLocator.configureDependencies();
  // FlutterSecureStorage.setMockInitialValues({});

  //Define first page:
  final IsLoggedInUseCase isLoggedInUseCase = getIt<IsLoggedInUseCase>();
  final isLoggedIn = await isLoggedInUseCase.call(params: null);
  final initialRoute = isLoggedIn ? Routes.chat : Routes.authenticate;
  final initialRoute1 = Routes.chat; //to test chat page

  if (isLoggedIn) {
    final ChatNotifier chatNotifier = getIt<ChatNotifier>();
    await chatNotifier.getNumberRestToken();
    final HistoryConversationListNotifier historyConversationListNotifier =
        getIt<HistoryConversationListNotifier>();
    await historyConversationListNotifier.getHistoryConversationList(100);
  }

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Step AI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      routes: Routes.routes,
      initialRoute: initialRoute,
    );
    // return MaterialApp(
    //   home: const PromptBottomSheet(),
    //   theme: AppTheme.light,
    // );
  }
}
