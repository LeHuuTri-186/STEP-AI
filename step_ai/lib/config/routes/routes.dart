import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/features/authentication/notifier/error_notifier.dart';
import 'package:step_ai/features/authentication/notifier/ui_notifier.dart';
import 'package:step_ai/features/authentication/presentation/pages/authenticate.dart';
import 'package:step_ai/features/chat/presentation/pages/chat_page.dart';
import 'package:step_ai/features/authentication/presentation/pages/email_page.dart';
import 'package:step_ai/features/authentication/presentation/pages/forgot_password_page.dart';
import 'package:step_ai/features/plan/presentation/pages/planPricingPage.dart';
import 'package:step_ai/features/prompt/presentation/pages/prompt_list.dart';
import 'package:step_ai/features/authentication/presentation/pages/sign_in_page.dart';

import '../../features/authentication/presentation/pages/sign_up_page.dart';
import '../../features/personal/presentation/pages/personal_page.dart';


class Routes {
  Routes._();

  //static variables
  static const String splash = '/splash';
  static const String chat = '/chat';
  static const String personal = '/personal';
  static const String email = '/email';
  static const String planAndPricing = "/planAndPricing";
  static const String signIn = "/signIn";
  static const String signUp = "/signUp";
  static const String promptList = "/promptList";
  static const String forgotPassword = "/resetPassword";

  static final routes = <String, WidgetBuilder>{
    personal: (BuildContext context) => PersonalPage(),
    chat: (BuildContext context) => ChatPage(),
    email: (BuildContext context) => EmailPage(),
    planAndPricing: (BuildContext context) => PlanPricingPage(),

    // signIn: (BuildContext context) => SignInPage(),
    signIn: (BuildContext context) => Builder(
      builder: (context) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthenticateUINotifier()),
            ChangeNotifierProvider(create: (_) => AuthenticateErrorNotifier()),
          ],
          child: AuthenticateScreen(),
        );
      },
    ),
    signUp: (BuildContext context) => SignUpPage(),
    promptList: (BuildContext context) => PromptApp(),
    forgotPassword: (BuildContext context) => ForgotPasswordPage(),
  };
}