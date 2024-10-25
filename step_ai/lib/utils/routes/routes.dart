import 'package:flutter/material.dart';
import 'package:step_ai/pages/chat_page/chatPage.dart';
import 'package:step_ai/pages/email_page/emailPage.dart';
import 'package:step_ai/pages/forgot_password_page/forgotPassword.dart';
import 'package:step_ai/pages/plan_pricing_page/planPricingPage.dart';
import 'package:step_ai/pages/prompt_list_page/promptList.dart';
import 'package:step_ai/pages/sign_in_page/signIn.dart';

import '../../pages/personal_page/personalPage.dart';
import '../../pages/sign_up_page/signUp.dart';

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
    signIn: (BuildContext context) => SignInApp(),
    signUp: (BuildContext context) => SignUpApp(),
    promptList: (BuildContext context) => PromptApp(),
    forgotPassword: (BuildContext context) => ForgotPasswordApp(),
  };
}