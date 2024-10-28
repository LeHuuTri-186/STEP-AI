import 'package:flutter/material.dart';
import 'package:step_ai/pages/chat_page/chatPage.dart';
import 'package:step_ai/pages/plan_pricing_page/planPricingPage.dart';
import 'package:step_ai/utils/routes/routes.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Step AI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      routes: Routes.routes,
      initialRoute: Routes.signIn,
      home: ChatPage(chatName: "Chat"),
    );
  }
}
