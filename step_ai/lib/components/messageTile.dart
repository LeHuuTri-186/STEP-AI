import 'package:flutter/material.dart';

class MessageTile extends StatelessWidget {
  final bool isAI;
  final String message;
  final IconData? iconSendObject;

  const MessageTile({
    super.key,
    required this.isAI,
    required this.message,
    this.iconSendObject,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isAI ? MainAxisAlignment.start : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isAI && iconSendObject != null)
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Icon(iconSendObject, color: Colors.blue),
          ),

        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 2 / 3,
          ),
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: isAI ? Colors.grey[300] : Colors.blue[300],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            message,
            style: TextStyle(
              color: isAI ? Colors.black : Colors.indigo,
            ),
          ),
        ),
      ],
    );
  }
}
