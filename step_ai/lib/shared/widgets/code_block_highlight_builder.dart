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
    final isBlockCode = element.tag == 'code' && element.attributes['class'] != null;
    final code = element.textContent;

    // Extract language from the class attribute, e.g., "language-python"
    final language = isBlockCode
        ? (element.attributes['class']?.replaceFirst('language-', '') ?? 'plaintext')
        : null;

    final customTheme = Map<String, TextStyle>.from(atelierForestDarkTheme)
      ..addAll({
        'root': TextStyle(
          backgroundColor: Colors.transparent,
          color: TColor.squidInk, // Default text color
        ),
      });

    return Container(
      margin: isBlockCode
          ? const EdgeInsets.symmetric(vertical: 4.0) // For block code
          : const EdgeInsets.symmetric(horizontal: 4.0), // For inline code
      padding: isBlockCode
          ? const EdgeInsets.all(8.0)
          : const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
      decoration: BoxDecoration(
        color: isBlockCode
            ? TColor.northEastSnow.withOpacity(0.2) // Background for block code
            : TColor.northEastSnow.withOpacity(0.5), // Background for inline code
        borderRadius: BorderRadius.circular(isBlockCode ? 8.0 : 4.0),
      ),
      child: isBlockCode
          ? Stack(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: HighlightView(
              code.replaceAll(RegExp(r'[\r\n]+$'), ''), // Trim trailing lines
              language: language, // Use extracted language
              theme: customTheme,
              textStyle: GoogleFonts.jetBrainsMono(fontSize: 15.0),
            ),
          ),
          if (isAi)
            Positioned(
              right: 0.0,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  splashColor: TColor.petRock.withOpacity(0.5),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Icon(Icons.copy, size: 16.0, color: TColor.squidInk),
                  ),
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: code));
                  },
                ),
              ),
            ),
        ],
      )
          : Text(
        code.replaceAll('\n', ' '), // Prevent unintended line breaks
        style: GoogleFonts.jetBrainsMono(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          color: TColor.squidInk,
        ),
        softWrap: true,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
