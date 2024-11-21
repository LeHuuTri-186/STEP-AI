import 'package:flutter/material.dart';

import '../styles/colors.dart';

class ImageByText extends StatelessWidget {
  final String imagePath; // Path to the image
  final String text; // Text to display
  final TextStyle? textStyle; // Customizable text style
  final double imageSize; // Size of the image
  final double spacing; // Space between image and text

  const ImageByText({
    Key? key,
    required this.imagePath,
    required this.text,
    this.textStyle,
    this.imageSize = 15.0,
    this.spacing = 6.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(30),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: TColor.northEastSnow,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image widget
                SizedBox(
                  width: imageSize,
                  height: imageSize,
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: spacing), // Space between image and text
                // Text widget
                Text(
                  text,
                  style: textStyle ??
                      Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: TColor.slate
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
