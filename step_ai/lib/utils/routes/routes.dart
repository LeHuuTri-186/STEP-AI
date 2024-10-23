import 'package:flutter/material.dart';
import 'package:step_ai/pages/chat_page/chatPage.dart';
import 'package:step_ai/pages/email_page/emailPage.dart';
import 'package:step_ai/pages/plan_pricing_page/planPricingPage.dart';

import '../../pages/personal_page/personalPage.dart';

class Routes {
  Routes._();

  //static variables
  static const String splash = '/splash';
  static const String chat = '/chat';
  static const String personal = '/personal';
  static const String email = '/email';
  static const String planAndPricing = "/planAndPricing";

  static final routes = <String, WidgetBuilder>{
    personal: (BuildContext context) => PersonalPage(),
    chat: (BuildContext context) => ChatPage(chatName: "Chat"),
    email: (BuildContext context) => EmailPage(),
    planAndPricing: (BuildContext context) => PlanPricingPage()
  };
}