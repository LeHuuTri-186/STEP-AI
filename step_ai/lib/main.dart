import 'package:flutter/material.dart';
import 'package:step_ai/features/chat/presentation/pages/chat_page.dart';
import 'package:step_ai/features/plan/presentation/pages/planPricingPage.dart';
import 'package:step_ai/features/prompt/presentation/pages/prompt_bottom_sheet.dart';

import 'config/routes/routes.dart';
import 'config/theme/app_theme.dart';


void main() {
  runApp(const MyApp());
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
    return MaterialApp(
      home: const PromptBottomSheet(),
      theme: AppTheme.light,
    );
  }
}
