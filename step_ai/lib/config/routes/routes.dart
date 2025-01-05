import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/core/di/service_locator.dart';
import 'package:step_ai/features/email_composer/domain/usecase/compose_email_usecase.dart';
import 'package:step_ai/features/email_composer/presentation/notifier/email_composer_notifier.dart';
import 'package:step_ai/features/email_composer/presentation/notifier/usage_token_notifier.dart';
import 'package:step_ai/features/email_composer/presentation/pages/email_action.dart';
import 'package:step_ai/features/email_composer/presentation/pages/email_composer.dart';

import 'package:step_ai/features/authentication/presentation/pages/authenticate.dart';
import 'package:step_ai/features/chat/domain/usecase/get_prompt_list_usecase.dart';
import 'package:step_ai/features/chat/notifier/personal_assistant_notifier.dart';
import 'package:step_ai/features/chat/presentation/notifier/chat_bar_notifier.dart';
import 'package:step_ai/features/chat/presentation/notifier/prompt_list_notifier.dart';
import 'package:step_ai/features/chat/notifier/assistant_notifier.dart';
import 'package:step_ai/features/chat/notifier/history_conversation_list_notifier.dart';

import 'package:step_ai/features/chat/presentation/pages/chat_page.dart';

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
import '../../features/chat/notifier/chat_notifier.dart';
import '../../features/email_composer/presentation/notifier/ai_action_notifier.dart';
import '../../features/playground/presentation/pages/playground_page.dart';

class Routes {
  Routes._();

  //static variables
  static const String splash = '/splash';
  static const String chat = '/chat';
  static const String personal = '/personal';
  static const String email = '/email';
  static const String planAndPricing = "/pricing";
  static const String authenticate = "/sign-in";
  static const String previewChat = "/preview-chat";
  static const String unitsPage = "/units-page";
  //Page in unit
  static const String localFilePage = "/local-file-page";
  static const String webPage = "/web-page";
  static const String confluencePage = "/confluence-page";
  static const String drivePage = "/drive-page";
  static const String slackPage = "/slack-page";
  static const String aiAction = "/ai-action";

  static final routes = <String, WidgetBuilder>{
    personal: (BuildContext context) => Builder(builder: (context) {
          return const PlaygroundPage();
        }),

    chat: (BuildContext context) => MultiProvider(providers: [
      ChangeNotifierProvider.value(value: getIt<SubscriptionNotifier>()),
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
    email: (BuildContext context) => Builder(
      builder: (context) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: getIt<EmailComposerNotifier>()),
            ChangeNotifierProvider.value(value: getIt<UsageTokenNotifier>()),
          ],
          child: const EmailComposer(),
        );
      }
    ),
    aiAction: (BuildContext context) => Builder(
        builder: (context) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider.value(value: getIt<AiActionNotifier>()),
              ChangeNotifierProvider.value(value: getIt<UsageTokenNotifier>()),
            ],
            child: const EmailAction(),
          );
        }
    ),
  };
}
