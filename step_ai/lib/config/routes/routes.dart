import 'package:flutter/material.dart';
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
    personal: (BuildContext context) => const PersonalPage(),
    chat: (BuildContext context) => const ChatPage(),
    email: (BuildContext context) => const EmailPage(),
    planAndPricing: (BuildContext context) => const PlanPricingPage(),
    signIn: (BuildContext context) => const SignInPage(),
    signUp: (BuildContext context) => const SignUpPage(),
    promptList: (BuildContext context) => const PromptApp(),
    forgotPassword: (BuildContext context) => const ForgotPasswordPage(),
  };
}