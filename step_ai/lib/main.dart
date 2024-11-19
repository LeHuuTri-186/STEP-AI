import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/core/data/local/securestorage/secure_storage_helper.dart';
import 'package:step_ai/features/authentication/domain/usecase/is_logged_in_usecase.dart';
import 'package:step_ai/features/authentication/presentation/pages/authenticate.dart';
import 'package:step_ai/features/chat/presentation/pages/chat_page.dart';
import 'package:step_ai/features/plan/presentation/pages/planPricingPage.dart';
import 'package:step_ai/features/prompt/presentation/pages/prompt_bottom_sheet.dart';

import 'config/routes/routes.dart';
import 'config/theme/app_theme.dart';
import 'core/di/service_locator.dart';
import 'features/chat/domain/usecase/get_prompt_list_usecase.dart';
import 'features/chat/presentation/notifier/chat_bar_notifier.dart';
import 'features/chat/presentation/notifier/prompt_list_notifier.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await ServiceLocator.configureDependencies();
  FlutterSecureStorage.setMockInitialValues({});

  //Define first page:
  final IsLoggedInUseCase isLoggedInUseCase = getIt<IsLoggedInUseCase>();
  final isLoggedIn = await isLoggedInUseCase.call(params: null);
  final initialRoute = isLoggedIn ? Routes.chat : Routes.authenticate;

  // final helper = getIt<SecureStorageHelper>();
  // if(isLoggedIn) print(await helper.accessToken);

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Step AI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      routes: Routes.routes,
      initialRoute: initialRoute,
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: getIt<ChatBarNotifier>()),
          ChangeNotifierProvider.value(value: getIt<PromptListNotifier>()),
        ],
        child: ChatPage(),
      ),
    );
    // return MaterialApp(
    //   home: const PromptBottomSheet(),
    //   theme: AppTheme.light,
    // );
  }
}
