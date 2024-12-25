import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/core/di/service_locator.dart';
import 'package:step_ai/features/email_composer/presentation/pages/email_composer.dart';
import 'package:step_ai/lib/features/chat/notifier/history_conversation_list_notifier.dart';

import 'package:step_ai/features/authentication/presentation/pages/authenticate.dart';
import 'package:step_ai/features/chat/domain/usecase/get_prompt_list_usecase.dart';
import 'package:step_ai/features/chat/notifier/personal_assistant_notifier.dart';
import 'package:step_ai/features/chat/presentation/notifier/chat_bar_notifier.dart';
import 'package:step_ai/features/chat/presentation/notifier/prompt_list_notifier.dart';
import 'package:step_ai/features/chat/notifier/assistant_notifier.dart';
import 'package:step_ai/features/chat/notifier/history_conversation_list_notifier.dart';

import 'package:step_ai/features/chat/presentation/pages/chat_page.dart';

import 'package:step_ai/features/authentication/presentation/pages/email_page.dart';
import 'package:step_ai/features/authentication/presentation/pages/forgot_password_page.dart';
import 'package:step_ai/features/personal/presentation/notifier/bot_list_notifier.dart';

import 'package:step_ai/features/preview/presentation/notifier/preview_chat_notifier.dart';
import 'package:step_ai/features/preview/presentation/pages/preview_chat_page.dart';
import 'package:step_ai/features/prompt/presentation/pages/prompt_list.dart';

import 'package:step_ai/features/chat/presentation/pages/chat_page.dart';

import 'package:step_ai/features/plan/presentation/notifier/subscription_notifier.dart';

import 'package:step_ai/features/plan/presentation/pages/plan_pricing_page.dart';
import 'package:step_ai/features/units_in_knowledge/presentation/pages/confluence_page.dart';
import 'package:step_ai/features/units_in_knowledge/presentation/pages/drive_page.dart';
import 'package:step_ai/features/units_in_knowledge/presentation/pages/local_file_page.dart';
import 'package:step_ai/features/units_in_knowledge/presentation/pages/slack_page.dart';
import 'package:step_ai/features/units_in_knowledge/presentation/pages/units_page.dart';
import 'package:step_ai/features/units_in_knowledge/presentation/pages/web_page.dart';

import '../../features/authentication/notifier/login_notifier.dart';
import '../../features/authentication/notifier/register_notifier.dart';
import '../../features/authentication/notifier/ui_notifier.dart';
import '../../features/chat/notifier/assistant_notifier.dart';
import '../../features/chat/notifier/chat_notifier.dart';
import '../../features/chat/notifier/history_conversation_list_notifier.dart';
import '../../features/chat/presentation/notifier/chat_bar_notifier.dart';
import '../../features/chat/presentation/notifier/prompt_list_notifier.dart';
import '../../features/personal/presentation/pages/playground_page.dart';

class Routes {
  Routes._();

  //static variables
  static const String splash = '/splash';
  static const String chat = '/chat';
  static const String personal = '/personal';
  static const String email = '/email';
  static const String planAndPricing = "/planAndPricing";
  static const String authenticate = "/signIn";
  static const String promptList = "/promptList";
  static const String forgotPassword = "/resetPassword";
  static const String previewChat = "/previewChat";
  static const String unitsPage = "/unitsPage";
  //Page in unit
  static const String localFilePage = "/localFilePage";
  static const String webPage = "/webPage";
  static const String confluencePage = "/confluencePage";
  static const String drivePage = "/drivePage";
  static const String slackPage = "/slackPage";

  static final routes = <String, WidgetBuilder>{
    personal: (BuildContext context) => Builder(builder: (context) {
          return const PlaygroundPage();
        }),

    chat: (BuildContext context) => MultiProvider(providers: [
          ChangeNotifierProvider.value(value: getIt<ChatBarNotifier>()),
          ChangeNotifierProvider.value(value: getIt<PromptListNotifier>()),
          ChangeNotifierProvider.value(value: getIt<AssistantNotifier>()),
          ChangeNotifierProvider.value(value: getIt<ChatNotifier>()),
          ChangeNotifierProvider.value(
              value: getIt<HistoryConversationListNotifier>()),
        ], child: const ChatPage()),
    unitsPage: (BuildContext context) => UnitsPage(),
    planAndPricing: (BuildContext context) => Builder(builder: (context) {
          return MultiProvider(providers: [
            ChangeNotifierProvider.value(
                value: getIt<HistoryConversationListNotifier>()),
            ChangeNotifierProvider.value(value: getIt<ChatNotifier>()),
            ChangeNotifierProvider.value(value: getIt<SubscriptionNotifier>()),
          ], child: const PlanPricingPage());
        }),

    // signIn: (BuildContext context) => SignInPage(),
    authenticate: (BuildContext context) => Builder(
          builder: (context) {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => AuthenticateUINotifier()),
                ChangeNotifierProvider.value(value: getIt<LoginNotifier>()),
                ChangeNotifierProvider.value(value: getIt<RegisterNotifier>()),
              ],
              child: AuthenticateScreen(),
            );
          },
        ),
    promptList: (BuildContext context) => PromptApp(),
    forgotPassword: (BuildContext context) => ForgotPasswordPage(),
    previewChat:(BuildContext context) => Builder(
      builder: (context) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: getIt<ChatBarNotifier>()),
            ChangeNotifierProvider.value(value: getIt<PersonalAssistantNotifier>()),
            ChangeNotifierProvider.value(value: getIt<PreviewChatNotifier>()),
          ],
          child: const PreviewChatPage(),
        );
      },
    ),
    localFilePage: (BuildContext context) => LocalFilePage(),
    webPage: (BuildContext context) => WebPage(),
    slackPage: (BuildContext context) => SlackPage(),
    confluencePage: (BuildContext context) => ConfluencePage(),
    drivePage: (BuildContext context) => DrivePage(),
    email: (BuildContext context) => const EmailComposer(),
  };
}
