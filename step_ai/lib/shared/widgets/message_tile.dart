import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../features/chat/domain/entity/message.dart';
import '../styles/colors.dart';

import 'code_block_highlight_builder.dart'; // Example theme

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
            builders: {
              'code': CodeBlockHighlightBuilder(isAi: isAI), // Custom syntax highlighter
            },
            softLineBreak: true,
            data: currentMessage.content!,
            styleSheet: MarkdownStyleSheet(

              // Code block decoration with consistent rounded edges and light background
              codeblockDecoration: BoxDecoration(
                color: TColor.northEastSnow.withOpacity(0.5), // Light background color
                borderRadius: BorderRadius.circular(10),
              ),
              // Code text style
              code: GoogleFonts.jetBrainsMono(
                fontSize: 15, // Consistent font size for code
                color: TColor.daJuice,
                fontWeight: FontWeight.w600// Code text color
              ),
              // Hyperlink text style
              a: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isAI ? TColor.squidInk : TColor.doctorWhite,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              // Paragraph text style
              p: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isAI ? TColor.squidInk : TColor.doctorWhite,
                fontSize: 16,
                fontWeight: isAI ? FontWeight.normal : FontWeight.w600,
              ),
              // Other text styles (headers, blockquote, etc.)
              h1: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: TColor.squidInk,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              blockquote: TextStyle(
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
          )

              : LoadingAnimationWidget.staggeredDotsWave(
                  color: isAI ? TColor.petRock : TColor.tamarama,
                  size: 20,
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