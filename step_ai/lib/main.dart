import 'package:flutter/material.dart';
import 'package:step_ai/components/chatBar.dart';
import 'package:step_ai/pages/chatPage.dart';

import 'components/historyDrawer.dart';

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
      home: Scaffold(
        drawer: HistoryDrawer(),
        appBar: AppBar(
          title: const Text('Step AI',style: TextStyle(fontSize: 25),),
          backgroundColor: Colors.blue[900],
        ),
        body: const ChatPage(),
      ),
    );
  }
}
