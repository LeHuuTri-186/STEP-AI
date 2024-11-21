import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atelier-forest-dark.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart'; // For Clipboard API
import 'package:markdown/markdown.dart' as md;
import 'package:step_ai/shared/styles/colors.dart';

class CodeBlockHighlightBuilder extends MarkdownElementBuilder {
  final bool isAi;
  CodeBlockHighlightBuilder({required this.isAi});

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    // Extract code content as a string
    final code = element.textContent;

    // Check if the code is a block or inline
    final isBlockCode = element.tag == 'code' && element.attributes['class'] != null;

    // Define custom theme for AI-styled code blocks
    final customTheme = Map<String, TextStyle>.from(atelierForestDarkTheme)
      ..addAll({
        'root': TextStyle(
          backgroundColor: Colors.transparent, // Remove background color
          color: TColor.squidInk, // Default text color
        ),
      });

    if (isBlockCode) {
      if (isAi) {
        // AI-styled code block (with copy button and special styles)
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: TColor.northEastSnow.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Allow horizontal scrolling
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: HighlightView(
                    code.replaceAll(RegExp(r'[\r\n]+$'), ''),
                    language: 'python',
                    theme: customTheme, // Use the modified theme
                    textStyle: GoogleFonts.jetBrainsMono(
                      fontSize: 15.0, // Consistent font
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8.0,
              right: 8.0,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  splashColor: TColor.petRock.withOpacity(0.5),
                  child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Icon(Icons.copy, size: 16.0, color: TColor.squidInk),
                  )),
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: code));
                  },
                ),
              ),
            ),
          ],
        );
      } else {
        // Standard code block (only scrolling, no styles)
        return Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                code,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 15.0,
                  color: Colors.black, // Standard text color
                ),
              ),
            ),
          ),
        );
      }
    } else {
      // Inline code (render without copy button)
      if (isAi) {
        return Container(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
        decoration: BoxDecoration(
          color: TColor.northEastSnow.withOpacity(0.5),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Text(
          code,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            color: TColor.squidInk, // Adjust the text color as needed
          ),
        ),
      );
      } else {
        return Text(
          code,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            color: TColor.squidInk, // Adjust the text color as needed
          ),
        );
      }
    }
  }
}
