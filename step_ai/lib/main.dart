import 'package:flutter/material.dart';
import 'package:step_ai/screens/promptList.dart';
import 'package:step_ai/screens/signIn.dart';
import 'package:step_ai/screens/signUp.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: SignUpApp(),
    );
    throw UnimplementedError();
  }
}