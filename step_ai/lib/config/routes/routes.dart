import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/core/di/service_locator.dart';

import 'package:step_ai/features/authentication/notifier/login_notifier.dart';
import 'package:step_ai/features/authentication/notifier/register_notifier.dart';
import 'package:step_ai/features/authentication/notifier/ui_notifier.dart';

import 'package:step_ai/features/authentication/presentation/pages/authenticate.dart';

import 'package:step_ai/features/chat/presentation/pages/chat_page.dart';

import 'package:step_ai/features/authentication/presentation/pages/forgot_password_page.dart';

import 'package:step_ai/features/plan/presentation/pages/planPricingPage.dart';
import 'package:step_ai/features/prompt/presentation/pages/prompt_list.dart';
import 'package:step_ai/features/units_in_knowledge/presentation/pages/confluence_page.dart';
import 'package:step_ai/features/units_in_knowledge/presentation/pages/drive_page.dart';
import 'package:step_ai/features/units_in_knowledge/presentation/pages/local_file_page.dart';
import 'package:step_ai/features/units_in_knowledge/presentation/pages/slack_page.dart';
import 'package:step_ai/features/units_in_knowledge/presentation/pages/units_page.dart';
import 'package:step_ai/features/units_in_knowledge/presentation/pages/web_page.dart';

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
  static const String unitsPage = "/unitsPage";
  //Page in unit
  static const String localFilePage="/localFilePage";
  static const String webPage="/webPage";
  static const String confluencePage="/confluencePage";
  static const String drivePage="/drivePage";
  static const String slackPage="/slackPage";

  static final routes = <String, WidgetBuilder>{
    personal: (BuildContext context) => Builder(builder: (context) {
          return const PersonalPage();
        }),

    chat: (BuildContext context) => Builder(
          builder: (context) {
            return const ChatPage();
          },
        ),
    planAndPricing: (BuildContext context) => PlanPricingPage(),
    unitsPage: (BuildContext context) => UnitsPage(),
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
    localFilePage: (BuildContext context) => LocalFilePage(),
    webPage: (BuildContext context) => WebPage(),
    slackPage: (BuildContext context) => SlackPage(),
    confluencePage: (BuildContext context) => ConfluencePage(),
    drivePage: (BuildContext context) => DrivePage(),
  };
}
