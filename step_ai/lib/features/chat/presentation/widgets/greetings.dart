import 'package:flutter/material.dart';

class GreetingMessage extends StatelessWidget {
  const GreetingMessage({Key? key}) : super(key: key);

  // Function to determine the greeting based on the time of day
  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "Hi, good morning!";
    } else if (hour < 18) {
      return "Hi, good afternoon!";
    } else {
      return "Hi, good evening!";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      maxLines: 2,
      getGreeting(), // Dynamic greeting message
      style: Theme.of(context).textTheme.titleLarge,
      softWrap: true, // Allows line wrapping
      textAlign: TextAlign.center, // Centers text
      overflow: TextOverflow.visible, // Ensures all text is shown
    );
  }
}
