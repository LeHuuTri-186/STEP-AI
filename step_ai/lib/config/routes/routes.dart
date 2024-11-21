import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/core/di/service_locator.dart';

import 'package:step_ai/features/authentication/notifier/login_notifier.dart';
import 'package:step_ai/features/authentication/notifier/register_notifier.dart';
import 'package:step_ai/features/authentication/notifier/ui_notifier.dart';

import 'package:step_ai/features/authentication/presentation/pages/authenticate.dart';
import 'package:step_ai/features/chat/domain/usecase/get_prompt_list_usecase.dart';
import 'package:step_ai/features/chat/presentation/notifier/chat_bar_notifier.dart';
import 'package:step_ai/features/chat/presentation/notifier/prompt_list_notifier.dart';
import 'package:step_ai/features/chat/notifier/assistant_notifier.dart';
import 'package:step_ai/features/chat/notifier/history_conversation_list_notifier.dart';

import 'package:step_ai/features/chat/presentation/pages/chat_page.dart';

import 'package:step_ai/features/authentication/presentation/pages/email_page.dart';
import 'package:step_ai/features/authentication/presentation/pages/forgot_password_page.dart';

import 'package:step_ai/features/plan/presentation/pages/planPricingPage.dart';
import 'package:step_ai/features/prompt/presentation/pages/prompt_list.dart';

import '../../features/chat/notifier/chat_notifier.dart';
import '../../features/personal/presentation/pages/personal_page.dart';

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

  static final routes = <String, WidgetBuilder>{
    personal: (BuildContext context) => PersonalPage(),

    chat: (BuildContext context) =>
        Builder(
          builder: (context) {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider.value(value: getIt<ChatBarNotifier>()),
                ChangeNotifierProvider.value(value: getIt<PromptListNotifier>()),
                ChangeNotifierProvider.value(value: getIt<AssistantNotifier>()),
                ChangeNotifierProvider.value(value: getIt<ChatNotifier>()),
                ChangeNotifierProvider.value(value: getIt<HistoryConversationListNotifier>()),
              ],
              child: ChatPage(),
            );
          },
        ),
    email: (BuildContext context) => EmailPage(),
    planAndPricing: (BuildContext context) => PlanPricingPage(),

    // signIn: (BuildContext context) => SignInPage(),
    authenticate: (BuildContext context) =>
        Builder(
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
  };
}