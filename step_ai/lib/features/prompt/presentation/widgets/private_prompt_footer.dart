import 'package:flutter/material.dart';

import '../../../../shared/styles/colors.dart';
import '../../../../shared/styles/horizontal_spacing.dart';
import '../../../../shared/styles/vertical_spacing.dart';

class PrivatePromptFooter extends StatelessWidget {
  const PrivatePromptFooter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Find more prompt(s) in ",
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: TColor.petRock,
              ),
            ),
            HSpacing.sm,
            GestureDetector(
              onTap: () {},
              child: Text(
                "Public prompts",
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: TColor.tamarama,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        VSpacing.sm,
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "or ",
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                ),
              ),
              HSpacing.sm,
              GestureDetector(
                onTap: () {},
                child: Text(
                  "Create your own prompt",
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: TColor.tamarama,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}