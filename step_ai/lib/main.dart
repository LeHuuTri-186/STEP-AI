import 'package:flutter/material.dart';
import 'package:step_ai/features/prompt/presentation/pages/prompt_bottom_sheet.dart';

import 'config/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'core/di/service_locator.dart';
import 'features/prompt/di/presentation_injection/prompt_presentation_di.dart';
import 'features/prompt/presentation/state/prompt_view_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencyInjection();

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   title: 'Step AI',
    //   theme: ThemeData(
    //     primarySwatch: Colors.blue,
    //   ),
    //   debugShowCheckedModeBanner: false,
    //   routes: Routes.routes,
    //   initialRoute: Routes.signIn,
    //   home: const ChatPage(chatName: "Chat"),
    // );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<PromptViewState>()),
      ],
      child: MaterialApp(
        home: const PromptBottomSheet(),
        theme: AppTheme.light,
      ),
    );
  }
}
