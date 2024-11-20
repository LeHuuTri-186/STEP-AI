import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../features/chat/domain/entity/message.dart';
import '../styles/colors.dart';

class MessageTile extends StatelessWidget {
  final Message currentMessage;

  const MessageTile({
    super.key,
    required this.currentMessage,
  });

  @override
  Widget build(BuildContext context) {
    bool isAI = currentMessage.role == "model";
    return Row(
      mainAxisAlignment: isAI ? MainAxisAlignment.start : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isAI)
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset(
              currentMessage.assistant.logoPath!,
              width: 30,
              height: 30,
            ),
          ),
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 2 / 3,
          ),
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: isAI ? TColor.doctorWhite : TColor.tamarama,
            borderRadius: BorderRadius.circular(10),
          ),

          child: currentMessage.content != null
              ? MarkdownBody(
                  data: currentMessage.content!,
                  styleSheet: MarkdownStyleSheet(
                    a: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isAI ? TColor.squidInk : TColor.doctorWhite,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                    p: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isAI ? TColor.squidInk : TColor.doctorWhite,
                          fontSize: 15,
                          fontWeight: isAI ? FontWeight.w500 : FontWeight.w600,
                        ),
                  ),
                )
              : LoadingAnimationWidget.threeArchedCircle(
                  color: isAI ? TColor.petRock : TColor.tamarama,
                  size: 12,
                ),
          // child: MarkdownBody(
          //   data: currentMessage.content,
          // styleSheet: MarkdownStyleSheet(
          //   p: TextStyle(
          //     color: isAI ? Colors.black : Colors.indigo,
          //   ),
          //   code: TextStyle(
          //     backgroundColor: isAI ? Colors.grey[400] : Colors.blue[400],
          //     color: isAI ? Colors.black : Colors.white,
          //   ),
          // ),
          // ),
        ),
      ],
    );
  }
}
