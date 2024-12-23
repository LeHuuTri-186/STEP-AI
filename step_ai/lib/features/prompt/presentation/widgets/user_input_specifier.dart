

import 'package:flutter/material.dart';

import '../../../../shared/styles/colors.dart';
import '../../../../shared/styles/horizontal_spacing.dart';

class userInputSpecifier extends StatelessWidget {
  const userInputSpecifier({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TColor.tamarama.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Icon(Icons.info_rounded, color: TColor.tamarama,),
              HSpacing.sm,
              Text(
                maxLines: 2,
                "Use square brackets [ ] to specify user input.",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: TColor.squidInk,
                    fontSize: 13
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
